Return-Path: <linux-kernel-owner+w=401wt.eu-S1759263AbYHHSxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759263AbYHHSxU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 14:53:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbYHHSxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 14:53:12 -0400
Received: from debpc-vmf.vmfacility.fr ([81.252.8.2]:41383 "EHLO
	debpc-vmf.local.vmfacility.fr" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751008AbYHHSxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 14:53:11 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Aug 2008 14:53:11 EDT
Message-ID: <489C9494.9070504@vmfacility.fr>
Date: Fri, 08 Aug 2008 20:46:44 +0200
From: Ivan Warren <ivan@vmfacility.fr>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [Patch 2.6] s390 - Allow ECKD devices to be used with older controllers
 and emulation
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 773b3fe..c4e3935 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -810,6 +810,7 @@ static int dasd_eckd_read_features(struct 
dasd_device *device)
        ccw->cmd_code = DASD_ECKD_CCW_PSF;
        ccw->count = sizeof(struct dasd_psf_prssd_data);
        ccw->flags |= CCW_FLAG_CC;
+       ccw->flags |= CCW_FLAG_SLI;
        ccw->cda = (__u32)(addr_t) prssdp;

        /* Read Subsystem Data - feature codes */
**************

--Ivan
