Return-Path: <linux-kernel-owner+w=401wt.eu-S1764216AbYESV5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764216AbYESV5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757669AbYESV46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:56:58 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42019 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764036AbYESV45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:56:57 -0400
Date: Tue, 20 May 2008 00:54:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] asm-generic/int-ll64.h: always provide __{s,u}64
Message-ID: <20080519215452.GK17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several compilers offer "long long" without claiming to support C99.

Considering how frequent __s64/__u64 are used our userspace headers are 
anyway unusable without __s64/__u64 available.

Always offer __s64/__u64 to non-gcc non-C99 compilers - if they provide 
"long long" that makes the headers compiling and if they don't they are 
anyway screwed.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
bd3028092483c517700a40c36ca264cedd0ff488 diff --git a/include/asm-generic/int-ll64.h b/include/asm-generic/int-ll64.h
index 2609489..f9bc9ac 100644
--- a/include/asm-generic/int-ll64.h
+++ b/include/asm-generic/int-ll64.h
@@ -26,7 +26,7 @@ typedef unsigned int __u32;
 #ifdef __GNUC__
 __extension__ typedef __signed__ long long __s64;
 __extension__ typedef unsigned long long __u64;
-#elif defined(__STDC_VERSION__) && __STDC_VERSION__ >= 199901L
+#else
 typedef __signed__ long long __s64;
 typedef unsigned long long __u64;
 #endif

