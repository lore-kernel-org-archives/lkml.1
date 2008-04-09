Return-Path: <linux-kernel-owner+w=401wt.eu-S1756013AbYDITqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013AbYDITqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753266AbYDITqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:46:06 -0400
Received: from rn-out-0910.google.com ([64.233.170.191]:42920 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYDITqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=grEoJMIp6enKB2DT5MJHFkubgFbsBUvhnBjAxgMss8Bh+eBAP6znnldimDkQBsLZW4v3ShwZGOuUOyBRx4xSVv8vgQYJgRk66fGyLpm0+akT66GwjqSYWAWelkS6T7wOSNQ87M0cs6s0dWiu3TXBPa6uYwsIFKDqX6SfNrQ/EUQ=
Subject: [PATCH] unaligned access, fix some includes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch <linux-arch@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1207765322.16220.8.camel@brick>
References: <1207765322.16220.8.camel@brick>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 12:46:20 -0700
Message-Id: <1207770380.16220.19.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Missed a few includes when moving some files around, this makes it
actually compile.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
Applies on top of the unaligned access revamp, missed when moving files
around.

 include/linux/unaligned/generic_be.h        |    2 +-
 include/linux/unaligned/generic_le.h        |    2 +-
 include/linux/unaligned/no_builtin_memcpy.h |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/unaligned/generic_be.h b/include/linux/unaligned/generic_be.h
index ce42487..dd7e323 100644
--- a/include/linux/unaligned/generic_be.h
+++ b/include/linux/unaligned/generic_be.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_GENERIC_BE_H_
 #define _LINUX_UNALIGNED_GENERIC_BE_H_
 
-#include <linux/unaligned/generic.h>
+#include <linux/unaligned/cpu_endian.h>
 #include <linux/unaligned/little_endian.h>
 
 #define get_unaligned	__get_unaligned_cpu
diff --git a/include/linux/unaligned/generic_le.h b/include/linux/unaligned/generic_le.h
index b57c818..7b7de52 100644
--- a/include/linux/unaligned/generic_le.h
+++ b/include/linux/unaligned/generic_le.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_UNALIGNED_GENERIC_LE_H_
 #define _LINUX_UNALIGNED_GENERIC_LE_H_
 
-#include <linux/unaligned/generic.h>
+#include <linux/unaligned/cpu_endian.h>
 #include <linux/unaligned/big_endian.h>
 
 #define get_unaligned	__get_unaligned_cpu
diff --git a/include/linux/unaligned/no_builtin_memcpy.h b/include/linux/unaligned/no_builtin_memcpy.h
index 17a6e21..c117e78 100644
--- a/include/linux/unaligned/no_builtin_memcpy.h
+++ b/include/linux/unaligned/no_builtin_memcpy.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_UNALIGNED_NO_BUILTIN_MEMCPY_H_
 #define _LINUX_UNALIGNED_NO_BUILTIN_MEMCPY_H_
 
+#include <linux/kernel.h>
 #include <asm/byteorder.h>
 #include <asm/string.h>
 
-- 
1.5.5.144.g3e42



