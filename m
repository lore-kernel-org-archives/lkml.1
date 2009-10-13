Return-Path: <linux-kernel-owner+w=401wt.eu-S933556AbZJMHEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556AbZJMHEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 03:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933533AbZJMHEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 03:04:08 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933527AbZJMHEG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 03:04:06 -0400
Date: Tue, 13 Oct 2009 09:03:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Message-ID: <20091013070311.GB31483@elte.hu>
References: <4AC97C00.7090503@kernel.org> <200910061257.54877.bjorn.helgaas@hp.com> <20091012203453.GC7648@elte.hu> <200910121545.47794.bjorn.helgaas@hp.com> <4AD3A460.6060505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD3A460.6060505@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 10/12/2009 02:45 PM, Bjorn Helgaas wrote:
>
> > For the patch in question, we don't even have a root cause for the 
> > bug (or at least, I couldn't decipher it from the changelog). 
> > There's a reference to _CRS being wrong, but we don't currently use 
> > _CRS for x86 host bridges.
> > 
> > But in general, my objection is that even if BIOS provides perfectly 
> > valid information about host bridge apertures, the the fact that 
> > Linux ignores that information means we have to add this sort of 
> > vendor- specific code every time we trip over something. And we're 
> > tripping over things quite often.
> > 
> > Windows consumes this _CRS information, so while I grant there are 
> > certainly BIOS bugs there, I think most of the bugs are actually in 
> > Linux.
> 
> I think the right policy for most if not all things should be "use the 
> BIOS information unless we know better."

My argument is that if we know how to access the hardware and know how 
to interpret its state then that is _ALWAYS_ higher quality information 
than anything the BIOS tells us.

Basically the BIOS is a second-level fall-back, and the less we have to 
use this fall-back in Linux, the better. In many cases we have no other 
info but BIOS info - that puts all our eggs into the BIOS basket and we 
have to live with that.

And reducing that dependency on the BIOS is what Yinghai's patch is 
doing in essence - it adds a higher-grade source of information: reading 
the PCI config space directly.

( I make no argument about the specific correctness of the patch - i 
  just raised the principle and i think we should move in this direction 
  in general. )

Thanks,

	Ingo
