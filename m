Return-Path: <linux-kernel-owner+w=401wt.eu-S1756426AbYICSlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426AbYICSlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755980AbYICSlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:41:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38152 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755969AbYICSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:41:31 -0400
Date: Wed, 3 Sep 2008 14:41:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] utrace: ptrace cooperation
Message-ID: <20080903184127.GB16175@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain> <20080826220237.66B3D154233@magilla.localdomain> <20080830133834.GA17566@infradead.org> <20080903121011.42AC9154228@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903121011.42AC9154228@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 05:10:11AM -0700, Roland McGrath wrote:
> > I don't like this patch in it's current form.  Having two different ways
> > to do ptrace is a rather awkward thing and not very good for testing
> > coverage.  This should not be an option but required.  
> 
> The main idea behind having CONFIG_UTRACE_PTRACE be an option separate
> from CONFIG_UTRACE is just for debugging during this development and
> transition period.  With CONFIG_UTRACE=y, CONFIG_UTRACE_PTRACE=n, then
> ptrace works as it ever did.  You'll only have trouble if you use utrace
> on the same tasks.  So if you hit bad problems working on something
> using utrace, you can always switch to CONFIG_UTRACE_PTRACE=n to use gdb
> and strace et al reliably on your userland code, which might be damn
> helpful in figuring out how you're triggering the utrace bugs.  By the
> time it's no longer EXPERIMENTAL, the separate option could be gone.

No problems doing it in your tree, but it's not how features
get into mainline.  Transition periods like this are bad, because
people will simply disable the option if it doesn't work, and it will
never get debugged.  Conditional implementation of core functionality
are the worst case for code coverage.

> don't care.  An arch deadline is fine with me (I'm not the one who has
> to meet it).  I've always assumed there would be one eventually.  But
> any reasonable deadline would be some time hence, I don't know how long
> (time scales in feature-removal-schedule.txt seem to be pretty long).  I

At least one or two major release.  So in your place I would try to get
consensus on linux-arch _now_.  I've also tried to poke multiple arch
maintainers into updating their implementations for other reasons in
private, and the feedback has generally been postive.

> Some more ptrace cleanups can be done orthogonal to utrace,
> e.g. reorganizing the data structures as you mentioned in another
> message.  This can be done in parallel to getting utrace in shape.
> Doing it that way makes it easy to test and prove those cleanups on
> their own and thus isolate any ptrace regressions either to those
> changes or to utrace problems.

I don't think moving ptrace data insto the engine state is a minor
reoraniation.  It's shoveling free some space that you need for utrace
itself if we want to get rid of the nasty dynamic allocation of it,
which I really really think we want.

