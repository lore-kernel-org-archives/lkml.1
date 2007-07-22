Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbXGVQZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbXGVQZ6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:25:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbXGVQZw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:25:52 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:49196 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbXGVQZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:25:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=ijJrxS50Kcc1ut+C71sqqJZJABwQkBsrQYNnsbSbFXBRnQBtXACtLvRFrq10Ih30RY5AGJP2jbQyWjOozq3czUPjztdU59uV9UeLK4OSn3yLYXxRrGS7xQaaySu3XE9pMSu8XGz2mhJ/PtbhkYPlS6ENzHNjorjgrFrMfRsQx/k=
Message-ID: <46A38486.70903@googlemail.com>
Date: Sun, 22 Jul 2007 18:23:34 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: adaplas@gmail.com
Subject: [PATCH] Fix fbcon - 'map_override' defined but not used warning 
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I got this warning on current git:

...

drivers/video/console/fbcon.c:130: warning: 'map_override' defined but not used

...

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index decfdc8..60a14de 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -127,7 +127,9 @@ static int last_fb_vc = MAX_NR_CONSOLES - 1;
 static int fbcon_is_default = 1; 
 static int fbcon_has_exited;
 static int primary_device = -1;
+#ifndef MODULE
 static int map_override;
+#endif
 
 /* font data */
 static char fontname[40];
