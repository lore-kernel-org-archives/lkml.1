Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZBBAIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZBBAIK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Feb 2009 19:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbZBBAHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Feb 2009 19:07:45 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:35978 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbZBBAHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Feb 2009 19:07:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=qSdF9aLq70EPR638B0xJK9mq+mgoLT+I+nVV96B1i+cZRzKztVDgCW3tuJ64OjMRBT
         966kH67N1mj2hqrSxV645zPxcRoP8c7AFigZwT9TQrvx9NwyS8ZRmNRcF4TMWsOtE3pi
         w/ZMVsuv4sLSBokCzG0HkIWGNRQeYMnIJkFeg=
From: Alberto Bertogli <albertito@blitiri.com.ar>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Alberto Bertogli <albertito@blitiri.com.ar>
Subject: [PATCH 2/2] bio.h: If they MUST be inlined, then use __always_inline
Date: Sun,  1 Feb 2009 22:07:31 -0200
Message-Id: <1233533251-30240-2-git-send-email-albertito@blitiri.com.ar>
X-Mailer: git-send-email 1.6.1.1.363.g2a3bd
In-Reply-To: <1233533251-30240-1-git-send-email-albertito@blitiri.com.ar>
References: <1233533251-30240-1-git-send-email-albertito@blitiri.com.ar>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bvec_kmap_irq() and bvec_kunmap_irq() comments say they MUST be inlined,
so mark them as __always_inline.

Signed-off-by: Alberto Bertogli <albertito@blitiri.com.ar>
---
 include/linux/bio.h |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/bio.h b/include/linux/bio.h
index 0c8e3fb..713ec6e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -445,7 +445,8 @@ extern struct biovec_slab bvec_slabs[BIOVEC_NR_POOLS] __read_mostly;
  *
  * This function MUST be inlined - it plays with the CPU interrupt flags.
  */
-static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
+static __always_inline char *bvec_kmap_irq(struct bio_vec *bvec,
+		unsigned long *flags)
 {
 	unsigned long addr;
 
@@ -461,7 +462,8 @@ static inline char *bvec_kmap_irq(struct bio_vec *bvec, unsigned long *flags)
 	return (char *) addr + bvec->bv_offset;
 }
 
-static inline void bvec_kunmap_irq(char *buffer, unsigned long *flags)
+static __always_inline void bvec_kunmap_irq(char *buffer,
+		unsigned long *flags)
 {
 	unsigned long ptr = (unsigned long) buffer & PAGE_MASK;
 
-- 
1.6.1.1.363.g2a3bd

