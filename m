Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYL0OKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYL0OKc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 09:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753870AbYL0OKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 09:10:23 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:45200 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753770AbYL0OKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 09:10:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=vxSbla+6M1PE5jXF6F8o+473dnQdgGKVSzoCtkj6vdPBlTa/gvXFTPwamgVz8on1ly
         6xyN0mmeQBb8IIp3OT8I+l7i3+85HKjE2QZ4nqedy4z2IAhjTw38SbtbV0pVIrU9Yf9f
         h0iz+wb+Hg5sHEhjmzHwzH9xc/JppTCKBFQ1E=
Date: Sat, 27 Dec 2008 17:10:18 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86: mach-default setup.c cleanup
Message-ID: <20081227141018.GA14658@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

Break THAT long lines into shorter form.
Use pr_ macros instead of plain printk.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Nothing serious except loglevel of messages being
printed is changed (was KERN_WARNING as by default).
Yeah, it's not-fixing-anything-patch, so feel free
to just drop it if it break a patch queue :-)

 arch/x86/mach-default/setup.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/mach-default/setup.c
===================================================================
--- linux-2.6.git.orig/arch/x86/mach-default/setup.c
+++ linux-2.6.git/arch/x86/mach-default/setup.c
@@ -133,29 +133,28 @@ void __init time_init_hook(void)
  **/
 void mca_nmi_hook(void)
 {
-	/* If I recall correctly, there's a whole bunch of other things that
+	/*
+	 * If I recall correctly, there's a whole bunch of other things that
 	 * we can do to check for NMI problems, but that's all I know about
 	 * at the moment.
 	 */
-
-	printk("NMI generated from unknown source!\n");
+	pr_warning("NMI generated from unknown source!\n");
 }
 #endif
 
 static __init int no_ipi_broadcast(char *str)
 {
 	get_option(&str, &no_broadcast);
-	printk ("Using %s mode\n", no_broadcast ? "No IPI Broadcast" :
-											"IPI Broadcast");
+	pr_info("Using %s mode\n",
+		no_broadcast ? "No IPI Broadcast" : "IPI Broadcast");
 	return 1;
 }
-
 __setup("no_ipi_broadcast=", no_ipi_broadcast);
 
 static int __init print_ipi_mode(void)
 {
-	printk ("Using IPI %s mode\n", no_broadcast ? "No-Shortcut" :
-											"Shortcut");
+	pr_info("Using IPI %s mode\n",
+		no_broadcast ? "No-Shortcut" : "Shortcut");
 	return 0;
 }
 
