Return-Path: <linux-kernel-owner+w=401wt.eu-S1754102AbXD0HHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbXD0HHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 03:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbXD0HHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 03:07:38 -0400
Received: from gw.goop.org ([64.81.55.164]:42307 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbXD0HHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 03:07:36 -0400
Message-ID: <4631A157.9040702@goop.org>
Date: Fri, 27 Apr 2007 00:08:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Ian Pratt <ian.pratt@xensource.com>,
       Christian Limpach <Christian.Limpach@cl.cam.ac.uk>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [PATCH 06/25] xen: Core Xen implementation
References: <20070423215638.563901986@goop.org> <20070423215710.355105690@goop.org> <200704242325.23447.ak@suse.de>
In-Reply-To: <200704242325.23447.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> +	/* convert from IF type flag */
>> +	flags = !(flags & X86_EFLAGS_IF);
>> +	vcpu = x86_read_percpu(xen_vcpu);
>> +	vcpu->evtchn_upcall_mask = flags;
>> +	if (flags == 0) {
>> +		barrier(); /* unmask then check (avoid races) */
>>     
>
> Don't you need a rmb() here then? The CPU could speculate reads
> (more occurrences) 
>   

Is rmb() sufficient?  It will stop a speculative read on the pending
flag, but will it make sure the write has happened by then?  Ie, is it a
write-vs-read barrier, or just a read-vs-read? 
Documentation/memory-barriers.txt suggests not.

    J
