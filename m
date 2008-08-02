Return-Path: <linux-kernel-owner+w=401wt.eu-S1755100AbYHBNqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100AbYHBNqs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 09:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751744AbYHBNql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 09:46:41 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:52843 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYHBNql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 09:46:41 -0400
MIME-Version: 1.0
Date: Sat, 02 Aug 2008 15:46:35 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Shirish Pargaonkar <shirishp@gmail.com>, stable@kernel.org
Cc: Steve French <sfrench@us.ibm.com>, Oliver Pinter <oliver.pntr@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.2-rc1] Fix possible double free if search immediately after
 search rewind fails
Reply-To: oliver.pntr@gmail.com
Message-ID: <cb7ec8dab44793445d62fe469b12a280@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 76c510ad2e7d56cfe8f2cc7b23783e5c687cf704 Mon Sep 17 00:00:00 2001
From: Shirish Pargaonkar <shirishp@gmail.com>
Date: Thu, 24 Jul 2008 14:48:33 +0000
Subject: [PATCH] [CIFS] Fix possible double free if search immediately
after search rewind fails

[ Upstream commit 76c510ad2e7d56cfe8f2cc7b23783e5c687cf704 ]

Signed-off-by: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 83f3069..5f40ed3 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -690,6 +690,7 @@ static int find_cifs_entry(const int xid, struct
cifsTconInfo *pTcon,
 			else
 				cifs_buf_release(cifsFile->srch_inf.
 						ntwrk_buf_start);
+			cifsFile->srch_inf.ntwrk_buf_start = NULL;
 		}
 		rc = initiate_cifs_search(xid, file);
 		if (rc) {


