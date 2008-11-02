Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYKBVTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYKBVTo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:19:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYKBVT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:19:28 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:45980 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbYKBVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:19:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FW+UPGcA9pWM5ptrML51szya6XQkx3/tpBty0C7yPYS9Mtgb+2rpLsNEoFG2roA/Ce
         DtJl4MJo1pxqLwNvutJYFHG5LTXDf6MRvZxhIRAjTJ5z0qGLqtWZZTymE3c/dMTI1KFD
         NxJXBzovcnlAf2clc0cwtoY3bo3NF4oPfEtZI=
Date: Sun, 2 Nov 2008 22:18:52 +0100
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Joseph Chan <JosephChan@via.com.tw>,
       Jeff Garzik <jgarzik@redhat.com>, linux-ide@vger.kernel.org
Subject: [PATCH] sata_via: restore vt*_prepare_host error handling
Message-ID: <20081102211848.GA20785@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit b9d5b89b487517cbd4cb4702da829e07ef9e4432 (sata_via: fix support
for 5287) accidently (?) removed vt*_prepare_host error handling - restore it

catched by gcc:
drivers/ata/sata_via.c: In function 'svia_init_one':
drivers/ata/sata_via.c:567: warning: 'host' may be used uninitialized in this function

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Joseph Chan <JosephChan@via.com.tw>
Cc: Jeff Garzik <jgarzik@redhat.com>
---
 drivers/ata/sata_via.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index 62367fe..c18935f 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -602,8 +602,10 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		rc = vt8251_prepare_host(pdev, &host);
 		break;
 	default:
-		return -EINVAL;
+		rc = -EINVAL;
 	}
+	if (rc)
+		return rc;
 
 	svia_configure(pdev);
 
-- 
1.5.6.4

