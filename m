Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYJHGjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYJHGjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753680AbYJHGib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:38:31 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:10016 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYJHGia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=Vd0OvYOiNjEdAN77Vmup1zLhjUPLacUzMtHoPoRKZONQKneb7fIgWef2NLA7kOAorO
         To/G9/45Y2cURcm926GYb61ECZktwqoCrEU+e/KVQhVWcyZk2ESBAuxYYNrAUykIgHry
         8SRRUwYNR+z3gaT/zSRNaARS2bkv3fcypxUC0=
Subject: [PATCH 3/4] xtensa: Change unaligned access to use packed struct
 implementation
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Chris Zankel <chris@zankel.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 23:38:24 -0700
Message-Id: <1223447904.8195.67.camel@brick>
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

Chris?

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
1.6.0.2.471.g47a76


