Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbYIKDSc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbYIKDSc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 23:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752254AbYIKDR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 23:17:59 -0400
Received: from mail.windriver.com ([147.11.1.11]:37587 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbYIKDR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 23:17:58 -0400
From: Kevin Hao <kexin.hao@windriver.com>
To: ak@linux.intel.com, astarikovskiy@suse.de, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: [PATCH 1/2] fix acpi ec read write bug
Date: Thu, 11 Sep 2008 11:17:44 +0800
Message-Id: <d41e1c0a5be061176c65db7ef42263f75ae84dcb.1221102420.git.kexin.hao@windriver.com>
X-Mailer: git-send-email 1.5.6.2.220.g44701
In-Reply-To: <1221103065-9123-1-git-send-email-kexin.hao@windriver.com>
References: <1221103065-9123-1-git-send-email-kexin.hao@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fill in command unit of transaction_data structure, otherwise
gpe_transaction will skip read or write instruction.

Signed-off-by: Kevin Hao <kexin.hao@windriver.com>
---
 drivers/acpi/ec.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index bd3555c..0c65e82 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -240,6 +240,7 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec, u8 command,
 	}
 	atomic_set(&ec->irq_count, 0);
 	/* fill in transaction structure */
+	ec->t.command = command;
 	ec->t.wdata = wdata;
 	ec->t.wlen = wdata_len;
 	ec->t.rdata = rdata;
-- 
1.5.6.2.220.g44701

