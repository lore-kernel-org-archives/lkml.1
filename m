Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYEKJEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYEKJEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 05:04:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYEKJEL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 05:04:11 -0400
Received: from www.tglx.de ([62.245.132.106]:58348 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbYEKJEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 05:04:10 -0400
Date: Sun, 11 May 2008 11:03:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alistair John Strachan <alistair@devzero.co.uk>
cc: Andrew Morton <akpm@linux-foundation.org>, andreas.herrmann3@amd.com,
       mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
In-Reply-To: <200805110402.20327.alistair@devzero.co.uk>
Message-ID: <alpine.LFD.1.10.0805111059190.3197@apollo.tec.linutronix.de>
References: <20080509094911.GG5023@alberich.amd.com> <alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de> <20080509165501.a0fdb29d.akpm@linux-foundation.org> <200805110402.20327.alistair@devzero.co.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008, Alistair John Strachan wrote:
> > Well we don't have to auto-enable the hpet.  Simply adding a loud "you
> > should try the hpet=force option" printk would help a lot of people.
> 
> I'm a bit confused about the policy here: if we look at the Intel chipset 
> overrides for HPET, they conditionally enable the HPET _without_ the 
> hpet=force option if you have a chipset on the whitelist.
> 
> If Intel can do this on their chipsets, why is this not being done for the ATI 
> chipsets for which (presumably) AMD have specs?

Well, we have no confirmation for the correctness of the non Intel
quirks so far. I'm happy to move them into unconditional mode once
AMD/ATI/NVidia tell us that the HPET is indeed discoverable this way.
 
> One thing I'd considered was that HPET isn't actually used very often on Intel 
> chipsets because on most recent Intel CPUs the TSC is stable, but I think 

Well, stable except for the C-States. We still need a backup clock
source as TSC is stopping in C3.

> either the Intel quirk should be consistent with the hpet=force usage, 
> or "known correct" HPET overrides should just always be applied.

That's what we do. We have "known correct" for Intel and those which
work on the patch submitters box w/o confirmation of the
correctness. I guess the SB400 one can move into the "is correct"
category, Andreas ???

Thanks,

	tglx
