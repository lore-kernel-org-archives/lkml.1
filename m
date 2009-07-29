Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZG2URY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZG2URY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 16:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZG2URX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 16:17:23 -0400
Received: from mail-fx0-f215.google.com ([209.85.220.215]:37952 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806AbZG2URT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 16:17:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=Gm87E2d29oGB6K0BZQ6eQ1fAC6DuRr4U6z0mmKrYhcxwVprYWBt/gCTmkkETFlvAnS
         WLgMw/Hzg/y/A09aBFDTUS2HXei/vFJ2KLVWb/m0czrbZgACflUcq9uRx7hczZJbu/6z
         beg8H15MCUUbaDnDaY5yIb7MEq7Dw7HlWo+Yk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>
Subject: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks
Date: Wed, 29 Jul 2009 22:14:30 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc3-next-20090722-04415-ge5aa24a-dirty; KDE/4.2.4; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dan Carpenter <error27@gmail.com>, corbet@lwn.net, eteo@redhat.com,
       Julia Lawall <julia@diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907292214.31038.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] fujitsu-laptop: remove superfluous NULL pointer checks

This takes care of the following entries from Dan's list:

drivers/platform/x86/fujitsu-laptop.c +327 set_lcd_level(13) warning: variable derefenced before check 'fujitsu'
drivers/platform/x86/fujitsu-laptop.c +358 set_lcd_level_alt(13) warning: variable derefenced before check 'fujitsu'

Reported-by: Dan Carpenter <error27@gmail.com>
Cc: corbet@lwn.net
Cc: eteo@redhat.com
Cc: Julia Lawall <julia@diku.dk>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/platform/x86/fujitsu-laptop.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/platform/x86/fujitsu-laptop.c
===================================================================
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
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
