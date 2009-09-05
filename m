Return-Path: <linux-kernel-owner+w=401wt.eu-S1752882AbZIESMw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882AbZIESMw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 14:12:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752636AbZIESMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 14:12:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZIESMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 14:12:48 -0400
Message-Id: <200909051812.n85ICiMs002769@int-mx08.intmail.prod.int.phx2.redhat.com>
Date: Sat, 5 Sep 2009 14:12:43 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Joel Becker <Joel.Becker@oracle.com>, <linux-kernel@vger.kernel.org>
Subject: [stable] 2.6.27.32-rc1 build failure
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.32-rc1 is missing a line, causing:
fs/ocfs2/aops.c: In function 'ocfs2_write_cluster':
fs/ocfs2/aops.c:1286: error: 'should_zero' undeclared (first use in
this function)

Caused by patch #41:
ocfs2-initialize-the-cluster-we-re-writing-to-in-a-non-sparse-extend.patch

Fix, taken from the 2.6.30-stable patch:

--- linux-2.6.27.x86_64.orig/fs/ocfs2/aops.c
+++ linux-2.6.27.x86_64/fs/ocfs2/aops.c
@@ -1234,6 +1234,7 @@ out:
  */
 static int ocfs2_write_cluster(struct address_space *mapping,
 			       u32 phys, unsigned int unwritten,
+			       unsigned int should_zero,
 			       struct ocfs2_alloc_context *data_ac,
 			       struct ocfs2_alloc_context *meta_ac,
 			       struct ocfs2_write_ctxt *wc, u32 cpos,
