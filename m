Return-Path: <linux-kernel-owner+w=401wt.eu-S1751793AbXBVTkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751793AbXBVTkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:40:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751794AbXBVTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:40:37 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:41723
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbXBVTkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:40:37 -0500
From: Rob Landley <rob@landley.net>
To: linux-kernel@vger.kernel.org
Subject: [patch] Don't assume arguments to init have no period in them.
Date: Thu, 22 Feb 2007 14:40:21 -0500
User-Agent: KMail/1.9.1
Cc: akpm@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221440.22078.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rob Landley <rob@landley.net>

The kernel assumes that nobody will ever legitimately feed in a kernel command 
line option with a period in it, and the kernel is wrong: I'm feeding the 
path to a script as an argument to my init program, the name of the script 
ends in .sh.

I've been using this patch ever since 2.6.13, and I still need it.

--- linux-old/init/main.c	2005-09-09 21:42:58.000000000 -0500
+++ linux-new/init/main.c	2005-10-24 02:07:37.683498720 -0500
@@ -242,15 +242,6 @@
 	if (obsolete_checksetup(param))
 		return 0;
 
-	/*
-	 * Preemptive maintenance for "why didn't my mispelled command
-	 * line work?"
-	 */
-	if (strchr(param, '.') && (!val || strchr(param, '.') < val)) {
-		printk(KERN_ERR "Unknown boot option `%s': ignoring\n", param);
-		return 0;
-	}
-
 	if (panic_later)
 		return 0;

-- 
"Perfection is reached, not when there is no longer anything to add, but
when there is no longer anything to take away." - Antoine de Saint-Exupery
