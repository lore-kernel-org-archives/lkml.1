Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYHMXI2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYHMXI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 19:08:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbYHMXIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 19:08:20 -0400
Received: from hpsmtp-eml17.kpnxchange.com ([213.75.38.117]:9955 "EHLO
	hpsmtp-eml17.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753588AbYHMXIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 19:08:19 -0400
From: Frans Pop <elendil@planet.nl>
To: linux-s390@vger.kernel.org
Subject: Fwd: [Patch 2.6] s390 - Allow ECKD devices to be used with older controllers and emulation
Date: Thu, 14 Aug 2008 01:07:59 +0200
User-Agent: KMail/1.9.9
Cc: Ivan Warren <ivan@vmfacility.fr>, linux-kernel@vger.kernel.org
References: <489C9494.9070504@vmfacility.fr>
In-reply-To: <489C9494.9070504@vmfacility.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808140108.00375.elendil@planet.nl>
X-OriginalArrivalTime: 13 Aug 2008 23:08:17.0530 (UTC) FILETIME=[789AE5A0:01C8FD99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forwarding to s390 kernel list as there have been no replies so far.

(Patch may have whitespace damage because of forward.)

Ivan: You may want to read Documentation/SubmittingPatches in the kernel
source tree.

--------------------------- Forwarded message ---------------------------
Crowd,

Apologies if this is not formatted correctly, but I'm fairly new to this
(submitting patches that is)..

**************
    s390 dasd ECKD drivers issues a Perform Subsystem Function / Prepare
for Read SubSystem Data with a length of 16.
    However, older hardware and documentation specifies a length of 12
leading to a possible Incorrect Length indication.
    This patch activates the SLI CCW flag in order to avoid reporting
the Incorrect Length indication since it is possible that the DASD
control unit may be expecting a length of 12, not 16.
        -- Ivan Warren (ivan@vmfacility.fr)

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c index 773b3fe..c4e3935 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -810,6 +810,7 @@ static int dasd_eckd_read_features(struct dasd_device *device)
 	ccw->cmd_code = DASD_ECKD_CCW_PSF;
 	ccw->count = sizeof(struct dasd_psf_prssd_data);
 	ccw->flags |= CCW_FLAG_CC;
+	ccw->flags |= CCW_FLAG_SLI;
 	ccw->cda = (__u32)(addr_t) prssdp;
 
 	/* Read Subsystem Data - feature codes */
**************

--Ivan
