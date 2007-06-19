Return-Path: <linux-kernel-owner+w=401wt.eu-S933778AbXFSTWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933778AbXFSTWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 15:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933688AbXFSTWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 15:22:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43548 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933696AbXFSTWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 15:22:33 -0400
Date: Tue, 19 Jun 2007 12:22:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Mel Gorman <mel@skynet.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [PATCH 0/7] Memory Compaction v2
In-Reply-To: <20070619165841.GG17109@skynet.ie>
Message-ID: <Pine.LNX.4.64.0706191221130.7008@schroedinger.engr.sgi.com>
References: <20070618092821.7790.52015.sendpatchset@skynet.skynet.ie>
 <Pine.LNX.4.64.0706181022530.4751@schroedinger.engr.sgi.com>
 <20070619165841.GG17109@skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007, Mel Gorman wrote:

> Agreed. When I put this together first, I felt I would be able to isolate
> pages of different types on migratelist but that is not the case as migration
> would not be able to tell the difference between a LRU page and a pagetable
> page. I'll rename cc->migratelist to cc->migratelist_lru with the view to
> potentially adding cc->migratelist_pagetable or cc->migratelist_slab later.

Right. The particular issue with moving page table pages or slab pages is 
that you do not have a LRU. The page state needs to be established in a 
different way and there needs to be mechanism to ensure that the page is 
not currently being setup or torn down. For the slab pages I have relied 
on page->inuse > 0 to signify a page in use. I am not sure how one would 
realize that for page table pages.

