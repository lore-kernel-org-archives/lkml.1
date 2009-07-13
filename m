Return-Path: <linux-kernel-owner+w=401wt.eu-S1757049AbZGMU1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbZGMU1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZGMU1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:27:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:57587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755636AbZGMU1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:27:48 -0400
Date: Mon, 13 Jul 2009 16:27:46 -0400
From: Dave Jones <davej@redhat.com>
To: linux-scsi@vger.kernel.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Fix __LITTLE_ENDIAN definition warnings in qla2xxx
Message-ID: <20090713202746.GA14479@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, linux-scsi@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On ppc64, gcc 4.4 spews lots of..

drivers/scsi/qla2xxx/qla_def.h:1485:7: warning: "__LITTLE_ENDIAN" is not defined

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 00aa48d..9fde8bf 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -1482,7 +1482,7 @@ typedef union {
 		uint8_t domain;
 		uint8_t area;
 		uint8_t al_pa;
-#elif __LITTLE_ENDIAN
+#elif defined(__LITTLE_ENDIAN)
 		uint8_t al_pa;
 		uint8_t area;
 		uint8_t domain;
