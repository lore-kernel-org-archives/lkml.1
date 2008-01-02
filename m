Return-Path: <linux-kernel-owner+w=401wt.eu-S1756428AbYABX0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbYABX0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 18:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758085AbYABXWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 18:22:39 -0500
Received: from mx1.redhat.com ([66.187.233.31]:49867 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755045AbYABXWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 18:22:17 -0500
Message-Id: <20080102224144.885671949@redhat.com>
User-Agent: quilt/0.46-1
Date: Wed, 02 Jan 2008 17:41:44 -0500
From: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, lee.schermerhorn@hp.com
Subject: [patch 00/19] VM pageout scalability improvements
To: unlisted-recipients:; (no To-header on input)
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

The noreclaim patches come verbatim from Lee Schermerhorn and
Nick Piggin.  I have made a few small fixes to them and left out
the bits that are no longer needed with split file/anon lists.

The exception is "Scan noreclaim list for reclaimable pages",
which should not be needed but could be a useful debugging tool.

-- 
All Rights Reversed

