Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbXHNKMD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbXHNKMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 06:12:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbXHNKKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 06:10:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335AbXHNKKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 06:10:41 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Patrick Caulfield <pcaulfie@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] zero unused parts of sockaddr_storage
Date: Tue, 14 Aug 2007 10:47:07 +0100
Message-Id: <11870848451980-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11870848365-git-send-email-swhiteho@redhat.com>
References: <11870848365-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Patrick Caulfield <pcaulfie@redhat.com>

When we build a sockaddr_storage for an IP address, clear the unused parts as
they could be used for node comparisons.

I have seen this occasionally make sctp connections fail.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index d15fd5f..631bc43 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -313,6 +313,7 @@ static void make_sockaddr(struct sockaddr_storage *saddr, uint16_t port,
 		in6_addr->sin6_port = cpu_to_be16(port);
 		*addr_len = sizeof(struct sockaddr_in6);
 	}
+	memset((char *)saddr + *addr_len, 0, sizeof(struct sockaddr_storage) - *addr_len);
 }
 
 /* Close a remote connection and tidy up */
-- 
1.5.1.2

