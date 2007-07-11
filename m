Return-Path: <linux-kernel-owner+w=401wt.eu-S1760466AbXGKJdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760466AbXGKJdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbXGKJdJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:33:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39248 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbXGKJdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:33:08 -0400
Date: Wed, 11 Jul 2007 10:32:53 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Dmitry Monakhov <dmonakhov@sw.ru>, Jes Sorensen <jes@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
Message-ID: <20070711093253.GA19061@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Dmitry Monakhov <dmonakhov@sw.ru>,
	Jes Sorensen <jes@sgi.com>, linux-kernel@vger.kernel.org
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 06:27:05PM +0100, Hugh Dickins wrote:
> On Mon, 9 Jul 2007, Dmitry Monakhov wrote:
> > Some device drivers can change vm_flags in their f_op->mmap
> > method. In order to be on the safe side we have to recheck
> > lock rlimit. Now we have to check lock rlimit from two places,
> > let's move this common code to helper functon.
> > 
> > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > ---
> >  mm/mmap.c |   33 ++++++++++++++++++++++++++-------
> >  1 files changed, 26 insertions(+), 7 deletions(-)
> 
> Or would this simpler patch be the right one?  I suspect the
> mspec driver only says VM_LOCKED because of a deep-seated but
> irrational fear that its pages might fall into reclaim.

Looks good.  We probably should add a debug check to do_mmap_pgoff
so that ->mmap methods don't change flags that are not for drivers.

