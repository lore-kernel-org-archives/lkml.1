Return-Path: <linux-kernel-owner+w=401wt.eu-S1760237AbXHWLrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760237AbXHWLrQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 07:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755257AbXHWLrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 07:47:06 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41853 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302AbXHWLrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 07:47:05 -0400
Date: Thu, 23 Aug 2007 05:47:03 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] PTR_ALIGN
Message-ID: <20070823114703.GQ9163@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The AdvanSys driver wants to align some pointers, and the ALIGN macro
doesn't work for pointers.  Rather than try to make it work, add a new
PTR_ALIGN macro which is typesafe.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index f592df7..47160fe 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -34,6 +34,7 @@ extern const char linux_proc_banner[];
 
 #define ALIGN(x,a)		__ALIGN_MASK(x,(typeof(x))(a)-1)
 #define __ALIGN_MASK(x,mask)	(((x)+(mask))&~(mask))
+#define PTR_ALIGN(p, a)		((typeof(p))ALIGN((unsigned long)(p), (a)))
 
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
