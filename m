Return-Path: <linux-kernel-owner+w=401wt.eu-S1762264AbXGKKOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762264AbXGKKOs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXGKKOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:14:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44202 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbXGKKOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:14:41 -0400
Date: Wed, 11 Jul 2007 11:14:37 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Jes Sorensen <jes@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
Message-ID: <20070711101437.GA21735@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Jes Sorensen <jes@sgi.com>,
	linux-kernel@vger.kernel.org
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com> <20070711093253.GA19061@infradead.org> <20070711101245.GA18770@dnb.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070711101245.GA18770@dnb.sw.ru>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2007 at 02:12:45PM +0400, Dmitry Monakhov wrote:
> > > Or would this simpler patch be the right one?  I suspect the
> > > mspec driver only says VM_LOCKED because of a deep-seated but
> > > irrational fear that its pages might fall into reclaim.
> > 
> > Looks good.  We probably should add a debug check to do_mmap_pgoff
> > so that ->mmap methods don't change flags that are not for drivers.
> As result fglrx totally goes crazy, because it change vm_flags
> even from  ->nopage() calback :)

Well, everyone with half a brain knows that fglrx is not just legally
problematic but an utter piece of junk.  We should add more debug checks
to stop it from doing such stupid things.  And yes, chaning flags from
->nopage() does not just deserve a warning but a panic.
