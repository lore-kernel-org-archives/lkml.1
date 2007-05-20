Return-Path: <linux-kernel-owner+w=401wt.eu-S1759998AbXETWua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998AbXETWua (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 18:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757681AbXETWuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 18:50:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:56693 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757438AbXETWuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 18:50:19 -0400
Date: Sun, 20 May 2007 16:50:17 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-arch@vger.kernel.org
Subject: Re: [rfc] increase struct page size?!
Message-ID: <20070520225017.GC10562@parisc-linux.org>
References: <20070518040854.GA15654@wotan.suse.de> <Pine.LNX.4.64.0705181633240.24071@blonde.wat.veritas.com> <20070519175320.GB19966@holomorphy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070519175320.GB19966@holomorphy.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 19, 2007 at 10:53:20AM -0700, William Lee Irwin III wrote:
> On Fri, May 18, 2007 at 04:42:10PM +0100, Hugh Dickins wrote:
> > Sooner rather than later, don't we need those 8 bytes to expand from
> > atomic_t to atomic64_t _count and _mapcount?  Not that we really need
> > all 64 bits of both, but I don't know how to work atomically with less.
> > (Why do I have this sneaking feeling that you're actually wanting
> > to stick something into the lower bits of page->virtual?)
> 
> I wonder how close we get to overflow on ->_mapcount and ->_count.
> (untested/uncompiled).

I think the problem is that an attacker can deliberately overflow
->_count, not that it can happen innocuously.  By mmaping, say, the page
of libc that contains memcpy() several million times, and forking
enough, can't you make ->_mapcount hit 0?  I'm not a VM guy, I just
vaguely remember people talking about this before.
