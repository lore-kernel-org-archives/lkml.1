Return-Path: <linux-kernel-owner+w=401wt.eu-S1423076AbXDXT7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423076AbXDXT7T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423078AbXDXT7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:59:19 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45827 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423076AbXDXT7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:59:18 -0400
Date: Tue, 24 Apr 2007 12:59:17 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070424124922.d406aac1.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704241256470.12907@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0704231408530.691@schroedinger.engr.sgi.com>
 <20070423142919.5809e03f.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704231503540.975@schroedinger.engr.sgi.com>
 <20070423154224.15ebf8f7.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241339460.26223@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241042550.8418@schroedinger.engr.sgi.com>
 <Pine.LNX.4.64.0704241941421.28487@blonde.wat.veritas.com>
 <Pine.LNX.4.64.0704241234341.12753@schroedinger.engr.sgi.com>
 <20070424124922.d406aac1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Andrew Morton wrote:

> No, think of the following scenario:
> 
> - file I/O causes a read of an ext2 file's bitmap.  The bitmap is
>   brought into /dev/hda1's pagecache using !__GFP_HIGHMEM
> 
> - references are released against that page and it's now just clean
>   reclaimable pagecache
> 
> - someone (say, an online filesystem checker or something) mmaps
>   /dev/hda1 and reads that page.
> 
> - migration comes alnog and migrates that page into highmem
> 
> - file I/O causes a read of that bitmap again.  We find it in
>   /dev/hda's pagecache.

Read of the bitmap? How would that work? Page cache lookup right?

>   Here's set_bh_page().

A highmem page can have buffers???
