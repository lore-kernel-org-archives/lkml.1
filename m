Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbYDTM6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbYDTM6d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 08:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753298AbYDTM6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 08:58:23 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52068 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbYDTM6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 08:58:22 -0400
Message-ID: <480B3DE4.5070204@firstfloor.org>
Date: Sun, 20 Apr 2008 14:58:12 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v3)
References: <20080414230344.GA16061@Krystal> <20080414230530.GB16061@Krystal> <20080416130605.GG6304@elte.hu> <20080416151054.GA32456@elte.hu> <20080416162810.GA20450@Krystal> <48063E19.9090701@goop.org> <20080417162932.GA23351@Krystal> <48077EB2.9030009@firstfloor.org> <20080418000551.GA5062@Krystal> <48085B73.3070904@firstfloor.org> <20080419211817.GC1554@Krystal>
In-Reply-To: <20080419211817.GC1554@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> First, log_sample writes into the vmalloc'd cpu buffer. That's for one
>>> possible page fault.
>>  
>>> Then, is a kernel backtrace happen, then I am not sure if printk_address
>>> won't try to read any of the module data, which is vmalloc'd.
>> Yes, admittedly the backtrace mode was always somewhat flakey. It probably
>> has more problems too.
>>
>> The right fix for that is to call vmalloc_sync_all() after module load
>> when any nmi notifiers are registered.
> 
> I guess it would work, but it certainly looks like a patchy workaround.

Actually i was wrong earlier on this. The backtrace should not access
any vmalloc data, only the stack which is not vmalloced. oprofile does
address resolving in user space. It will access the module struct,
but that one is not vmalloc'ed and I don't think it will access anything
else vmalloc'ed

I was thinking earlier of the dwarf2 unwinder case where it could have
happened when accessing the unwind table, but that is not mainline code
currently.

So oprofile is ok without any changes.

-Andi



