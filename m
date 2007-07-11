Return-Path: <linux-kernel-owner+w=401wt.eu-S1762059AbXGKKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762059AbXGKKN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 06:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756873AbXGKKNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 06:13:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:25277 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbXGKKNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 06:13:18 -0400
Date: Wed, 11 Jul 2007 14:12:45 +0400
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: Christoph Hellwig <hch@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       Jes Sorensen <jes@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
Message-ID: <20070711101245.GA18770@dnb.sw.ru>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hugh Dickins <hugh@veritas.com>, Jes Sorensen <jes@sgi.com>,
	linux-kernel@vger.kernel.org
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com> <20070711093253.GA19061@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070711093253.GA19061@infradead.org>
Organization: SWsoft.
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10:32 Срд 11 Июл     , Christoph Hellwig wrote:
> On Tue, Jul 10, 2007 at 06:27:05PM +0100, Hugh Dickins wrote:
> > On Mon, 9 Jul 2007, Dmitry Monakhov wrote:
> > > Some device drivers can change vm_flags in their f_op->mmap
> > > method. In order to be on the safe side we have to recheck
> > > lock rlimit. Now we have to check lock rlimit from two places,
> > > let's move this common code to helper functon.
> > > 
> > > Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> > > ---
> > >  mm/mmap.c |   33 ++++++++++++++++++++++++++-------
> > >  1 files changed, 26 insertions(+), 7 deletions(-)
> > 
> > Or would this simpler patch be the right one?  I suspect the
> > mspec driver only says VM_LOCKED because of a deep-seated but
> > irrational fear that its pages might fall into reclaim.
> 
> Looks good.  We probably should add a debug check to do_mmap_pgoff
> so that ->mmap methods don't change flags that are not for drivers.
As result fglrx totally goes crazy, because it change vm_flags
even from  ->nopage() calback :)
> 

