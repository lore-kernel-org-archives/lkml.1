Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYJ0Jmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYJ0Jmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 05:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYJ0JmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 05:42:20 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:46536 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752439AbYJ0JmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 05:42:19 -0400
Date: Mon, 27 Oct 2008 10:41:11 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
Message-ID: <20081027094111.GU22217@kernel.dk>
References: <49057A15.7030007@goop.org> <20081027173739Q.fujita.tomonori@lab.ntt.co.jp> <49058774.3030506@goop.org> <20081027183604V.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081027183604V.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27 2008, FUJITA Tomonori wrote:
> On Mon, 27 Oct 2008 20:18:44 +1100
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> 
> > FUJITA Tomonori wrote:
> > > I'm not familiar with what Xen does but why can't Xen just override
> > > BIOVEC_PHYS_MERGEABLE?
> > >
> > > Why does Xen need to hook BIOVEC_PHYS_MERGEABLE to the iommu_bio_merge
> > > parameter (as this patch does)? BIOVEC_PHYS_MERGEABLE and the
> > > iommu_bio_merge parameter are not related at all.
> > >   
> > 
> > No, it doesn't.  It was convenient to reuse that mechanism, but I can 
> > easily re-add something else (which would be more or less identical).
> 
> I still don't see how Xen needs something like the virtual merge
> (sounds that overriding BIOVEC_PHYS_MERGEABLE perfectly works for Xen)
> or why Xen needs a new boot parameter for it. The virtual merge just
> defines how IOMMUs should work.

Pretty much baffles me as well, xen should just need to do

#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)       0

and that should be it.

-- 
Jens Axboe

