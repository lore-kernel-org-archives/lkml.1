Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbYKSJgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbYKSJgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbYKSJgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:36:37 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38303 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531AbYKSJgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:36:36 -0500
Date: Wed, 19 Nov 2008 10:36:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, joerg.roedel@amd.com,
       iommu@lists.linux-foundation.org, mingo@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
Message-ID: <20081119093611.GF22309@elte.hu>
References: <20081118154322.GX13394@amd.com> <20081119150504G.fujita.tomonori@lab.ntt.co.jp> <20081119092544.GD29705@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119092544.GD29705@8bytes.org>
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


* Joerg Roedel <joro@8bytes.org> wrote:

> We can't test all drivers for those bugs until 2.6.28 will be 
> released. And these bugs can corrupt data, for example when a driver 
> frees dma addresses allocated by another driver and these addresses 
> are then reallocated.
>
> The only way to protect the drivers from each other is to isolate 
> them in different protection domains. The AMD IOMMU driver prints a 
> WARN_ON() if a driver frees dma addresses not yet mapped. This 
> triggered with the bnx2 and the ixgbe driver.
>
> And the data corruption is real, it eat the root-fs of my testbox 
> one time.

a WARN_ON() can be acted upon much easier than silent/spurious data 
corruption. So printing a WARN_ON() will result in drivers being fixed 
a lot faster (and with a lot less debugging needed) than if we were 
intentionally letting DMA corruption happen. The WARN_ON() will be 
routed to kerneloops.org on the major distros, etc. etc.

> I agree that we need to fix the drivers. I plan to implement some 
> debug code which allows driver developers to detect those bugs even 
> if they have no IOMMU in the system.

That would be _really_ nice to have.

	Ingo
