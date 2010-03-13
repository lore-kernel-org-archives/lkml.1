Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936352Ab0CMBQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:16:43 -0500
Received: from kroah.org ([198.145.64.141]:60985 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935004Ab0CMAUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:49 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:13 2010
Message-Id: <20100313001512.955255807@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:13:07 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 089/123] x86: Add iMac9,1 to pci_reboot_dmi_table
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Justin P. Mattock <justinmattock@gmail.com>

commit 0a832320f1bae6a4169bf683e201378f2437cfc1 upstream.

On the iMac9,1 /sbin/reboot results in a black mangled screen. Adding
this DMI entry gets the machine to reboot cleanly as it should.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
LKML-Reference: <1266362249-3337-1-git-send-email-justinmattock@gmail.com>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/reboot.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -461,6 +461,14 @@ static struct dmi_system_id __initdata p
 			DMI_MATCH(DMI_PRODUCT_NAME, "Macmini3,1"),
 		},
 	},
+	{	/* Handle problems with rebooting on the iMac9,1. */
+		.callback = set_pci_reboot,
+		.ident = "Apple iMac9,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
+		},
+	},
 	{ }
 };
 


