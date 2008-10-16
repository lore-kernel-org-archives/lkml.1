Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbYJPAPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbYJPAPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753992AbYJPAPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:15:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:29058 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955AbYJPAPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=EPkVayOVp3cQWRAZ341PEWk3pOKWiy9ZwVBT9ehfXl2MatstYbeYDNIkv4GBcnnheO
         l7YzdSxMbMBIsk61G3urTIRzxwCrLHIYFkaL60qHTB9tjmx5F3cMrHxucdBfohnGdNBT
         BLO5IwHa7Z0y20121Zf8XtNvxJ2F86GoNdmkE=
Subject: [PATCH] sparc64: Annotate pointers in PeeCeeI.c
From: Harvey Harrison <harvey.harrison@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux <sparclinux@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 15 Oct 2008 17:15:19 -0700
Message-Id: <1224116119.5815.11.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has no functional changes, but annotates the code to make
the endianness more clear.  In addition, removes some of the only
users of cpu_to_le[16|32]p in the kernel.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/sparc64/lib/PeeCeeI.c |   34 +++++++++++++++++-----------------
 1 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/arch/sparc64/lib/PeeCeeI.c b/arch/sparc64/lib/PeeCeeI.c
index 8b313f1..e609b65 100644
--- a/arch/sparc64/lib/PeeCeeI.c
+++ b/arch/sparc64/lib/PeeCeeI.c
@@ -53,32 +53,32 @@ void outsl(unsigned long __addr, const void *src, unsigned long count)
 
 	if (count) {
 		if ((((u64)src) & 0x3) == 0) {
-			u32 *p = (u32 *)src;
+			__le32 *p = (__le32 *)src;
 			while (count--) {
-				u32 val = cpu_to_le32p(p);
+				u32 val = le32_to_cpup(p);
 				outl(val, addr);
 				p++;
 			}
 		} else {
 			u8 *pb;
-			u16 *ps = (u16 *)src;
+			__le16 *ps = (__le16 *)src;
 			u32 l = 0, l2;
-			u32 *pi;
+			__le32 *pi;
 
 			switch (((u64)src) & 0x3) {
 			case 0x2:
 				count -= 1;
-				l = cpu_to_le16p(ps) << 16;
+				l = le16_to_cpup(ps) << 16;
 				ps++;
-				pi = (u32 *)ps;
+				pi = (__le32 *)ps;
 				while (count--) {
-					l2 = cpu_to_le32p(pi);
+					l2 = le32_to_cpup(pi);
 					pi++;
 					outl(((l >> 16) | (l2 << 16)), addr);
 					l = l2;
 				}
-				ps = (u16 *)pi;
-				l2 = cpu_to_le16p(ps);
+				ps = (__le16 *)pi;
+				l2 = le16_to_cpup(ps);
 				outl(((l >> 16) | (l2 << 16)), addr);
 				break;
 
@@ -86,13 +86,13 @@ void outsl(unsigned long __addr, const void *src, unsigned long count)
 				count -= 1;
 				pb = (u8 *)src;
 				l = (*pb++ << 8);
-				ps = (u16 *)pb;
-				l2 = cpu_to_le16p(ps);
+				ps = (__le16 *)pb;
+				l2 = le16p_to_cpup(ps);
 				ps++;
 				l |= (l2 << 16);
-				pi = (u32 *)ps;
+				pi = (__le32 *)ps;
 				while (count--) {
-					l2 = cpu_to_le32p(pi);
+					l2 = le32_to_cpup(pi);
 					pi++;
 					outl(((l >> 8) | (l2 << 24)), addr);
 					l = l2;
@@ -105,15 +105,15 @@ void outsl(unsigned long __addr, const void *src, unsigned long count)
 				count -= 1;
 				pb = (u8 *)src;
 				l = (*pb++ << 24);
-				pi = (u32 *)pb;
+				pi = (__le32 *)pb;
 				while (count--) {
-					l2 = cpu_to_le32p(pi);
+					l2 = le32_to_cpup(pi);
 					pi++;
 					outl(((l >> 24) | (l2 << 8)), addr);
 					l = l2;
 				}
-				ps = (u16 *)pi;
-				l2 = cpu_to_le16p(ps);
+				ps = (__le16 *)pi;
+				l2 = le16_to_cpup(ps);
 				ps++;
 				pb = (u8 *)ps;
 				l2 |= (*pb << 16);
-- 
1.6.0.2.711.gf1ba4



