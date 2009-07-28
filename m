Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383AbZG1Tll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383AbZG1Tll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 15:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753858AbZG1Tlk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 15:41:40 -0400
Received: from server1.wserver.cz ([82.113.45.157]:35376 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbZG1Tlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 15:41:39 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] UIO: mark uio.h functions __KERNEL__ only
Date: Tue, 28 Jul 2009 21:41:34 +0200
Message-Id: <1248810094-30094-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090728193139.GA11468@infradead.org>
References: <20090728193139.GA11468@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To avoid userspace build failures such as:
.../linux/uio.h:37: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘iov_length’
.../linux/uio.h:47: error: expected declaration specifiers or ‘...’ before ‘size_t’
move uio functions inside a __KERNEL__ block.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/uio.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/uio.h b/include/linux/uio.h
index b7fe138..693c149 100644
--- a/include/linux/uio.h
+++ b/include/linux/uio.h
@@ -35,6 +35,7 @@ struct kvec {
 #define UIO_FASTIOV	8
 #define UIO_MAXIOV	1024
 
+#ifdef __KERNEL__
 /*
  * Total number of bytes covered by an iovec.
  *
@@ -53,5 +54,6 @@ static inline size_t iov_length(const struct iovec *iov, unsigned long nr_segs)
 }
 
 unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to);
+#endif
 
 #endif
-- 
1.6.3.3

