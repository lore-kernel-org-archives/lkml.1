Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbZGYQ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbZGYQ1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 12:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZGYQ1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 12:27:48 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:45988 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbZGYQ1r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 12:27:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=K44gNVCyJImRxj/8JSlig7rVixvjpAffn8gCxcgG4tt+UJ4ScY9QO8jpSLpvTX6UvM
         oBQn99jPF2NVaahuMMJWqCRtTnpE7EEhCXUGrfMSd2BZmjiqjj5/Ke3oqQmm0g0z/ptT
         bjfGQdde20UsmPMwAOMTodaarvbpvtF50URUY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH] acpi: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()
Date: Sat, 25 Jul 2009 18:24:30 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc4-next-20090723-04314-g011b7b2-dirty; KDE/4.2.4; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200907251824.31074.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] acpi: remove superfluous NULL pointer check from acpi_processor_get_throttling_info()

>From Dan's list:

drivers/acpi/processor_throttling.c +1139 acpi_processor_get_throttling_info(11) warning: variable derefenced before check 'pr'

acpi_processor_get_throttling_info() is never called with pr == NULL.

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/acpi/processor_throttling.c |    3 ---
 1 file changed, 3 deletions(-)

Index: b/drivers/acpi/processor_throttling.c
===================================================================
--- a/drivers/acpi/processor_throttling.c
+++ b/drivers/acpi/processor_throttling.c
@@ -1135,9 +1135,6 @@ int acpi_processor_get_throttling_info(s
 			  pr->throttling.duty_offset,
 			  pr->throttling.duty_width));
 
-	if (!pr)
-		return -EINVAL;
-
 	/*
 	 * Evaluate _PTC, _TSS and _TPC
 	 * They must all be present or none of them can be used.
