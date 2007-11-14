Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbXKNLaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbXKNLaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:30:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbXKNLab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:30:31 -0500
Received: from sacred.ru ([62.205.161.221]:38032 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbXKNLaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:30:30 -0500
Message-ID: <473ADBD1.6080702@openvz.org>
Date: Wed, 14 Nov 2007 14:28:17 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Cedric Le Goater <clg@fr.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] Add the NAMESPACES config option
References: <473ADB5B.50902@openvz.org>
In-Reply-To: <473ADB5B.50902@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 14 Nov 2007 14:28:17 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The option is selectable if EMBEDDED is chosen only. When
the EMBEDDED is off namespaces will be on.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/init/Kconfig b/init/Kconfig
index 96fba82..4ccc1a0 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -404,6 +404,15 @@ config RELAY
 
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

