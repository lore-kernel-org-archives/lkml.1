Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYJTXIk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYJTXIk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 19:08:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbYJTXIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 19:08:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:26112 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074AbYJTXIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 19:08:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=TIRbzUhxU9IqXK7N3skEwZqAr3m9bXb0CNSR49waguyu1hDmi8SVvSEYciGVg5jxa0
         yCeh74gMXzAyZeBGx0JzRtk9CU/aRgLjnHB9/52Rk5CqPP6BuXcK3QX95F1asNZTfBGX
         riDUid7NXozhFu0WXguW9MiobOwqxeGP9SV9U=
Message-ID: <48FD63C2.40400@gmail.com>
Date: Tue, 21 Oct 2008 01:08:18 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: ballabio_dario@emc.com, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] U14-34F: fix scsi_dma_map failure case
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When unsigned, scsi_dma_map may return -ENOMEM without triggering BUG_ON()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 329eb87..601e951 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1111,7 +1111,8 @@ static int u14_34f_detect(struct scsi_host_template *tpnt) {
 
 static void map_dma(unsigned int i, unsigned int j) {
    unsigned int data_len = 0;
-   unsigned int k, count, pci_dir;
+   unsigned int k, pci_dir;
+   int count;
    struct scatterlist *sg;
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
