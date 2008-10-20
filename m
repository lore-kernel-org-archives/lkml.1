Return-Path: <linux-kernel-owner+w=401wt.eu-S1752692AbYJTQGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692AbYJTQGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYJTQGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:06:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44530 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYJTQGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:06:16 -0400
Date: Mon, 20 Oct 2008 18:06:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] x86: amd_iommu: fix nasty bug that caused
	ILLEGAL_DEVICE_TABLE_ENTRY errors
Message-ID: <20081020160603.GA5744@elte.hu>
References: <20081016142736.GN4706@alberich.amd.com> <20081016145956.GA29705@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016145956.GA29705@8bytes.org>
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

> Argh. Very stupid bug. This explains why it worked on my system with 1G
> RAM and failed on some others with more. Thanks for the fix. I also CC
> stable@kernel.org.
> 
> On Thu, Oct 16, 2008 at 04:27:36PM +0200, Andreas Herrmann wrote:
> > We are on 64-bit so better use u64 instead of u32 to deal with
> > addresses:
> > 
> > static void __init iommu_set_device_table(struct amd_iommu *iommu)
> > {
> >         u64 entry;
> >   ...
> >         entry = virt_to_phys(amd_iommu_dev_table);
> >   ...
> > 
> > (I am wondering why gcc 4.2.x did not warn about the assignment
> > between u32 and unsigned long.)
> > 
> > Cc: iommu@lists.linux-foundation.org
> > Cc: Joerg Roedel <joerg.roedel@amd.com>
> > Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

applied to tip/x86/urgent, thanks guys!

	Ingo
