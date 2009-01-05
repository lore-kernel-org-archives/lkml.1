Return-Path: <linux-kernel-owner+w=401wt.eu-S1754083AbZAENFB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083AbZAENFB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 08:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbZAENEv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 08:04:51 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbZAENEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 08:04:50 -0500
Date: Mon, 5 Jan 2009 14:04:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86 PCI: Do not use interrupt links for devices using
	MSI-X
Message-ID: <20090105130439.GA6014@elte.hu>
References: <200901042308.42625.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901042308.42625.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> pcibios_enable_device() and pcibios_disable_device() don't handle
> IRQs for devices that have MSI enabled and it should tread the

s/tread/treat

> devices with MSI-X enabled in the same way.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/pci/common.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

looks good - Jesse, what do you think?

Rafael, i'm curious is this in response to some regression/bug? Did some 
box or driver get confused by us enabling/disabling the GSI? Some IRQ 
flood perhaps?

btw., there's a small observation:

> +     if (!dev->msi_enabled && !dev->msix_enabled)

maybe a "pci_has_gsi_irq()" wrapper would make these checks cleaner and 
would make things more robust, should there be any new IRQ delivery method 
be introduced in the future?

	Ingo
