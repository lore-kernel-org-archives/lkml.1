Return-Path: <linux-kernel-owner+w=401wt.eu-S1161264AbXCNUro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161264AbXCNUro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 16:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161338AbXCNUro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 16:47:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161264AbXCNUrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 16:47:42 -0400
To: Tejun Heo <htejun@gmail.com>
Cc: gregkh@suse.de, Jeff Garzik <jeff@garzik.org>,
       linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       michal.k.k.piotrowski@gmail.com, linux-ide@vger.kernel.org,
       tglx@linutronix.de, shemminger@linux-foundation.org, mlord@pobox.com,
       linux-pm@lists.osdl.org
Subject: Re: [PATCH/RFC] PCI prepare/activate instead of enable to avoid IRQ storm and rogue DMA access
References: <20070314152302.GB15600@htj.dyndns.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 14 Mar 2007 22:46:47 +0100
In-Reply-To: <20070314152302.GB15600@htj.dyndns.org>
Message-ID: <p73fy878pmg.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> writes:
> 
> Let's assume there's a device which shares its INTX IRQ line with
> another device and the other one is already initialized.  During boot,
> due to BIOS's fault, bad hardware design or sheer bad luck, the device
> has got a pending IRQ.

This seems to be also common after kexec during kexec crashdumps
where the device just continues doing what it did before the crash.

> This patch expands the pci_set_master() approach.  Instead of enabling
> the device in one go, it's done in two steps - prepare and activate.
> 'prepare' enables access to PCI configuration,

I hope there aren't any new erratas triggered by this. Perhaps it would
make sense to add some paranoia sleeps at least before touching other
state? 

-Andi
