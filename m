Return-Path: <linux-kernel-owner+w=401wt.eu-S1751405AbZHESST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbZHESST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750867AbZHESSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:18:18 -0400
Received: from wg.visionengravers.com ([67.136.234.194]:4350 "EHLO
	visionfs1.visionengravers.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750821AbZHESSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:18:18 -0400
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] jbd.h jbd2.h: bitfields should be unsigned
Date: Wed, 5 Aug 2009 11:18:15 -0700
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908051118.15807.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bitfields should be unsigned.

This fixes sparse noise:
  error: dubious one-bit signed bitfield

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index c2049a0..f1edb76 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -556,7 +556,7 @@ struct transaction_s
 	 * This transaction is being forced and some process is
 	 * waiting for it to finish.
 	 */
-	int t_synchronous_commit:1;
+	unsigned int t_synchronous_commit:1;
 };
 
 /**
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index d97eb65..52695d3 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -652,7 +652,7 @@ struct transaction_s
 	 * This transaction is being forced and some process is
 	 * waiting for it to finish.
 	 */
-	int t_synchronous_commit:1;
+	unsigned int t_synchronous_commit:1;
 
 	/*
 	 * For use by the filesystem to store fs-specific data
