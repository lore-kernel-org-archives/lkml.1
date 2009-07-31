Return-Path: <linux-kernel-owner+w=401wt.eu-S1751484AbZGaIoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbZGaIoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 04:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZGaIoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 04:44:25 -0400
Received: from adelphi.physics.adelaide.edu.au ([129.127.102.1]:51418 "EHLO
	adelphi.physics.adelaide.edu.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbZGaIoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 04:44:24 -0400
From: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Message-Id: <200907310843.n6V8huKA006735@mercury.physics.adelaide.edu.au>
Subject: [PATCH 2/4] fujitsu-laptop: remove superfluous NULL pointer checks
To: linux-acpi@vger.kernel.org
Date: Fri, 31 Jul 2009 18:13:56 +0930 (CST)
Cc: jwoithe@physics.adelaide.edu.au (Jonathan Woithe),
       linux-kernel@vger.kernel.org, julia@diku.dk, bzolnier@gmail.com,
       error27@gmail.com, corbet@lwn.net, eteo@redhat.com
X-Mailer: ELM [version 2.5 PL6]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 2/4] fujitsu-laptop: remove superfluous NULL pointer checks

This takes care of the following entries from Dan's list:

drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning:
variable derefenced before check 'fujitsu'
drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning:
variable derefenced before check 'fujitsu'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Acked-by: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>

--- a/drivers/platform/x86/fujitsu-laptop.c	2009-07-31 17:13:01.160777027 +0930
+++ b/drivers/platform/x86/fujitsu-laptop.c	2009-07-31 17:14:09.975776844 +0930
@@ -324,9 +324,6 @@ static int set_lcd_level(int level)
 	if (level < 0 || level >= fujitsu->max_brightness)
 		return -EINVAL;
 
-	if (!fujitsu)
-		return -EINVAL;
-
 	status = acpi_get_handle(fujitsu->acpi_handle, "SBLL", &handle);
 	if (ACPI_FAILURE(status)) {
 		vdbg_printk(FUJLAPTOP_DBG_ERROR, "SBLL not present\n");
@@ -355,9 +352,6 @@ static int set_lcd_level_alt(int level)
 	if (level < 0 || level >= fujitsu->max_brightness)
 		return -EINVAL;
 
-	if (!fujitsu)
-		return -EINVAL;
-
 	status = acpi_get_handle(fujitsu->acpi_handle, "SBL2", &handle);
 	if (ACPI_FAILURE(status)) {
 		vdbg_printk(FUJLAPTOP_DBG_ERROR, "SBL2 not present\n");
