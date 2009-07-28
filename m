Return-Path: <linux-kernel-owner+w=401wt.eu-S1755679AbZG1Vpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbZG1Vpj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 17:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755629AbZG1Vpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 17:45:35 -0400
Received: from kroah.org ([198.145.64.141]:55419 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621AbZG1Vp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 17:45:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/5] driver core: firmware_class:fix memory leak of page pointers array
Date: Tue, 28 Jul 2009 14:44:38 -0700
Message-Id: <1248817481-13372-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090728213826.GC13090@kroah.com>
References: <20090728213826.GC13090@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ming Lei <tom.leiming@gmail.com>

The page pointers array is allocated in fw_realloc_buffer() called by
firmware_data_write(), and should be freed in release function of firmware
device.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Reported-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/firmware_class.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index f285f44..7376367 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -180,7 +180,6 @@ static ssize_t firmware_loading_store(struct device *dev,
 				goto err;
 			}
 			/* Pages will be freed by vfree() */
-			fw_priv->pages = NULL;
 			fw_priv->page_array_size = 0;
 			fw_priv->nr_pages = 0;
 			complete(&fw_priv->completion);
-- 
1.6.3.2

