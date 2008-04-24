Return-Path: <linux-kernel-owner+w=401wt.eu-S1757974AbYDXPJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757974AbYDXPJT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbYDXPJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:09:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:29459 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbYDXPJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:sender;
        b=nCRNFMNEOCSvmXUaw6+LvnAMb/L0bqopZF3GWy0L90VzpUdg1d2ecNkt/wwKChk8Am5I4YOIzY8dR7BYXWoEAe+f5lTNYutK3adZjjGL86ja9ENSkQ58oW/UJwxXQDF2mcMqviQKjEKHUniAJK9ty8Zu1jl0LqkhKTD6A+MWFmQ=
Date: Thu, 24 Apr 2008 17:07:17 +0200
From: Frederik Deweerdt <deweerdt@free.fr>
To: bzolnier@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch] latest git: DEV_BLK_4DRIVES should be a tristate
Message-ID: <20080424150717.GA32700@slug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bartlomiej,

The 4drives should be a tristate, the following breakage occurs
otherwise:
ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!

The following (compile tested) patch fixes it for me.

Regards,
Frederik


Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 8753203..3f9e100 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -1031,7 +1031,7 @@ comment "Other IDE chipsets support"
 comment "Note: most of these also require special kernel boot parameters"
 
 config BLK_DEV_4DRIVES
-	bool "Generic 4 drives/port support"
+	tristate "Generic 4 drives/port support"
 	help
 	  Certain older chipsets, including the Tekram 690CD, use a single set
 	  of I/O ports at 0x1f0 to control up to four drives, instead of the
