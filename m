Return-Path: <linux-kernel-owner+w=401wt.eu-S1762581AbXFATPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762581AbXFATPn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761943AbXFATPg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:15:36 -0400
Received: from dhazelton.dsl.enter.net ([216.193.185.50]:50871 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761924AbXFATPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:15:36 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Patch [1/1] Remove JFFS2 dependancy on zlib private header
Date: Fri, 1 Jun 2007 15:15:28 -0400
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_QBHYGIZW8SO1aum"
Message-Id: <200706011515.28773.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_QBHYGIZW8SO1aum
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This change is based on recent discussions of the JFFS2 code relying on 
constants defined in the private zlib header zutil.h

The result of this discussion is to change the use of the constant into 
a 'Magic Number' (according to Mark Adler this number is part of the standard 
and will never change - defined in RFC 1950)

Signed-off-by: Daniel Hazelton <dhazelton@enter.net>


--Boundary-00=_QBHYGIZW8SO1aum
Content-Type: text/x-diff;
  charset="us-ascii";
  name="remove-jffs2-zutil.h-dependency.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="remove-jffs2-zutil.h-dependency.patch"

diff --git a/fs/jffs2/compr_zlib.c b/fs/jffs2/compr_zlib.c
index 2b87fcc..9f1b935 100644
--- a/fs/jffs2/compr_zlib.c
+++ b/fs/jffs2/compr_zlib.c
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/zlib.h>
-#include <linux/zutil.h>
 #include "nodelist.h"
 #include "compr.h"
 
@@ -154,7 +153,7 @@ static int jffs2_zlib_decompress(unsigned char *data_in,
 
 	/* If it's deflate, and it's got no preset dictionary, then
 	   we can tell zlib to skip the adler32 check. */
-	if (srclen > 2 && !(data_in[1] & PRESET_DICT) &&
+	if (srclen > 2 && !(data_in[1] & 0x20) &&
 	    ((data_in[0] & 0x0f) == Z_DEFLATED) &&
 	    !(((data_in[0]<<8) + data_in[1]) % 31)) {
 

--Boundary-00=_QBHYGIZW8SO1aum--
