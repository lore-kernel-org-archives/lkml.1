Return-Path: <linux-kernel-owner+w=401wt.eu-S932363AbZJLUfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932363AbZJLUfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 16:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbZJLUfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 16:35:53 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39937 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756622AbZJLUfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 16:35:52 -0400
Date: Mon, 12 Oct 2009 22:34:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86/pci: intel bus root res with IOH reading -v2
Message-ID: <20091012203453.GC7648@elte.hu>
References: <4AC97C00.7090503@kernel.org> <200910061133.27546.bjorn.helgaas@hp.com> <4ACB839A.2060800@kernel.org> <200910061257.54877.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200910061257.54877.bjorn.helgaas@hp.com>
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


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Tuesday 06 October 2009 11:51:22 am Yinghai Lu wrote:
> > Bjorn Helgaas wrote:
> > > On Sunday 04 October 2009 10:54:24 pm Yinghai Lu wrote:
> > >> for intel system with multi IOH. we could read peer root resource from PCI conf,
> > >> and don't trust _CRS again for root bus
> > > 
> > > Ugh.  Are we going to end up with amd_bus.c, intel_bus.c, nvidia_bus.c,
> > > broadcom_bus.c, serverworks_bus.c, etc.?
> > only needed when you have muti ...
> 
> I think that translates to "yes, we will need all those bits as soon 
> as those vendors support larger systems with multiple IOHs."  And I 
> think that's the wrong answer.

Why is having cleanly separated per vendor information/driver wrong? I 
think it's the right answer in most cases. _Especially_ when the other 
option is to 'rely on the firmware'.

> > again we should trust HW conf than BIOS.
> 
> Certainly there's a tradeoff between a generic driver that relies on 
> the BIOS, and a platform-specific driver that uses only the hardware. 
> The first leaves us vulnerable to BIOS bugs, but the second leads to a 
> plethora of drivers that require updates as hardware changes.

We do that quite well in Linux - it's one of our main strengths.

Why should we have to rely on correct firmware? Why is it wrong to know 
about the hw's structure, to query the hardware and ignore the firmware 
if the hardware state tells us otherwise?

	Ingo
