Return-Path: <linux-kernel-owner+w=401wt.eu-S1755790AbYFXA3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790AbYFXA3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755728AbYFXA3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:29:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:43395 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbYFXA3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:29:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=xWgYk6ip/WoleUPSyQ9Axsv9Xa1Ci/nq9IEYSKPH5Cb3WKcJie6nXgUEyjIgZ8F4G5
         15N/wFspu7XtRTUYQMABCunrJq0AkykY/CAM1aFFqZG9/rrE+HIJLV+lgp6+6/WTGEx2
         pYrmN42WsdUoFS1SGEmIKN988+x6eqKAuhIRo=
Subject: [PATCH 3/3] xtensa: Use packed struct rather than memmove for
	unaligned access
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 23 Jun 2008 17:29:00 -0700
Message-Id: <1214267340.21092.58.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
﻿There are only 3 arches that use the memmove implementation, do you see
any problems with using the packed struct implementation so the memmove
version could be removed?

 include/asm-xtensa/unaligned.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-xtensa/unaligned.h b/include/asm-xtensa/unaligned.h
index 8f3424f..1a242b2 100644
--- a/include/asm-xtensa/unaligned.h
+++ b/include/asm-xtensa/unaligned.h
@@ -11,13 +11,13 @@
 #define _ASM_XTENSA_UNALIGNED_H
 
 #ifdef __XTENSA_EL__
-# include <linux/unaligned/le_memmove.h>
+# include <linux/unaligned/le_struct.h>
 # include <linux/unaligned/be_byteshift.h>
 # include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_le
 # define put_unaligned	__put_unaligned_le
 #elif defined(__XTENSA_EB__)
-# include <linux/unaligned/be_memmove.h>
+# include <linux/unaligned/be_struct.h>
 # include <linux/unaligned/le_byteshift.h>
 # include <linux/unaligned/generic.h>
 # define get_unaligned	__get_unaligned_be
-- 
1.5.6.290.gc4e15

