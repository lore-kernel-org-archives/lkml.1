Return-Path: <linux-kernel-owner+w=401wt.eu-S965573AbXEAHxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573AbXEAHxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 03:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965589AbXEAHxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 03:53:08 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58546 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965573AbXEAHxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 03:53:06 -0400
X-Originating-Ip: 74.109.98.66
Date: Tue, 1 May 2007 03:52:53 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH][RFC] Allow the i386 install.sh script to try the generic
 installkernel.
Message-ID: <Pine.LNX.4.64.0705010345460.8080@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow the install script arch/i386/boot/install.sh to fall back to try
the generic "installkernel" command if a CROSS_COMPILE version isn't
available.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

the rationale here:

  after cross-compiling the kernel for x86_64, i (accidentally) left
the CROSS_COMPILE variable on the make line when i tried to install
the kernel:

  # make ARCH=x86_64 CROSS_COMPILE=x86_64- install

as you can see, if you don't have a custom version, the install script
will eventually try to run lilo.  barf.

  is it reasonable, after you check for the custom version, to drop
down and try the generic version (which would have worked just
fine)?

  or is there a cleaner solution?  or is this the correct logic after
all?


diff --git a/arch/i386/boot/install.sh b/arch/i386/boot/install.sh
index 5e44c73..2f7c970 100644
--- a/arch/i386/boot/install.sh
+++ b/arch/i386/boot/install.sh
@@ -38,6 +38,11 @@ verify "$3"
 if [ -x ~/bin/${CROSS_COMPILE}installkernel ]; then exec ~/bin/${CROSS_COMPILE}installkernel "$@"; fi
 if [ -x /sbin/${CROSS_COMPILE}installkernel ]; then exec /sbin/${CROSS_COMPILE}installkernel "$@"; fi

+# OK, then, let's try the generic installkernel scripts.
+
+if [ -x ~/bin/installkernel ]; then exec ~/bin/installkernel "$@"; fi
+if [ -x /sbin/installkernel ]; then exec /sbin/installkernel "$@"; fi
+
 # Default install - same as make zlilo

 if [ -f $4/vmlinuz ]; then

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
