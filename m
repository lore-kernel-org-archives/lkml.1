Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYIXTiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYIXTiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753315AbYIXTiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:38:18 -0400
Received: from igw2.br.ibm.com ([32.104.18.25]:52835 "EHLO igw2.br.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014AbYIXTiQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:38:16 -0400
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, serue@linux.vnet.ibm.com,
       safford@watson.ibm.com, debora@linux.vnet.ibm.com,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: [PATCH 1/2] TPM: Missing put_device()
Date: Wed, 24 Sep 2008 16:34:16 -0300
Message-Id: <1222284857-32042-1-git-send-email-srajiv@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case one calling tpm_open() whilst other process is owning it,
the refcount wouldn't get 0.

This patch depends on [PATCH 3/4][resubmit] TPM: rcu locking, sent on 23 Sep 2008.

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
---
 drivers/char/tpm/tpm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
index f6bbc1d..ab03b4d 100644
--- a/drivers/char/tpm/tpm.c
+++ b/drivers/char/tpm/tpm.c
@@ -979,6 +979,7 @@ int tpm_open(struct inode *inode, struct file *file)
 
 	if (test_and_set_bit(0, &chip->is_open)) {
 		dev_dbg(chip->dev, "Another process owns this TPM\n");
+		put_device(chip->dev);
 		return -EBUSY;
 	}
 
-- 
1.5.6.3

