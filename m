Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbXL3U5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbXL3U5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 15:57:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbXL3U5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 15:57:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43108 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbXL3U5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 15:57:30 -0500
Message-ID: <477805F1.4070201@zytor.com>
Date: Sun, 30 Dec 2007 12:56:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Rene Herman <rene.herman@keyaccess.nl>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <9FXbU-3M4-11@gated-at.bofh.it> <9G2Om-4hg-1@gated-at.bofh.it> <9G7O3-3O2-7@gated-at.bofh.it> <9G8qN-4TX-13@gated-at.bofh.it> <E1J92JB-00013N-P3@be1.7eggert.dyndns.org> <20071230181004.GA21968@elte.hu>
In-Reply-To: <20071230181004.GA21968@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Bodo Eggert <7eggert@gmx.de> wrote:
> 
>> BTW: The error function in 
>> linux-2.6.23/arch/i386/boot/compressed/misc.c uses while(1) without 
>> cpu_relax() in order to halt the machine. Is this fixed? Should it be 
>> fixed?
> 
> this is early bootup so there's no need to be "nice" to other cores or 
> sockets - none of them are really running.
> 

It probably should actually HLT, to avoid sucking power, and stressing 
the thermal system.  We're dead at this point, and the early 486's which 
had problems with HLT will lock up - we don't care.

	-hpa
