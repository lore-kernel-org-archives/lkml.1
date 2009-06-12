Return-Path: <linux-kernel-owner+w=401wt.eu-S933629AbZFLKH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbZFLKH4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbZFLKHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:07:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42076 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933560AbZFLKHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:07:44 -0400
Date: Fri, 12 Jun 2009 12:07:44 +0200
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/5] HWPOISON: fix tasklist_lock/anon_vma locking order
Message-ID: <20090612100744.GB13607@wotan.suse.de>
References: <20090611142239.192891591@intel.com> <20090611144430.540500784@intel.com> <20090612100308.GD25568@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612100308.GD25568@one.firstfloor.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 12:03:08PM +0200, Andi Kleen wrote:
> On Thu, Jun 11, 2009 at 10:22:41PM +0800, Wu Fengguang wrote:
> > To avoid possible deadlock. Proposed by Nick Piggin:
> 
> I disagree with the description. There's no possible deadlock right now.
> It would be purely out of paranoia.
> 
> > 
> >   You have tasklist_lock(R) nesting outside i_mmap_lock, and inside anon_vma
> >   lock. And anon_vma lock nests inside i_mmap_lock.
> > 
> >   This seems fragile. If rwlocks ever become FIFO or tasklist_lock changes
> 
> I was a bit dubious on this reasoning. If rwlocks become FIFO a lot of
> stuff will likely break.
> 
> >   type (maybe -rt kernels do it), then you could have a task holding
> 
> I think they tried but backed off quickly again
> 
> It's ok with a less scare-mongering description.

There's simply no good reason to invert ordering of locks like
this.

