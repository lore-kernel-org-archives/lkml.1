Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZEHP1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZEHP1W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 11:27:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754854AbZEHP1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 11:27:09 -0400
Received: from science.horizon.com ([192.35.100.1]:19687 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753705AbZEHP1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 11:27:08 -0400
Date: 8 May 2009 11:27:06 -0400
Message-ID: <20090508152706.17300.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: johnstul@us.ibm.com, linux@horizon.com
Subject: Re: [RFC][PATCH] tsc_khz= boot option to avoid TSC calibration variance
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       ulrich.windl@rz.uni-regensburg.de, williams@redhat.com,
       zippel@linux-m68k.org
In-Reply-To: <20090508121913.9039.qmail@science.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd suggest the following:

I should add the documentation patch that goes with it:
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 90b3924..6747881 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2391,10 +2391,20 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	tsc=		Disable clocksource-must-verify flag for TSC.
 			Format: <string>
-			[x86] reliable: mark tsc clocksource as reliable, this
-			disables clocksource verification at runtime.
-			Used to enable high-resolution timer mode on older
-			hardware, and in virtualized environment.
+			[x86] if value is "reliable", mark tsc clocksource
+			as reliable.  This disables clocksource verification
+			at runtime.  Used to enable high-resolution timer mode
+			on older hardware, and in virtualized environment.
+
+	tsc_khz=	[x86] Set the TSC freq value.
+			Format: <khz>
+			Used to avoid TSC calibration error.  The TSC frequency
+			is re-measured each boot, and changes by a few parts
+			per hundred thousand each time.  This is noticeable to
+			time synchronization applications like NTP.
+			This option makes it consistent across boots.
+			If the specified value differs from the measured one
+			by more than 0.1%, it is ignored.
 
 	turbografx.map[2|3]=	[HW,JOY]
 			TurboGraFX parallel port interface
