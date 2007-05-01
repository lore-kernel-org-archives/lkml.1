Return-Path: <linux-kernel-owner+w=401wt.eu-S1031655AbXEAKM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031655AbXEAKM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031649AbXEAKM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:12:27 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031655AbXEAKMZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:12:25 -0400
Subject: [DLM] fix coverity-spotted stupidity [12/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Patrick Caulfield <pcaulfie@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:07:46 +0100
Message-Id: <1178014066.5462.150.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 032067270295cfca11975c0f7b467244aa170c14 Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Mon, 26 Mar 2007 09:56:00 +0100
Subject: [PATCH] [DLM] fix coverity-spotted stupidity

Replacement patch to remove redundant code rather than moving it around.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms-tcp.c b/fs/dlm/lowcomms-tcp.c
index 9bfe7fb..919e92a 100644
--- a/fs/dlm/lowcomms-tcp.c
+++ b/fs/dlm/lowcomms-tcp.c
@@ -319,8 +319,6 @@ static int receive_from_sock(struct connection *con)
 
 	if (ret <= 0)
 		goto out_close;
-	if (ret == -EAGAIN)
-		goto out_resched;
 
 	if (ret == len)
 		call_again_soon = 1;
-- 
1.5.1.2



