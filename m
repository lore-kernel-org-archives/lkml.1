Return-Path: <linux-kernel-owner+w=401wt.eu-S1761549AbXGJRx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761549AbXGJRx7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbXGJRxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:53:51 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:60316 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756943AbXGJRxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:53:50 -0400
Date: Tue, 10 Jul 2007 21:53:31 +0400
From: Dmitry Monakhov <dmonakhov@sw.ru>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jes Sorensen <jes@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: recheck lock rlim after f_op->mmap() method
Message-ID: <20070710175331.GA23173@dnb>
Mail-Followup-To: Hugh Dickins <hugh@veritas.com>,
	Jes Sorensen <jes@sgi.com>, linux-kernel@vger.kernel.org
References: <20070709184917.GA8720@dnb.sw.ru> <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0707101813390.4717@blonde.wat.veritas.com>
Organization: SWsoft.
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [194.85.82.65]); Tue, 10 Jul 2007 21:53:06 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:27 Втр 10 Июл     , Hugh Dickins wrote:
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
No mspec is not the only one :( , in my case it was fglrx (ati driver).
BTW: where is comment about it in do_mmap_pgoff:  
	/* Can addr have changed??
	 *
	 * Answer: Yes, several device drivers can do
	 * it in their
	 *         f_op->mmap method. -DaveM
	 */
	addr = vma->vm_start;
	pgoff = vma->vm_pgoff;
	vm_flags = vma->vm_flags;
> 
> (I'd like to take out VM_RESERVED too, but that can always happen
> another, indefinitely postponed time; there are others of those.)
> 
> Hugh
[skip]

