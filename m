Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZDBE0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZDBE0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZDBE0X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:26:23 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:32912 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbZDBE0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:26:22 -0400
Date: Thu, 02 Apr 2009 00:26:11 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Michael K. Johnson" <johnsonm@rpath.com>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Jordan Hargrave <Jordan_Hargrave@dell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [GIT PULL] x86 setup BIOS workarounds
In-reply-to: <alpine.LFD.2.00.0904011115210.4130@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0904020017480.4657@localhost.localdomain>
References: <200904011640.n31GeD0m008691@voreg.hos.anvin.org>
 <alpine.LFD.2.00.0904011115210.4130@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 1 Apr 2009, Linus Torvalds wrote:

> 
> 
> On Wed, 1 Apr 2009, H. Peter Anvin wrote:
> > 
> > implements handling for the backwards-incompatible(!) E820 handling in 
> > ACPI 3.
> 
> I am _extremely_ nervous about this one.
> 
> You do
> 
> 	size = sizeof buf;	/* ACPI-3 size */
> 	asm(.. "+c" (size)	/* size might change */
> 	..
> 	if (size > 20 && !(buf.ext_flags & 1))
> 		continue;
> 
> ie you are expecting that _all_ old pre-ACPI-3 BIOSES will always set size 
> to 20, or always write a low-bit-set value to that extended flag field 
> that doesn't even exist previously.

Yes, this expects old BIOS to always return 20.
No, it does not expect old BIOS to have any particular value
in buf.ext_flags -- since that is examined only for size > 20.

> I don't think that's likely true. Quite frankly, I'd expect a number of 
> BIOSen to entirely ignore %ecx, since it's irrelevant (it _has_ to be 
> bigger than 20 anyway on entry, and I doubt anybody really ever bothered 
> to test that it's 20 on exit).
> 
> So at a _minimum_, I'd suggest that we set bug.ext_flags to 1 before the 
> call - so that if some random BIOS just leaves %ecx unchanged, it won't 
> mean that the area just gets ignored as a ACPI-3 entry.

Good idea.

Len Brown, Intel Open Source Technology Center

