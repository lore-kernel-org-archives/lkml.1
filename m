Return-Path: <linux-kernel-owner+w=401wt.eu-S1759634AbYG3WXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759634AbYG3WXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYG3WXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:23:10 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:24568 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYG3WXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:23:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=xoOds4ctwUqp2VjGbt6HMElqIe91EswQxvRc37D4az666hec6df1g8PKt60NxCke4i
         s721OU0Vv6ptpdQ5mEhIXF75rWSVCxNmFP1AJqwNFPt87ujB+Kbhr57CrriTtrfjAMjN
         v1UoriFlRPU2QOx5v6GGsjiDdHLrheCobpnPw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 1/3] ide: check only for CACHE FLUSH command support in ide_id_has_flush_cache()
Date: Wed, 30 Jul 2008 23:24:34 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807302324.34258.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All devices supporting CACHE FLUSH EXT command should also support
CACHE FLUSH command so it is sufficient to check only for CACHE FLUSH
in ide_id_has_flush_cache().

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1451,8 +1451,8 @@ extern struct mutex ide_cfg_mtx;
 extern struct bus_type ide_bus_type;
 extern struct class *ide_port_class;
 
-/* check if CACHE FLUSH (EXT) command is supported (bits defined in ATA-6) */
-#define ide_id_has_flush_cache(id)	((id)[ATA_ID_CFS_ENABLE_2] & 0x3000)
+/* check if CACHE FLUSH command is supported (as defined in ATA-6) */
+#define ide_id_has_flush_cache(id)	((id)[ATA_ID_CFS_ENABLE_2] & 0x1000)
 
 /* some Maxtor disks have bit 13 defined incorrectly so check bit 10 too */
 #define ide_id_has_flush_cache_ext(id)	\
