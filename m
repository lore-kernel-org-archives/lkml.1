Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbXJaKV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbXJaKV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 06:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756035AbXJaKVt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 06:21:49 -0400
Received: from sacred.ru ([62.205.161.221]:53330 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374AbXJaKVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 06:21:48 -0400
Message-ID: <4728615D.5070700@openvz.org>
Date: Wed, 31 Oct 2007 14:05:01 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] The config option itself
References: <47285FEE.9030001@openvz.org>
In-Reply-To: <47285FEE.9030001@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 31 Oct 2007 13:02:52 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The option is called NAMESPACES. It can be selectable only
if EMBEDDED is chosen (this was Eric's requisition). When
the EMBEDDED is off namespaces will be on automatically.
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/init/Kconfig b/init/Kconfig
index c3de3ed..fc76773 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -400,6 +400,15 @@ config RELAY
 
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
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
-- 
1.5.3.4

