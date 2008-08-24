Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbYHXIXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbYHXIXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 04:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751595AbYHXIW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 04:22:58 -0400
Received: from po-out-1718.google.com ([72.14.252.152]:35546 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751583AbYHXIWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 04:22:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=VSXwnXHa/yq2zjVD8ZgndzVVubEbMD/Khuw5nOGvYGcuYe6f7yiC9azV+wfnNbWqWA
         7g8gLAxlPAojvUMYtVdBCQognAgsekAXcLf2jpEBvSeD9PQ6AIC/2/Yi+KCQQCPLP0jV
         oetnU0+VmnY74hl0f9p8d4RZ1U06jdK8YwQC8=
Message-ID: <86802c440808240122r64ac91beu68e7782d5056bbb3@mail.gmail.com>
Date: Sun, 24 Aug 2008 01:22:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: 9a2d43b: __alloc_bootmem_core(): zero-sized request
Cc: "Johannes Weiner" <hannes@saeurebad.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <19f34abd0808240058h3d286151x18cba0939f175edd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808221224s4674e5aaq34bd0a874dfba699@mail.gmail.com>
	 <87myj4yzll.fsf@skyscraper.fehenstaub.lan>
	 <19f34abd0808240058h3d286151x18cba0939f175edd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 12:58 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sat, Aug 23, 2008 at 9:12 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
>> "Vegard Nossum" <vegard.nossum@gmail.com> writes:
>>>
>>> I was trying out
>>>
>>> commit 9a2d43b7566caeeeb414aa628bc2759028897dbb
>>> Date:   Tue Jul 15 21:21:43 2008 +0200
>>>
>>> ..as part of the debugging of a different issue, but I got this:
>>>
>>> __alloc_bootmem_core(): zero-sized request
>
> [...]
>
>>> I saw some bootmem errata lately, can I cherry-pick anything to fix
>>> this?
>>
>> This behaviour hasn't changed after the rewrite.
>
> Yep, the error is somewhere else.
>
> Inserted a printk("nr_kernel_pages = %llu\n", nr_kernel_pages); and
> this is the output:
>
> nr_kernel_pages = 13869392367443771392
>
> ...it looks very, very big. I think this is initialized via
> free_area_init_*() functions, which come from arch code. Does x86
> experts know if any of this changed recently (i.e. after July 15)?
>
> The whole dmesg and config can be seen here:
> http://userweb.kernel.org/~vegard/bugs/20080824-numa/
>

seems something wrong about apic probe...

MPTABLE: OEM ID: Intel    Product ID: Lakeport     Warning!  May not
be a NUMA-Q system!
MPTABLE: Product ID: Lakeport     <6>MPTABLE: APIC at: 0xFEE00000
Processor #0 15:6 APIC version 20 (quad 0, apic 1)
Processor #0 (Bootup-CPU)
Bus #0 is PCI    (node 0)
Bus #1 is PCI    (node 0)
Bus #2 is PCI    (node 0)
Bus #3 is ISA    (node 0)
I/O APIC #2 Version 32 at 0xFEC00000.
Enabling APIC mode:  NUMA-Q.  Using 1 I/O APICs


please check with tip/master to see if it is fixed already...

YH
