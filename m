Return-Path: <linux-kernel-owner+w=401wt.eu-S934292AbZJMWOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934292AbZJMWOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbZJMWOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:14:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:58933 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759910AbZJMWOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:14:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cg5nMyR8Fuf4snyHmmtvVJGrIinfV3gnph+0XGpLLOu1qACCjbtsSjfArgihTPETyR
         GMZ8Gshjo4qOM5JxcymN5IfbLOldj+b47jePTRcZhU+Sue6YlCmJqHPQi6RRTjMA6yqc
         dHpDmQhNCSOZXApd2V6zfourqh2bxuFU75yEM=
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 1/7] mfd: pcf50633 disable unnecessary shutdown on lowsys
Date: Wed, 14 Oct 2009 02:12:30 +0400
Message-Id: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On gta02 hardware revision A5 it can actually bring the system down
during normal operating conditions so we disable it.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index d26d774..6efe5c3 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -345,6 +345,9 @@ static void pcf50633_irq_worker(struct work_struct *work)
 		goto out;
 	}
 
+	/* defeat 8s death from lowsys on A5 */
+	pcf50633_reg_write(pcf, PCF50633_REG_OOCSHDWN,  0x04);
+
 	/* We immediately read the usb and adapter status. We thus make sure
 	 * only of USBINS/USBREM IRQ handlers are called */
 	if (pcf_int[0] & (PCF50633_INT1_USBINS | PCF50633_INT1_USBREM)) {
-- 
1.6.0.6

