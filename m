Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbYB1A6Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbYB1A6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 19:58:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757419AbYB1A4Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 19:56:25 -0500
Received: from el-out-1112.google.com ([209.85.162.176]:41369 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761486AbYB1A4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 19:56:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=wg6I9fjktPbml+Hmd2DF+bfvTWyxGBnFFdEjuoqMUFdNDZshmY21TGwdcImaRvlgzuAgg2soFr06IKq/MaEdS7QsR9sBVpUlqFGe7hpctJPnbS8+vIZgMwpk/yinbgh46dylwCqqGWDtmfzkgQnDXxv7DYv8MBOpFWo+6ReO/Uo=
Subject: [PATCH 07/12] sound: rme96.c fix integer as NULL pointer warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 Feb 2008 16:56:07 -0800
Message-Id: <1204160167.20280.55.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kernel style does assignment outside of if() block
sound/pci/rme96.c:1562:71: warning: Using plain integer as NULL pointer

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 sound/pci/rme96.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/sound/pci/rme96.c b/sound/pci/rme96.c
index fb0a4ee..3fdd488 100644
--- a/sound/pci/rme96.c
+++ b/sound/pci/rme96.c
@@ -1559,7 +1559,8 @@ snd_rme96_create(struct rme96 *rme96)
 		return err;
 	rme96->port = pci_resource_start(rme96->pci, 0);
 
-	if ((rme96->iobase = ioremap_nocache(rme96->port, RME96_IO_SIZE)) == 0) {
+	rme96->iobase = ioremap_nocache(rme96->port, RME96_IO_SIZE);
+	if (!rme96->iobase) {
 		snd_printk(KERN_ERR "unable to remap memory region 0x%lx-0x%lx\n", rme96->port, rme96->port + RME96_IO_SIZE - 1);
 		return -ENOMEM;
 	}
-- 
1.5.4.3.342.g99e8


