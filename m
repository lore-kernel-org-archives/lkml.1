Return-Path: <linux-kernel-owner+w=401wt.eu-S1752050AbYJ0Pc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbYJ0Pc3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 11:32:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751407AbYJ0PcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 11:32:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59923 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752852AbYJ0PcR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 11:32:17 -0400
Date: Mon, 27 Oct 2008 16:31:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       torvalds@linux-foundation.org, Matthew Wilcox <matthew@wil.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: RFC: [PATCH] resource: ensure MMIO exclusivity for device
	drivers
Message-ID: <20081027153158.GJ5704@elte.hu>
References: <20081022205656.184929ed@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081022205656.184929ed@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> 
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Wed, 22 Oct 2008 19:55:31 -0700
> Subject: [PATCH] resource: ensure MMIO exclusivity for device drivers
> 
> Device drivers that use pci_request_regions() (and similar APIs) have a
> reasonable expectation that they are the only ones accessing their device.
> As part of the e1000e hunt, we were afraid that some userland (X or some
> bootsplash stuff) was mapping the MMIO region that the driver thought it
> had exclusively via /dev/mem or via various sysfs resource mappings.
> 
> This patch adds the option for device drivers to cause their reserved
> regions to be on the "banned from /dev/mem use" list, so now both kernel memory
> and device-exclusive MMIO regions are banned.
> NOTE: This is only active when CONFIG_STRICT_DEVMEM is set.
> 
> In addition to the config option, a kernel parameter iomem=relaxed is
> provided for the cases where developers want to diagnose, in the field,
> drivers issues from userspace despite the drivers explicit request.
> 
> Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>

the concept looks fine to me - the stricter we are in this area the 
better IMO. Unless there are objections, i guess it's best to do this 
via the PCI tree?

	Ingo
