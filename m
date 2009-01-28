Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbZA1Xco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbZA1Xco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756956AbZA1X2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:21 -0500
Received: from kroah.org ([198.145.64.141]:57003 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755010AbZA1X2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/10] Staging: poch: fix verification of memory area
Date: Wed, 28 Jan 2009 15:26:50 -0800
Message-Id: <1233185210-23098-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

fix verification of memory area

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/poch/poch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/poch/poch.c b/drivers/staging/poch/poch.c
index ec343ef..0d111dd 100644
--- a/drivers/staging/poch/poch.c
+++ b/drivers/staging/poch/poch.c
@@ -1026,7 +1026,7 @@ static int poch_ioctl(struct inode *inode, struct file *filp,
 		}
 		break;
 	case POCH_IOC_GET_COUNTERS:
-		if (access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters)))
+		if (!access_ok(VERIFY_WRITE, argp, sizeof(struct poch_counters)))
 			return -EFAULT;
 
 		spin_lock_irq(&channel->counters_lock);
-- 
1.6.0.2

