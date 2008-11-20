Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYKTHwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYKTHwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 02:52:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYKTHwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 02:52:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53949 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753033AbYKTHwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 02:52:05 -0500
Date: Thu, 20 Nov 2008 08:51:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: muli@il.ibm.com, joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
       mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AMD IOMMU updates for 2.6.28-rc5
Message-ID: <20081120075139.GB11930@elte.hu>
References: <20081118154322.GX13394@amd.com> <20081119150504G.fujita.tomonori@lab.ntt.co.jp> <20081119125748.GK7113@il.ibm.com> <20081120132545Q.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081120132545Q.fujita.tomonori@lab.ntt.co.jp>
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


* FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:

> > > It had been the default option for AMD IOMMU until you hit the 
> > > bugs. IIRC, VT-d also shares a protection domain by default. It 
> > > would be nice to avoid surprising users if the two 
> > > virtualization IOMMUs works in the similar way.
> > 
> > Calgary has a per-bus protection domain, both on x86 and PPC.
> 
> I see. Then it might be better to change VT-d to use a separate 
> protection domain by default.

yes, agreed, and that should be the sane default for any IOMMU driver 
- unless the performance impact is prohibitive.

Note that this widens the positive impact of the IOMMU code: not only 
does it enable transparent support of DMA to/from devices that have a 
limited DMA range, not only does it help isolation in virtualization - 
it also acts as a daily debug helper for _native_ drivers.

Note that people will prefer to run with an IOMMU enabled even if all 
devices support the full memory range - just due to the DMA protection 
features. Just like people prefer to run an OS with paging protections 
enabled ;-)

It also puts pressure on the hw design side to treat IOMMUs not just 
as some fringe feature for compatibility with older transports or 
virtualization, but also as a prime-time native IO feature.

	Ingo
