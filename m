Return-Path: <linux-kernel-owner+w=401wt.eu-S1760844AbXIZP45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760844AbXIZP45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbXIZP4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:56:50 -0400
Received: from sacred.ru ([62.205.161.221]:35552 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbXIZP4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:56:49 -0400
Message-ID: <46FA7E20.80207@openvz.org>
Date: Wed, 26 Sep 2007 19:43:28 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Serge Hallyn <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] The config option itself
References: <46FA7D4D.8040808@openvz.org>
In-Reply-To: <46FA7D4D.8040808@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 26 Sep 2007 19:45:50 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The option is called NAMESPACES. It can be selectable only
if EMBEDDED is chosen (this was Eric's requisition). When
the EMBEDDED is off namespaces will be on automatically.

One more option (NAMESPACES_EXPERIMENTAL) was added by 
Serge's request to move there all the namespaces that are 
not finished yet. Currently only the user and the network
namespaces are such.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/init/Kconfig b/init/Kconfig
index 684ccfb..05a71d7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -369,6 +360,23 @@ config RELAY
 
 	  If unsure, say N.
 
+config NAMESPACES
+	bool "The namespaces support" if EMBEDDED
+	default !EMBEDDED
+	help
+	  Provides the way to make tasks work with different objects using
+	  the same id. For example same IPC id may refer to different objects
+	  or same user id or pid may refer to different tasks when used in
+	  different namespaces.
+
+config NAMESPACES_EXPERIMENTAL
+	bool "Add the experimantal namespaces support" if EMBEDDED
+	depends on NAMESPACES && EXPERIMENTAL
+	default !EMBEDDED
+	help
+	  Also include the support for the namespaces that are not fnished
+	  or well developed yet
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
