Return-Path: <linux-kernel-owner+w=401wt.eu-S1758526AbZFDMzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526AbZFDMzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 08:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZFDMzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 08:55:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39963 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbZFDMzh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 08:55:37 -0400
Date: Thu, 4 Jun 2009 15:02:55 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [6/16] HWPOISON: Add various poison checks in mm/memory.c
Message-ID: <20090604130255.GB1065@one.firstfloor.org>
References: <20090603846.816684333@firstfloor.org> <20090603184639.1933B1D028F@basil.firstfloor.org> <20090604042603.GA15682@localhost> <20090604051915.GN1065@one.firstfloor.org> <20090604115533.GB22118@localhost> <20090604125228.GZ1065@one.firstfloor.org> <20090604125026.GA29026@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604125026.GA29026@localhost>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:50:26PM +0800, Wu Fengguang wrote:
> On Thu, Jun 04, 2009 at 08:52:28PM +0800, Andi Kleen wrote:
> > On Thu, Jun 04, 2009 at 07:55:33PM +0800, Wu Fengguang wrote:
> > > On Thu, Jun 04, 2009 at 01:19:15PM +0800, Andi Kleen wrote:
> > > > On Thu, Jun 04, 2009 at 12:26:03PM +0800, Wu Fengguang wrote:
> > > > > On Thu, Jun 04, 2009 at 02:46:38AM +0800, Andi Kleen wrote:
> > > > > >
> > > > > > Bail out early when hardware poisoned pages are found in page fault handling.
> > > > >
> > > > > I suspect this patch is also not absolutely necessary: the poisoned
> > > > > page will normally have been isolated already.
> > > >
> > > > It's needed to prevent new pages comming in when there is a parallel
> > > > fault while the memory failure handling is in process.
> > > > Otherwise the pages could get remapped in that small window.
> > > 
> > > This patch makes no difference at least for file pages, including tmpfs.
> > 
> > I was more thinking of anonymous pages with multiple mappers (e.g.
> > COW after fork)
> 
> I guess they are handled by do_anonymous_page() or do_wp_page(),
> instead of do_linear_fault()/do_nonlinear_fault()?

You're right. Sorry was a little confused in my earlier reply.

I think what I meant is: what happens during the window
when the page has just the poison bit set, but is not isolated/unmapped yet.
During that window I want new mappers to not come in.
That is why that check is there.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
