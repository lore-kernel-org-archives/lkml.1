Return-Path: <linux-kernel-owner+w=401wt.eu-S1761347AbXEUOJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761347AbXEUOJA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 10:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756305AbXEUOIw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 10:08:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755902AbXEUOIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 10:08:51 -0400
Date: Mon, 21 May 2007 10:08:47 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@redhat.com,
       randy.dunlap@oracle.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070521140847.11958.47504.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: Fix overloaded use of apic= on bootline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, I've submitted this a couple of times and it's had a review by Randy.
Any chance we can get this in?

Thanks,

P.

The use of "apic=" on the boot line is overloaded.  It is used once to
override the type of genapic, and then later on it is used to determine a debug
level.  Because of this a bogus error message is sent to the console when using
the debug option:

	Unknown genapic `apic=debug' specified.

	This patch changes the genapic situation to use "genapic=".

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 09220a1..f156b59 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -636,6 +636,9 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	gamma=		[HW,DRM]
 
+	genapic=	[APIC,i386] Select a specific genapic type to be used.
+			Format: <name>
+
 	gdth=		[HW,SCSI]
 			See header of drivers/scsi/gdth.c.
 
diff --git a/arch/i386/mach-generic/probe.c b/arch/i386/mach-generic/probe.c
index 74f3da6..ce78b15 100644
--- a/arch/i386/mach-generic/probe.c
+++ b/arch/i386/mach-generic/probe.c
@@ -49,7 +49,7 @@ static int __init parse_apic(char *arg)
 	/* Parsed again by __setup for debug/verbose */
 	return 0;
 }
-early_param("apic", parse_apic);
+early_param("genapic", parse_apic);
 
 void __init generic_bigsmp_probe(void)
 {
