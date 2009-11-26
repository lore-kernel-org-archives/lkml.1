Return-Path: <linux-kernel-owner+w=401wt.eu-S1760392AbZKZPky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760392AbZKZPky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 10:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751148AbZKZPky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 10:40:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49957 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750897AbZKZPkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 10:40:53 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] Edwin =?utf-8?b?VMO2csO2aw==?= found the following, so fix it
To: mchehab@redhat.com, linux-kernel@vger.kernel.org
Date: Thu, 26 Nov 2009 15:22:11 +0000
Message-ID: <20091126152154.18281.24788.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function ‘memset’,
inlined from ‘ir_input_init’ at drivers/media/common/ir-functions.c:67:
/home/edwin/builds/linux-2.6/arch/x86/include/asm/string_64.h:61:
warning: call to ‘__warn_memset_zero_len’ declared with attribute
warning: memset used with constant zero length parameter; this could be
due to transposed parameters
memset(ir->ir_codes, sizeof(ir->ir_codes), 0);


In actual practice the only caller I can find happens to already have cleared
the buffer before calling ir_input_init.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/media/common/ir-functions.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/media/common/ir-functions.c b/drivers/media/common/ir-functions.c
index 98b5125..fc2d894 100644
--- a/drivers/media/common/ir-functions.c
+++ b/drivers/media/common/ir-functions.c
@@ -64,7 +64,7 @@ void ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
 
 	ir->ir_type = ir_type;
 
-	memset(ir->ir_codes, sizeof(ir->ir_codes), 0);
+	memset(ir->ir_codes, 0, sizeof(ir->ir_codes));
 
 	/*
 	 * FIXME: This is a temporary workaround to use the new IR tables

