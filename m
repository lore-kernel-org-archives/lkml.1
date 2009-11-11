Return-Path: <linux-kernel-owner+w=401wt.eu-S1759463AbZKKV7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759463AbZKKV7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:59:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbZKKV7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:59:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22402 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759228AbZKKV7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:59:30 -0500
Date: Wed, 11 Nov 2009 16:59:28 -0500
From: Dave Jones <davej@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: kraxel@bytesex.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix argument order in memset call in
 ./drivers/media/common/ir-functions.c
Message-ID: <20091111215928.GA25154@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mauro Carvalho Chehab <mchehab@redhat.com>, kraxel@bytesex.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Size is the third argument, not the second.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/media/common/ir-functions.c b/drivers/media/common/ir-functions.c
index 655474b..abd4791 100644
--- a/drivers/media/common/ir-functions.c
+++ b/drivers/media/common/ir-functions.c
@@ -64,7 +64,7 @@ void ir_input_init(struct input_dev *dev, struct ir_input_state *ir,
 
 	ir->ir_type = ir_type;
 
-	memset(ir->ir_codes, sizeof(ir->ir_codes), 0);
+	memset(ir->ir_codes, 0, sizeof(ir->ir_codes));
 
 	/*
 	 * FIXME: This is a temporary workaround to use the new IR tables
