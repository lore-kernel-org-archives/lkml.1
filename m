Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbYDTNWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbYDTNWe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 09:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114AbYDTNW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 09:22:27 -0400
Received: from rtr.ca ([76.10.145.34]:1771 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056AbYDTNW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 09:22:26 -0400
Message-ID: <480B4390.4010907@rtr.ca>
Date: Sun, 20 Apr 2008 09:22:24 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Shawn Bohrer <shawn.bohrer@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <20080419145948.GA4528@lintop> <20080420080901.GF1595@cs181133002.pp.htv.fi> <20080420090623.7b173ef1@the-village.bc.nu> <20080420085104.GG1595@cs181133002.pp.htv.fi> <20080420103611.2c0d3519@the-village.bc.nu> <20080420104444.GI1595@cs181133002.pp.htv.fi>
In-Reply-To: <20080420104444.GI1595@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>
> The code in the kernel that gets the fewest coverage at all are our 
> error paths, and some vendor might try 4k stacks, validate it works in 
> all use cases - and then it will blow up in some error condition he 
> didn't test.
..

That's exactly the worry.

If anyone want's to take a crack at testing some of the more likely
fail paths there, just introduce a media error onto a SATA disk
that's buried at the bottom of a stacked RAID1 over RAID0 over LVM,
with XFS and nfsd on top.

Or something like that.
And then experiment with corrupting meta data rather than simply file data.
How-to introduce a media error?  hdparm --make-bad-sector nnnnnn /dev/sdX

This catches the most likely (IMHO) failure scenarios,
but still comes nowhere near 100% code coverage.  :(

Cheers
