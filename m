Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYL3NnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYL3NnV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 08:43:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbYL3NnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 08:43:09 -0500
Received: from verein.lst.de ([213.95.11.210]:56474 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751551AbYL3NnI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 08:43:08 -0500
Date: Tue, 30 Dec 2008 14:42:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: access(2) regressions in current mainline
Message-ID: <20081230134248.GA30124@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the merge of the current git tree into the xfs tree I see a
regression in XFSQA 088:

088	 - output mismatch (see 088.out.bad)
--- 088.out	2008-12-30 12:01:09.000000000 +0000
+++ 088.out.bad	2008-12-30 13:37:24.000000000 +0000
@@ -1,9 +1,9 @@
 QA output created by 088
 access(TEST_DIR/t_access, 0) returns 0
-access(TEST_DIR/t_access, R_OK) returns 0
-access(TEST_DIR/t_access, W_OK) returns 0
+access(TEST_DIR/t_access, R_OK) returns -1
+access(TEST_DIR/t_access, W_OK) returns -1
 access(TEST_DIR/t_access, X_OK) returns -1
-access(TEST_DIR/t_access, R_OK | W_OK) returns 0
+access(TEST_DIR/t_access, R_OK | W_OK) returns -1
 access(TEST_DIR/t_access, R_OK | X_OK) returns -1
 access(TEST_DIR/t_access, W_OK | X_OK) returns -1
 access(TEST_DIR/t_access, R_OK | W_OK | X_OK) returns -1

Given that XFS uses bog-standard generic_permission and the creds merge
just happened I'd look for the cause there.  The source for the xfs
testcase is here:

	http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs-cmds/.git;a=blob;f=xfstests/088;h=726ad009fd10cfde8c223f931e0994f596bcdc26;hb=HEAD

