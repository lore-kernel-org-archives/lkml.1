Return-Path: <linux-kernel-owner+w=401wt.eu-S1754430AbZGERjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430AbZGERjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 13:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753332AbZGERi7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 13:38:59 -0400
Received: from m-04.th.seeweb.it ([217.64.195.227]:54225 "EHLO
	m-04.th.seeweb.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZGERi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 13:38:58 -0400
X-Greylist: delayed 1041 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jul 2009 13:38:58 EDT
Message-ID: <4A50E086.5090206@iragan.com>
Date: Sun, 05 Jul 2009 19:19:02 +0200
From: Giuseppe <g.mazzotta@iragan.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: mitr@volny.cz, stable@kernel.org
CC: linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: [PATCH 1/1] wistron_btns DMI info to recognize Maxdata Pro 7000 notebooks
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds DMI recognition information to automatically load the 
correct layout for the Maxdata Pro 7000X/DX notebook models. Such 
notebooks are clones of Fujitsu Amilo V2000, the hook for the v2000 is 
being used and I have tested that perfectly works.

The immediate result of integrating this patch is that the five special 
buttons will work on these specific notebook models and that the RF 
killswitch will not be activated after suspend. This patch definitively 
obsoletes the fsam7400 module which I was still needing to enable wifi 
and to fix the RF killswitch suspend problem; in the current 2.6.30 
kernel it is necessary to load the wistron_btns module with options 
'force=1 keymap=1557/MS2141', which was not anyway a complete workaround.

Signed-off-by: Giuseppe Mazzotta <g.mazzotta@iragan.com>

--- linux-2.6.30/drivers/input/misc/wistron_btns.c.orig 2009-07-05 
14:07:10.000000000 +0200
+++ linux-2.6.30/drivers/input/misc/wistron_btns.c      2009-07-05 
14:07:36.000000000 +0200
@@ -646,6 +646,15 @@ static struct dmi_system_id dmi_ids[] __
         },
         {
                 .callback = dmi_matched,
+               .ident = "Maxdata Pro 7000 DX",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "MAXDATA"),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "Pro 7000"),
+               },
+               .driver_data = keymap_fs_amilo_pro_v2000
+       },
+       {
+               .callback = dmi_matched,
                 .ident = "Fujitsu N3510",
                 .matches = {
                         DMI_MATCH(DMI_SYS_VENDOR, "FUJITSU"),
