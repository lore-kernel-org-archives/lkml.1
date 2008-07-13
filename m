Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbYGMVB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbYGMVB7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 17:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755040AbYGMVBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 17:01:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34513 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbYGMVBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 17:01:50 -0400
Date: Sun, 13 Jul 2008 23:01:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Olaf Dabrunz <od@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jon Masters <jonathan@jonmasters.org>,
       Stefan Assmann <sassmann@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Ihno Krumreich <ihno@suse.de>, Sven Dietrich <sdietrich@suse.de>,
       Daniel Gollub <dgollub@suse.de>, Felix Foerster <ffoerster@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 0/3] Boot IRQ quirks for Broadcom and AMD/ATI
Message-ID: <20080713210133.GA12362@elte.hu>
References: <12155255883170-git-send-email-od@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12155255883170-git-send-email-od@suse.de>
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


* Olaf Dabrunz <od@suse.de> wrote:

> This is against linux-2.6-tip, branch pci-ioapic-boot-irq-quirks.
> 
> The corrected versions of the Broadcom and AMD/ATI boot IRQ quirks, 
> and a patch that uses DECLARE_PCI_FIXUP_FINAL instead of *_EARLY, and 
> adds *_RESUME.
> 
> The AMD/ATI SB700S does not need a quirk. The boot IRQs here are 
> active even when the IO-APIC lines are not masked. So even for 
> traditional IRQ handling that does not use masking, the boot IRQs need 
> to be disabled by the BIOS. If there are actual cases of BIOSes that 
> do not disable these boot IRQs in APIC mode, we could consider 
> including an SB700S patch. But I doubt this will be needed, as this 
> problem would quickly surface during testing with any general-purpose 
> OS.
> 
> The quirk for the AMD 8131 and AMD 8132 takes identical action as an 
> existing quirk for the AMD 8131 rev. A0 and B0. The existing quirk is 
> due to an AMD erratum to fix IO-APIC mode. Our patch now deletes the 
> older quirk and adds a comment to the new one that describes the two 
> purposes of the quirk.

applied to tip/x86/pci-ioapic-boot-irq-quirks, thanks Olaf.

Jesse, what do you think about this topic? We are keeping it separate 
for the time being. They are not particularly pretty, but being able to 
mask/unmask irqs (without generating those legacy IRQs and creating an 
IRQ storm) is essential to -rt.

	Ingo
