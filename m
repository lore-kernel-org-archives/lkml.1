Return-Path: <linux-kernel-owner+w=401wt.eu-S1030554AbXAZBT7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030554AbXAZBT7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 20:19:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030559AbXAZBT7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 20:19:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030554AbXAZBT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 20:19:58 -0500
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@osdl.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: [PATCH] x86_64: fix put_user for 64-bit constant
X-Zippy-Says: Psychoanalysis??  I thought this was a nude rap session!!!
Message-Id: <20070126011951.ECFD5180051@magilla.sf.frob.com>
Date: Thu, 25 Jan 2007 17:19:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On x86-64, a put_user call using a 64-bit pointer and a constant value that
is > 0xffffffff will produce code that doesn't assemble.  This patch fixes
the asm construct to use the Z constraint for 32-bit constants.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 include/asm-x86_64/uaccess.h |   70 +++++++++++++++++++++---------------------
 1 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/asm-x86_64/uaccess.h b/include/asm-x86_64/uaccess.h
index d5dbc87..0129c79 100644  
--- a/include/asm-x86_64/uaccess.h
+++ b/include/asm-x86_64/uaccess.h
@@ -157,7 +157,7 @@ do {									\
 	  case 1: __put_user_asm(x,ptr,retval,"b","b","iq",-EFAULT); break;\
 	  case 2: __put_user_asm(x,ptr,retval,"w","w","ir",-EFAULT); break;\
 	  case 4: __put_user_asm(x,ptr,retval,"l","k","ir",-EFAULT); break;\
-	  case 8: __put_user_asm(x,ptr,retval,"q","","ir",-EFAULT); break;\
+	  case 8: __put_user_asm(x,ptr,retval,"q","","Zr",-EFAULT); break;\
 	  default: __put_user_bad();					\
 	}								\
 } while (0)
