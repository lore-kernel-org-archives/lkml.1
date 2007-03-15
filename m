Return-Path: <linux-kernel-owner+w=401wt.eu-S1751073AbXCOVte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751073AbXCOVte (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 17:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbXCOVte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 17:49:34 -0400
Received: from mail.suse.de ([195.135.220.2]:60257 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbXCOVtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 17:49:33 -0400
Date: Thu, 15 Mar 2007 22:49:23 +0100
From: Andrea Arcangeli <andrea@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ashif Harji <asharji@cs.uwaterloo.ca>, dingxn@cse.ohio-state.edu,
       shaggy@linux.vnet.ibm.com, andi@rhlx01.fht-esslingen.de,
       linux-mm@kvack.org, npiggin@suse.de, jack@suse.cz,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap.c: unconditionally call mark_page_accessed
Message-ID: <20070315214923.GE6687@v2.random>
References: <20070312173500.GF23532@duck.suse.cz> <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca> <20070313185554.GA5105@duck.suse.cz> <Pine.GSO.4.64.0703141218530.28958@cpu102.cs.uwaterloo.ca> <1173905741.8763.36.camel@kleikamp.austin.ibm.com> <20070314213317.GA22234@rhlx01.hs-esslingen.de> <1173910138.8763.45.camel@kleikamp.austin.ibm.com> <45F8A301.90301@cse.ohio-state.edu> <Pine.GSO.4.64.0703150045550.18191@cpu102.cs.uwaterloo.ca> <20070315110735.287c8a23.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315110735.287c8a23.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 11:07:35AM -0800, Andrew Morton wrote:
> > On Thu, 15 Mar 2007 01:22:45 -0400 (EDT) Ashif Harji <asharji@cs.uwaterloo.ca> wrote:
> > I still think the simple fix of removing the 
> > condition is the best approach, but I'm certainly open to alternatives.
> 
> Yes, the problem of falsely activating pages when the file is read in small
> hunks is worse than the problem which your patch fixes.

Really? I would have expected all performance sensitive apps to read
in >=PAGE_SIZE chunks. And if they don't because they split their
dataset in blocks (like some database), it may not be so wrong to
activate those pages that have two "hot" blocks more aggressively than
those pages with a single hot block.

So I've an hard time to advocate to prefer the current behavior, but
certainly this can be "fixed" by caching the last_offset like others
pointed out ;)
