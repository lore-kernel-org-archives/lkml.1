Return-Path: <linux-kernel-owner+w=401wt.eu-S1754610AbXDXUmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610AbXDXUmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 16:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbXDXUmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 16:42:17 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54194 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754610AbXDXUmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 16:42:16 -0400
Date: Tue, 24 Apr 2007 13:42:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
Message-Id: <20070424134206.95bd6c92.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704241326410.13005@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
	<20070423142919.5809e03f.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
	<20070423154224.15ebf8f7.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
	<20070424101116.1cb7512e.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0704241954050.28487@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241254420.12907@schroedinger.engr.sgi.com>
	<Pine.LNX.4.64.0704242109290.11314@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0704241326410.13005@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 13:30:33 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:

> > > If the system has both high memory and normal memory then only allocations 
> > > to highmemory are subject to memory policies etc etc. The block device 
> > > allocations would be in zone normal/dma and thus be exempt from NUMA 
> > > placement.
> > 
> > Please just point us to the line where sys_move_pages enforces this.
> 
> It does not. It will happily move the pages into highmem. The filesystem 
> cannot expect the page to remain in the same zone without holding a 
> reference count. Swap may also move pages between zones. There is nothing 
> special in what page migration does here.
> 
> I would say that the filesystem is broke if it has such expectations 
> regardless of page migration.

Others disagree ;)

The filesystem has *told* the core kernel what its allocation constraints
are by setting up mapping_gfp_mask().  If the core kernel stops honouring
that request then it is core kernel which is broken.
