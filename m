Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYLBT2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYLBT2Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 14:28:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751459AbYLBT2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 14:28:16 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbYLBT2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 14:28:15 -0500
Date: Tue, 2 Dec 2008 20:27:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH] x86: fix broken flushing in GART nofullflush path
Message-ID: <20081202192759.GD15342@elte.hu>
References: <1228245363-14909-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228245363-14909-1-git-send-email-joerg.roedel@amd.com>
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


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> In the non-default nofullflush case the GART is only flushed when
> next_bit wraps around. But it can happen that an unmap operation unmaps
> memory which is behind the current next_bit location. If these addresses
> are reused it may result in stale GART IO/TLB entries. Fix this by
> setting the GART next_bit always behind an unmapped location.
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/kernel/pci-gart_64.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

applied to tip/x86/iommu, thanks Joerg!

a stale iotlb should not cause any problems in this particular GART case, 
right? It might be a security leak in a security-domain enforcing iotlb 
case, but the GART is a DMA bouncing helper in essence. Can you see any 
failure mode of this bug?

	Ingo
