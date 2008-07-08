Return-Path: <linux-kernel-owner+w=401wt.eu-S1755662AbYGHPof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662AbYGHPof (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbYGHPoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:44:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbYGHPoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:44:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix a const assignment in moxa_load_fw()
To: jirislaby@gmail.com, akpm@linux-foundation.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2008 16:44:16 +0100
Message-ID: <20080708154416.24850.30733.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix an assignment of a const pointer to a non-const pointer in moxa_load_fw().

This was introduced by patch 037182346f0991683cc7320a257c3f6089432cee.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 drivers/char/moxa.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index d57d3a6..e21346d 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -721,7 +721,7 @@ static int moxa_load_code(struct moxa_board_conf *brd, const void *ptr,
 
 static int moxa_load_fw(struct moxa_board_conf *brd, const struct firmware *fw)
 {
-	void *ptr = fw->data;
+	const void *ptr = fw->data;
 	char rsn[64];
 	u16 lens[5];
 	size_t len;
@@ -734,7 +734,7 @@ static int moxa_load_fw(struct moxa_board_conf *brd, const struct firmware *fw)
 		u8 model;	/* C218T=1, C320T=2, CP204=3 */
 		u8 reserved2[8];
 		__le16 len[5];
-	} *hdr = ptr;
+	} const *hdr = ptr;
 
 	BUILD_BUG_ON(ARRAY_SIZE(hdr->len) != ARRAY_SIZE(lens));
 

