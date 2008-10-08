Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYJHGit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYJHGit (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYJHGi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:38:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:41681 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbYJHGi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:38:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=RzRBWAj4s2jiJvLoGAY0SlQVfSvci+iz5GHpWSYa0pHeWDyY7MNcP+Vz4PB5Y7CMFE
         3Rdhah5OJws7TWqCFOmcyNFuUlYeTESVvUbqXgDs7coiLGVUG1hddET2fv5IXwIA3UQ9
         eoud3tNiIeAo6D2ji52xoLUICZE2A0ZBWSgfo=
Subject: [PATCH 2/4] m32r: Change unaligned access to use packed struct
 implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Hirokazu Takata <takata@linux-m32r.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 23:38:23 -0700
Message-Id: <1223447903.8195.66.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
There are only 3 arches that use the memmove-based implementation, there
doesn't seem to be any obvious reason not to use the struct implementation.

Hirokazu?

 include/asm-m32r/unaligned.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-m32r/unaligned.h b/include/asm-m32r/unaligned.h
index 377eb20..86ea884 100644
--- a/include/asm-m32r/unaligned.h
+++ b/include/asm-m32r/unaligned.h
@@ -2,13 +2,13 @@
 #define _ASM_M32R_UNALIGNED_H
 
 #if defined(__LITTLE_ENDIAN__)
-# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/le_struct.h>
 # include <linux/unaligned/be_byteshift.h>
 # include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_le
 # define put_unaligned	__put_unaligned_le
 #else
-# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/be_struct.h>
 # include <linux/unaligned/le_byteshift.h>
 # include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_be
-- 
1.6.0.2.471.g47a76


