Return-Path: <linux-kernel-owner+w=401wt.eu-S1759397AbXFDQvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397AbXFDQvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 12:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759260AbXFDQvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 12:51:38 -0400
Received: from lmtp1.ucs.ed.ac.uk ([129.215.149.64]:39210 "EHLO
	lmtp1.ucs.ed.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236AbXFDQvh (ORCPT
	<rfc822;Linux-Kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 12:51:37 -0400
X-Greylist: delayed 2325 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 12:51:36 EDT
Message-ID: <466439FC.4040204@ed.ac.uk>
Date: Mon, 04 Jun 2007 17:12:44 +0100
From: James Jarvis <James.Jarvis@ed.ac.uk>
User-Agent: Thunderbird 1.5.0.7 (X11/20060913)
MIME-Version: 1.0
To: Riley@Williams.Name
CC: Linux-Kernel@vger.kernel.org, graham.newton@ed.ac.uk,
       kenneth.macdonald@ed.ac.uk
Subject: DMI_MATCH patch in reboot.c for SFF Dell OptiPlex 745 - fixes hang
 on reboot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Edinburgh-Scanned: at lmtp1.ucs.ed.ac.uk
    with MIMEDefang 2.52, Sophie, Sophos Anti-Virus
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I trust this is the right list...

The following patch enables reboot through BIOS on the Dell Optiplex 745 
Small Form Factor base, on which reboot hangs. The larger form factor 
does not require this, hence the match on DMI_BOARD_NAME.

--- arch/i386/kernel/reboot.c.orig      2007-06-01 12:22:53.000000000 +0100
+++ arch/i386/kernel/reboot.c   2007-06-04 16:53:36.000000000 +0100
@@ -104,6 +104,15 @@
                        DMI_MATCH(DMI_PRODUCT_NAME, "PowerEdge 300/"),
                },
        },
+       {       /* Handle problems with rebooting on Dell Optiplex 745's 
SFF*/
+               .callback = set_bios_reboot,
+               .ident = "Dell OptiPlex 745",
+               .matches = {
+                       DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+                       DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 745"),
+                       DMI_MATCH(DMI_BOARD_NAME, "0WF810"),
+               },
+       },
        {       /* Handle problems with rebooting on Dell 2400's */
                .callback = set_bios_reboot,
                .ident = "Dell PowerEdge 2400",

