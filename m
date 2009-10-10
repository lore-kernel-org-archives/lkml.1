Return-Path: <linux-kernel-owner+w=401wt.eu-S933020AbZJJREq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbZJJREq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 13:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761960AbZJJREo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 13:04:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:38427 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZJJREn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 13:04:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=oQ8yp/76toLfJY7jVMFcJAUD5Rs+Ssx0wfb71tgnqeUR4W0DceCaX0jGpJOl006BmV
         P6jjpEbfsV6lVSMIJDM2rZRAbixkVlZ6+LQ/uDCAK33hbKlEEmfpTAN+WLlFCF1j9Le3
         82Lc20D7CVDJ03SzKIGl5D0Or6QVoEHjYZ/kw=
Date: Sat, 10 Oct 2009 19:03:58 +0200
From: Luca Niccoli <lultimouomo@gmail.com>
To: linux-kernel@vger.kernel.org, acpi4asus-user@lists.sourceforge.net
Cc: corentincj@iksaif.net
Subject: [PATCH] eeepc-laptop.c: Don't enable camera at startup if it's
 already on.
Message-ID: <4ad0be7e.iK8Do4SqIQc+U+yc%lultimouomo@gmail.com>
User-Agent: Heirloom mailx 12.4 7/29/08
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switching the camera takes 500ms, checking if it's on is almost free...
The BIOS remembers the setting through reboots, so there's good chance the
camera is already enabled.

Signed-off-by: Luca Niccoli <lultimouomo@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 749e210..2754304 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -356,7 +356,8 @@ static void __init eeepc_enable_camera(void)
 	 * If the following call to set_acpi() fails, it's because there's no
 	 * camera so we can ignore the error.
 	 */
-	set_acpi(CM_ASL_CAMERA, 1);
+	if (get_acpi(CM_ASL_CAMERA) == 0)
+		set_acpi(CM_ASL_CAMERA, 1);
 }
 
 /*
