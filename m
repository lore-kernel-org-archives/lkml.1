Return-Path: <linux-kernel-owner+w=401wt.eu-S1757811AbYBDWhD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757811AbYBDWhD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 17:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757127AbYBDWgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 17:36:50 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:43531 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757031AbYBDWgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 17:36:48 -0500
Message-ID: <47A7937C.7040701@tiscali.nl>
Date: Mon, 04 Feb 2008 23:36:44 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: ballabio_dario@emc.com
CC: linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH][drivers/scsi/u14-34f.c] duplicate test 'SCpnt->sc_data_direction
 == DMA_FROM_DEVICE'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It should be like this I guess? this patch was not yet tested, please
confirm.
--
Note the duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'

from Documentation/DMA-API.txt:
DMA_TO_DEVICE         = PCI_DMA_TODEVICE      data is going from the
                                              memory to the device
DMA_FROM_DEVICE       = PCI_DMA_FROMDEVICE    data is coming from
                                              the device to the

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 662c004..1e704f9 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -1208,15 +1208,15 @@ static void scsi_to_dev_dir(unsigned int i, unsigned int j) {
       };
 
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
 
    cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
 
-   if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
+   if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
       cpp->xdir = DTD_IN;
       return;
       }
    else if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
       cpp->xdir = DTD_OUT;
       return;
       }

