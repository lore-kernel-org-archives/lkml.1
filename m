Return-Path: <linux-kernel-owner+w=401wt.eu-S1756362AbYEKDD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbYEKDD4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2008 23:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbYEKDDq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 May 2008 23:03:46 -0400
Received: from smtp1.betherenow.co.uk ([87.194.0.68]:55615 "HELO
	smtp1.betherenow.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754170AbYEKDDp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2008 23:03:45 -0400
From: Alistair John Strachan <alistair@devzero.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: enable hpet=force for AMD SB400
Date: Sun, 11 May 2008 04:02:20 +0100
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, andreas.herrmann3@amd.com,
       mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org
References: <20080509094911.GG5023@alberich.amd.com> <alpine.LFD.1.10.0805100140490.3197@apollo.tec.linutronix.de> <20080509165501.a0fdb29d.akpm@linux-foundation.org>
In-Reply-To: <20080509165501.a0fdb29d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805110402.20327.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 May 2008 00:55:01 Andrew Morton wrote:
> On Sat, 10 May 2008 01:42:30 +0200 (CEST)
>
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 9 May 2008, Andrew Morton wrote:
> > > On Fri, 9 May 2008 11:49:11 +0200
> > >
> > > Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> > > > x86: enable hpet=force for ATI SB400
> > >
> > > Sigh.
> > >
> > > > Add quirk to allow forced usage of HPET on ATI SB400.
> > > > I stumbled over machines where HPET is enabled but not reported
> > > > by BIOS.
> > >
> > > Is there no way in which we can probe for or identify this condition,
> > > rather than hoping that the user will find out about this boot option?
> >
> > I'd love to have a sane solution for that, but looking at the rate of
> > HPET wreckage since we increased the usage of HPET I'm happy to have
> > this as an opt in thingy.
>
> Well we don't have to auto-enable the hpet.  Simply adding a loud "you
> should try the hpet=force option" printk would help a lot of people.

I'm a bit confused about the policy here: if we look at the Intel chipset 
overrides for HPET, they conditionally enable the HPET _without_ the 
hpet=force option if you have a chipset on the whitelist.

If Intel can do this on their chipsets, why is this not being done for the ATI 
chipsets for which (presumably) AMD have specs?

One thing I'd considered was that HPET isn't actually used very often on Intel 
chipsets because on most recent Intel CPUs the TSC is stable, but I think 
either the Intel quirk should be consistent with the hpet=force usage, 
or "known correct" HPET overrides should just always be applied.

-- 
Cheers,
Alistair.

137/1 Warrender Park Road, Edinburgh, UK.
