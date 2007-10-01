Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbXJAPgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbXJAPgq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 11:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751637AbXJAPgj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 11:36:39 -0400
Received: from sacred.ru ([62.205.161.221]:44466 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbXJAPgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 11:36:39 -0400
Message-ID: <47011347.70906@openvz.org>
Date: Mon, 01 Oct 2007 19:33:27 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 1/5] The config option itself
References: <470112C7.8000803@openvz.org>
In-Reply-To: <470112C7.8000803@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 01 Oct 2007 19:35:49 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The option is called NAMESPACES. It can be selectable only
if EMBEDDED is chosen (this was Eric's requisition). When
the EMBEDDED is off namespaces will be on automatically.

One more option (NAMESPACES_EXPERIMENTAL) was added by 
Serge's request to move there all the namespaces that are 
not finished yet. Currently only the user and the network
namespaces are such. This option is selectable all the
time NAMESPACES are "y" regardless of EMBEDDED one.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Cedric Le Goater <clg@fr.ibm.com>

---

diff --git a/init/Kconfig b/init/Kconfig
index 6bb603a..67b1e41 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -390,6 +381,23 @@ config RELAY
 
 	  If unsure, say N.
 
+config NAMESPACES
+	bool "Namespaces support" if EMBEDDED
+	default !EMBEDDED
+	help
+	  Provides the way to make tasks work with different objects using
+	  the same id. For example same IPC id may refer to different objects
+	  or same user id or pid may refer to different tasks when used in
+	  different namespaces.
+
+config NAMESPACES_EXPERIMENTAL
+	bool "Add experimantal namespaces support"
+	depends on NAMESPACES && EXPERIMENTAL
+	default n
+	help
+	  Also include the support for the namespaces that are not fnished
+	  or well developed yet
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV

