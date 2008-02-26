Return-Path: <linux-kernel-owner+w=401wt.eu-S1762600AbYBZK1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762600AbYBZK1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 05:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762268AbYBZK1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 05:27:33 -0500
Received: from 1wt.eu ([62.212.114.60]:2148 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097AbYBZK1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 05:27:32 -0500
Date: Tue, 26 Feb 2008 11:27:19 +0100
From: Willy Tarreau <w@1wt.eu>
To: dann frazier <dannf@dannf.org>
Cc: Glen Nakamura <glen@imodulo.com>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 2.4.36.1 hangs.
Message-ID: <20080226102719.GB21257@1wt.eu>
References: <20080223083044.GA24136@1wt.eu> <20080226073612.GA29747@modulo.internal> <20080226081624.GA20022@1wt.eu> <20080226101346.GB20166@colo.lackof.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080226101346.GB20166@colo.lackof.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 03:13:46AM -0700, dann frazier wrote:
> I'm now able to reliably reproduce it by creating/removing a chroot
> (pbuilder create on a Debian system, though I'm sure a simpler test
> exists). Correcting the le16_to_cpu placement as Glen described
> fixes the issue for me.

OK that's excellent news.

> > BTW, I notice that 2.6 also has one extra chunk that 2.4 does not
> > have :
> > 
> >                 if (unlikely(need_revalidate)) {
> > +                       if (offset) {
> >                                 offset = ext2_validate_entry(kaddr, offset, chunk_mask);
> > +                               filp->f_pos = (n<<PAGE_CACHE_SHIFT) + offset;
> > +                       }
> > +                       filp->f_version = inode->i_version;
> >                         need_revalidate = 0;
> >                 }
> > 
> > I have no idea whether this part is needed, we'd better ask Theo or Al
> > for some advices, as I'm not tempted by merging an uncertain patch when
> > it comes to filesystems.
> 
> Looks like a test case may be available:
>   http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=2d7f2ea9c989853310c7f6e8be52cc090cc8e66b

Dann, would you care to ping Al about the opportunity to merge this entire
patch, as well as Masoud for his test-case ? The patch looks like all what
remains different between 2.4 and 2.6, so I would bet we need it too.

Thanks,
Willy

