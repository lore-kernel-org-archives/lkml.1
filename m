Return-Path: <linux-kernel-owner+w=401wt.eu-S1754591AbXLRVSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbXLRVSK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 16:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbXLRVRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 16:17:35 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbXLRVRd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 16:17:33 -0500
Message-Id: <20071218211539.250334036@redhat.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Dec 2007 16:15:39 -0500
From: Rik van Riel <riel@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, lee.shermerhorn@hp.com
Subject: [patch 00/20] VM pageout scalability improvements
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On large memory systems, the VM can spend way too much time scanning
through pages that it cannot (or should not) evict from memory. Not
only does it use up CPU time, but it also provokes lock contention
and can leave large systems under memory presure in a catatonic state.

This patch series improves VM scalability by:

1) making the locking a little more scalable

2) putting filesystem backed, swap backed and non-reclaimable pages
   onto their own LRUs, so the system only scans the pages that it
   can/should evict from memory

3) switching to SEQ replacement for the anonymous LRUs, so the
   number of pages that need to be scanned when the system
   starts swapping is bound to a reasonable number

The noreclaim patches come verbatim from Lee Schermerhorn and
Nick Piggin.  I have not taken a detailed look at them yet and
all I have done is fix the rejects against the latest -mm kernel.

I am posting this series now because I would like to get more
feedback, while I am studying and improving the noreclaim patches
myself.

-- 
All Rights Reversed

