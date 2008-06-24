Return-Path: <linux-kernel-owner+w=401wt.eu-S1756892AbYFXF43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbYFXF43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:56:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbYFXF4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:56:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:35376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895AbYFXF4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:56:19 -0400
Date: Tue, 24 Jun 2008 01:56:07 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
To: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
cc: davem@davemloft.net
Subject: [2/10 PATCH] inline inline-generic_writepages.patch
In-Reply-To: <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
Message-ID: <Pine.LNX.4.64.0806240155200.27784@engineering.redhat.com>
References: <Pine.LNX.4.64.0806240136200.27784@engineering.redhat.com>
 <Pine.LNX.4.64.0806240154140.27784@engineering.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make generic_writepages inlinable in current file.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

Index: linux-2.6.26-rc7-devel/mm/page-writeback.c
===================================================================
--- linux-2.6.26-rc7-devel.orig/mm/page-writeback.c	2008-06-24 07:28:14.000000000 +0200
+++ linux-2.6.26-rc7-devel/mm/page-writeback.c	2008-06-24 07:37:15.000000000 +0200
@@ -981,8 +981,8 @@
   * This is a library function, which implements the writepages()
   * address_space_operation.
   */
-int generic_writepages(struct address_space *mapping,
-		       struct writeback_control *wbc)
+__always_inline int generic_writepages(struct address_space *mapping,
+				       struct writeback_control *wbc)
  {
  	/* deal with chardevs and other special file */
  	if (!mapping->a_ops->writepage)

