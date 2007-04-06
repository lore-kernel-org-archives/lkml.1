Return-Path: <linux-kernel-owner+w=401wt.eu-S932893AbXDFUcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbXDFUcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 16:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932886AbXDFUcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 16:32:16 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:50968 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932819AbXDFUcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 16:32:15 -0400
Date: Fri, 6 Apr 2007 13:30:35 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       stable@kernel.org
Subject: Re: Linux 2.6.20.6
Message-ID: <20070406203035.GV10574@sequoia.sous-sol.org>
References: <20070406202948.GU10574@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070406202948.GU10574@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 3f194d1..e81e106 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 20
-EXTRAVERSION = .5
+EXTRAVERSION = .6
 NAME = Homicidal Dwarf Hamster
 
 # *DOCUMENTATION*
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index a664231..0f76175 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -91,7 +91,7 @@ void scatterwalk_copychunks(void *buf, struct scatter_walk *walk,
 		memcpy_dir(buf, vaddr, len_this_page, out);
 		scatterwalk_unmap(vaddr, out);
 
-		scatterwalk_advance(walk, nbytes);
+		scatterwalk_advance(walk, len_this_page);
 
 		if (nbytes == len_this_page)
 			break;
diff --git a/include/asm-um/common.lds.S b/include/asm-um/common.lds.S
index b16222b..f5de80c 100644
--- a/include/asm-um/common.lds.S
+++ b/include/asm-um/common.lds.S
@@ -15,7 +15,7 @@
   PROVIDE (_unprotected_end = .);
 
   . = ALIGN(4096);
-  .note : { *(note.*) }
+  .note : { *(.note.*) }
   __start___ex_table = .;
   __ex_table : { *(__ex_table) }
   __stop___ex_table = .;
