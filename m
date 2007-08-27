Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbXH0QNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbXH0QNz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758975AbXH0QCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:02:51 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:49272 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759395AbXH0QCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:02:48 -0400
Date: Mon, 27 Aug 2007 11:02:48 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, tony.luck@intel.com, jes@sgi.com
Subject: [PATCH 3/4] add new lock ordering rule to mm/filemap.c
Message-ID: <20070827160247.GD25589@sgi.com>
References: <20070827155622.GA25589@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070827155622.GA25589@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a lock ordering rule to avoid a potential deadlock when
multiple mmap_sems need to be locked.

Signed-off-by: Dean Nelson <dcn@sgi.com>

Index: linux-2.6/mm/filemap.c
===================================================================
--- linux-2.6.orig/mm/filemap.c	2007-08-09 19:18:15.000000000 -0500
+++ linux-2.6/mm/filemap.c	2007-08-27 09:13:47.435717670 -0500
@@ -78,6 +78,9 @@
  *  ->i_mutex			(generic_file_buffered_write)
  *    ->mmap_sem		(fault_in_pages_readable->do_page_fault)
  *
+ *    When taking multiple mmap_sems, one should lock the lowest-addressed
+ *    one first proceeding on up to the highest-addressed one.
+ *
  *  ->i_mutex
  *    ->i_alloc_sem             (various)
  *
