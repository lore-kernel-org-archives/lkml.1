Return-Path: <linux-kernel-owner+w=401wt.eu-S1423117AbXDXV2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423117AbXDXV2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 17:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423123AbXDXV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 17:28:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36361 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423117AbXDXV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 17:28:12 -0400
Date: Tue, 24 Apr 2007 14:28:11 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, pj@sgi.com
Subject: Re: Pagecache: find_or_create_page does not call a proper page
 allocator function
In-Reply-To: <20070424142411.95462085.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0704241425310.13904@schroedinger.engr.sgi.com>
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
 <20070424134206.95bd6c92.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241344100.13005@schroedinger.engr.sgi.com>
 <20070424135348.4e69ac23.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0704241354470.13382@schroedinger.engr.sgi.com>
 <20070424142411.95462085.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Andrew Morton wrote:

> mapping_gfp_mask if a pretty foul thing.  Adding
> 
> 	struct page (*alloc_page)(struct address_space *mapping);
> 
> to address_space_operations would be a quite nice cleanup.

Ummm... If things would be that simple... I think we need

struct page (*alloc_page)(struct address_space *mapping, int order, int 
node, gfp_t flags)

node = -1 means abitrary node otherwise try to alloc on indicated node.

additional_flags are important to be able to specify GFP_THISNODE to 
force alloc on one particular node. Plus there are the cpuset 
context flages etc. If the allocation is atomic then the callback should
be able to react to that appropriately.

