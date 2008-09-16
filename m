Return-Path: <linux-kernel-owner+w=401wt.eu-S1755385AbYIOTch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385AbYIOTch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 15:32:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752920AbYIOTc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 15:32:27 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:44584 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752864AbYIOTc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 15:32:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=NUjQVnOu4xrP3erMSul5JRiVub5vm4clyi1i3cdIr5ekf+5GHxfIRtZTLwac26gE+D
         P2bBWeRzgCCCcf33x+jwR18R1hvHhXU/9v/6u6xCJ7vBIOL/5SO+nRlNI0jZmORXXSk2
         OsTglrUS1VMK+Lw8XCHW2Bxm928ZXa0LjGwIg=
Message-ID: <48CF0CA4.3090701@gmail.com>
Date: Mon, 15 Sep 2008 21:32:20 -0400
From: roel kluin <roel.kluin@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: ak@linux.intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH ?] ACPI: pr->id is unsigned
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

since pr->id is unsigned, shouldn't something like
the patch below be applied?

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
index e36422a..75c0f76 100644
--- a/drivers/acpi/processor_core.c
+++ b/drivers/acpi/processor_core.c
@@ -667,7 +667,7 @@ static int __cpuinit acpi_processor_start(struct acpi_device *device)
 		return 0;
 	}
 
-	BUG_ON((pr->id >= nr_cpu_ids) || (pr->id < 0));
+	BUG_ON((pr->id >= nr_cpu_ids) || ((unsigned long)pr->id < 0));
 
 	/*
 	 * Buggy BIOS check
