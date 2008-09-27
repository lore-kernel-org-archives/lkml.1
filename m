Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYI0Uy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYI0Uy4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbYI0Uys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:54:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48186 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbYI0Uyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:54:47 -0400
Date: Sat, 27 Sep 2008 22:53:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Frans Pop <elendil@planet.nl>, Rene Herman <rene.herman@keyaccess.nl>,
       linux-kernel@vger.kernel.org, Rene Herman <rene.herman@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Wilcox <matthew@wil.cx>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bug #11550] pnp: Huge number of "io resource overlap" messages
Message-ID: <20080927205357.GC31650@elte.hu>
References: <200809091250.08620.elendil@planet.nl> <200809210149.07755.elendil@planet.nl> <200809201756.25157.bjorn.helgaas@hp.com> <200809261540.31443.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809261540.31443.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> The problem seems to be that Frans has some PCI devices that are not 
> configured by the BIOS, and their BARs contain zero.  A PNP quirk 
> checks for overlaps of PCI devices and PNP devices, and those zero- 
> valued BARs of course conflict with the PNP motherboard devices that 
> describe legacy hardware.
> 
> Here's another approach based on section 3.5 of the PCI Firmware spec.
> It says:
> 
>   Since not all devices may be configured prior to the operating
>   system handoff, the operating system needs to know whether a
>   specific BAR register has been configured by firmware. The operating
>   system makes the determination by checking the I/O Enable, and
>   Memory Enable bits in the device's command register, and Expansion
>   ROM BAR enable bits. If the enable bit is set, then the corresponding
>   resource register has been configured.
> 
> So instead of checking whether the BAR contains zero, the patch below
> checks the I/O, Mem, and ROM BAR enable bits to determine whether a
> BAR is enabled.

cool! Looks like a pretty significant fix, for all sorts of legacy 
devices. Worth backporting?

	Ingo
