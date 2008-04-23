Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbYDWWh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbYDWWh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 18:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751203AbYDWWhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 18:37:18 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:43977 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132AbYDWWhQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 18:37:16 -0400
Date: Thu, 24 Apr 2008 00:37:12 +0200
Message-Id: <251459002@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: agruen@suse.de
Subject: make cloneconfig ?
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1/JAVMIORv43AVjS0Hm1tO6V5UDIFvj5+lnptJgSH50wLao0
 NJbdJrhbehxplSJF9yeMDj609c4KCMMAv3qxIkKaDcGGV6AA/k=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

any reason why "make cloneconfig" never made it into mainline?

many people are quite used to it and every time i build vanilla kernel i step into that trap  "oh - that`s a suse`ism"

make cloneconfig exists since /proc/config.gz - but while that one went into mainline, cloneconfig never did.

anyone know the reason for that ?

i wished, distros kernels were more similar to vanilla kernels - so what about making them more similar ?




http://marc.info/?l=linux-kernel&m=93250171620331&w=2
List:       linux-kernel
Subject:    [patch] config.gz and make cloneconfig
From:       Oliver Xymoron <oxymoron () waste ! org>
Date:       1999-07-20 20:03:45
[Download message RAW]

Please consider the following patch against 2.3.10 which adds a config
option to store the kernel configuration in the kernel image and make it
available as a file in /proc. It also adds 'make cloneconfig' which will
duplicate your running kernel configuration.

Also worth noting is scripts/bin2c, which is meant to replace the poorly
named and poorly located bin2hex programs that are in various places.

diff -urN linux/Documentation/Configure.help linux-cfg/Documentation/Configure.help
--- linux/Documentation/Configure.help	Mon Jul  5 22:37:25 1999
+++ linux-cfg/Documentation/Configure.help	Tue Jul 20 13:35:21 1999
@@ -7464,6 +7464,14 @@
   This option will enlarge your kernel by about 18 KB. Several
   programs depend on this, so everyone should say Y here.
 
+/proc/config.gz support
+CONFIG_PROC_CONFIG
+  Say Y here if you want a copy of your current kernel configuration
+  saved in the kernel that you build. This is extremely useful if you
+  ever build more than one kernel. The cost is around 1K-4K of running
+  memory. Only say no if you really can't spare this. You can sneeze
+  and lose more on memory than this.
+
 NFS filesystem support
 CONFIG_NFS_FS
   If you are connected to some other (usually local) Unix computer
diff -urN linux/Documentation/patches/cfg linux-cfg/Documentation/patches/cfg
--- linux/Documentation/patches/cfg	Wed Dec 31 18:00:00 1969
+++ linux-cfg/Documentation/patches/cfg	Tue Jul 20 14:26:27 1999
@@ -0,0 +1,10 @@
+This patch adds /proc/config.gz and make cloneconfig
+
+Oliver Xymoron <oxymoron@waste.org> 
+
+Jan 15 1999 - original 2.0.0-pre version
+Jul 20 1999 - updated to 2.3.10
+
+Derived from a patch by Nicholas Leon <nicholas@binary9.net> with
+suggestions from Michael Chastain <mec@shout.net> and Peter T. Breuer
+<ptb@it.uc3m.es>
diff -urN linux/Makefile linux-cfg/Makefile
--- linux/Makefile	Thu Jul  1 12:54:31 1999
+++ linux-cfg/Makefile	Tue Jul 20 14:22:52 1999
@@ -243,6 +243,15 @@
 config: symlinks
 	$(CONFIG_SHELL) scripts/Configure arch/$(ARCH)/config.in
 
+cloneconfig: symlinks
+	@if [ -f "/proc/config.gz" ]; then \
+		mv -f .config .config.bak; \
+	    	gzip -d < /proc/config.gz > .config; \
+		$(CONFIG_SHELL) scripts/Configure -d arch/$(ARCH)/config.in; \
+	else \
+		echo "Sorry, your current kernel was built without cloning support."; \
+	fi
+

_______________________________________________________________
Schon gehört? Der neue WEB.DE MultiMessenger kann`s mit allen: 
http://www.produkte.web.de/messenger/?did=3016

