Return-Path: <linux-kernel-owner+w=401wt.eu-S1758199AbYAHVUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbYAHVUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:20:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbYAHVLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:11:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756823AbYAHVLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:11:34 -0500
Message-Id: <20080108205939.323955454@redhat.com>
User-Agent: quilt/0.46-1
Date: Tue, 08 Jan 2008 15:59:39 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [patch 00/19] VM pageout scalability improvements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On large memory systems, the VM can spend way too much time scanning
through pages that it cannot (or should not) evict from memory. Not
only does it use up CPU time, but it also provokes lock contention
and can leave large systems under memory presure in a catatonic state.

Against 2.6.24-rc6-mm1

This patch series improves VM scalability by:

1) making the locking a little more scalable

2) putting filesystem backed, swap backed and non-reclaimable pages
   onto their own LRUs, so the system only scans the pages that it
   can/should evict from memory

3) switching to SEQ replacement for the anonymous LRUs, so the
   number of pages that need to be scanned when the system
   starts swapping is bound to a reasonable number

More info on the overall design can be found at:

	http://linux-mm.org/PageReplacementDesign


Changelog:
- merge memcontroller split LRU code into the main split LRU patch,
  since it is not functionally different (it was split up only to help
  people who had seen the last version of the patch series review it)
- drop the page_file_cache debugging patch, since it never triggered
- reintroduce code to not scan anon list if swap is full
- add code to scan anon list if page cache is very small already
- use lumpy reclaim more aggressively for smaller order > 1 allocations

-- 
All Rights Reversed

