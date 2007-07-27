Return-Path: <linux-kernel-owner+w=401wt.eu-S965326AbXG0XbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326AbXG0XbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 19:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964832AbXG0XbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 19:31:14 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:51893 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756499AbXG0XbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 19:31:14 -0400
Subject: [PATCH] lzo: Add some missing casts
From: Richard Purdie <richard@openedhand.com>
To: Edward Shishkin <edward@namesys.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Nitin Gupta <nitingupta910@gmail.com>,
       reiserfs-devel <reiserfs-devel@vger.kernel.org>,
       Adrian Bunk <bunk@stusta.de>
Content-Type: text/plain
Date: Sat, 28 Jul 2007 00:30:55 +0100
Message-Id: <1185579055.6148.29.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add some casts to the LZO compression algorithm after they were removed
during cleanup and shouldn't have been.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---

This fixes the reported problems for me, I've checked fairly carefully
and I can't see any other issues. Edward, could you see if this resolves
the problems in your case please?

Index: linux-2.6.22/lib/lzo/lzo1x_compress.c
===================================================================
--- linux-2.6.22.orig/lib/lzo/lzo1x_compress.c
+++ linux-2.6.22/lib/lzo/lzo1x_compress.c
@@ -32,13 +32,13 @@ _lzo1x_1_do_compress(const unsigned char
 	ip += 4;
 
 	for (;;) {
-		dindex = ((0x21 * DX3(ip, 5, 5, 6)) >> 5) & D_MASK;
+		dindex = ((size_t)(0x21 * DX3(ip, 5, 5, 6)) >> 5) & D_MASK;
 		m_pos = dict[dindex];
 
 		if (m_pos < in)
 			goto literal;
 
-		if (ip == m_pos || (ip - m_pos) > M4_MAX_OFFSET)
+		if (ip == m_pos || ((size_t)(ip - m_pos) > M4_MAX_OFFSET))
 			goto literal;
 
 		m_off = ip - m_pos;
@@ -51,7 +51,7 @@ _lzo1x_1_do_compress(const unsigned char
 		if (m_pos < in)
 			goto literal;
 
-		if (ip == m_pos || (ip - m_pos) > M4_MAX_OFFSET)
+		if (ip == m_pos || ((size_t)(ip - m_pos) > M4_MAX_OFFSET))
 			goto literal;
 
 		m_off = ip - m_pos;


