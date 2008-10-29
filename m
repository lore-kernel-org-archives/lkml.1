Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbYJ2J2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbYJ2J2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751800AbYJ2J2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:28:46 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:46695 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYJ2J2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:28:46 -0400
Date: Wed, 29 Oct 2008 10:27:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jeremy@goop.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 2/2] x86: replace BIO_VMERGE_BOUNDARY with BIOVEC_PHYS_MERGEABLE
Message-ID: <20081029092733.GS22217@kernel.dk>
References: <20081027094111.GU22217@kernel.dk> <4905A961.9000603@goop.org> <20081027115659.GZ22217@kernel.dk> <20081029080603J.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081029080603J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29 2008, FUJITA Tomonori wrote:
> On Mon, 27 Oct 2008 12:57:00 +0100
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Mon, Oct 27 2008, Jeremy Fitzhardinge wrote:
> > > Jens Axboe wrote:
> > > >Pretty much baffles me as well, xen should just need to do
> > > >
> > > >#define BIOVEC_PHYS_MERGEABLE(vec1, vec2)       0
> > > >  
> > > 
> > > It needs to be a runtime switch, since we only want to do this when 
> > > actually running under Xen.  Also, its possible that the two pages might 
> > > actually be physically contiguous, so they could be merged anyway.
> > 
> > Alright, then add a xen_biovec_phys_mergeable(vec1, vec2) in the xen
> > code that actually checks this for real. You can add your switch there
> > as well. Then put the BIOVEC_PHYS_MERGEABLE() in the xen arch includes,
> > done.
> > 
> > What Tomo is saying is that this has nothing to do with virtual merging,
> > and he's right.
> 
> Yeah, overriding BIOVEC_PHYS_MERGEABLE perfectly works for Xen. And it
> is not related with BIO_VMERGE_BOUNDARY at all.
> 
> Ingo, please put this patch into your tree:
> 
> http://marc.info/?l=linux-kernel&m=122482703716620&w=2

You can add my Signed-off-by: as well.

-- 
Jens Axboe

