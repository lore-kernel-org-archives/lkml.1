Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088Ab0ARBfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0ARBfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 20:35:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281Ab0ARBfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 20:35:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56333 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab0ARBfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 20:35:43 -0500
Message-ID: <4B53B8DD.9000809@zytor.com>
Date: Sun, 17 Jan 2010 17:26:53 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>,
       Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: RFC: deprecate CONFIG_X86_CPU_DEBUG and schedule it for rapid removal
References: <4B4E1633.8010700@pardus.org.tr> <201001162312.34189.rjw@sisk.pl> <4B52D6E2.8000904@pardus.org.tr> <201001171444.14551.rjw@sisk.pl>
In-Reply-To: <201001171444.14551.rjw@sisk.pl>
Content-Type: multipart/mixed;
 boundary="------------080509030200000306060501"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080509030200000306060501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

CONFIG_X86_CPU_DEBUG really seems to be causing more problems than it
ever solved.  This is an RFC for immediately deprecating it, and
schedule it for removal in the 2.6.34 cycle.

If this was a high value feature, it would be different -- but it's not
even close.

Posting this as an RFC just on the offchance someone actually depends on
this.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------080509030200000306060501
Content-Type: text/x-patch;
 name="0001-x86-Mark-CONFIG_X86_CPU_DEBUG-for-rapid-deprecation.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment;
 filename*0="0001-x86-Mark-CONFIG_X86_CPU_DEBUG-for-rapid-deprecation.pat";
 filename*1="ch"

>From 0a7c8171aa6d0aed1eda3902f675eb9a259d4cde Mon Sep 17 00:00:00 2001
From: H. Peter Anvin <hpa@zytor.com>
Date: Sun, 17 Jan 2010 17:05:59 -0800
Subject: [PATCH] x86: Mark CONFIG_X86_CPU_DEBUG for rapid deprecation
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

The CONFIG_X86_CPU_DEBUG feature provides for a filesystem view of
some x86 CPU state in debugfs.  However, all this information is
already available to userspace via dedicated interfaces, and this
could just as easily be done in pure userspace.

It wouldn't be a problem, per se, except that this code has caused
boot failures in real-world scenarios when people have enabled it, see
for example kernel bugzilla 15075.

This is a good example of why this kind of functionality has no
business being in the kernel in the first place.

Mark this code deprecated and schedule it for rapid removal.

Reported-by: Ozan Çağlayan <ozan@pardus.org.tr>
Signed-Off-By: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4B4F1DE7.307@pardus.org.tr>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/feature-removal-schedule.txt |    9 +++++++++
 arch/x86/Kconfig                           |    9 ++++++++-
 2 files changed, 17 insertions(+), 1 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 870d190..49aabf1 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -493,3 +493,12 @@ Why:	These two features use non-standard interfaces. There are the
 Who:	Corentin Chary <corentin.chary@gmail.com>
 
 ----------------------------
+
+What:	Support for x86 debug information via debugfs (CONFIG_X86_CPU_DEBUG)
+When:	2.6.34
+Why:	This feature does not introduce any functionality that is not
+	available through pure userspace.  However, it has been known
+	to causeboot failures in some hardware configurations.
+
+Who:	H. Peter Anvin <hpa@zytor.com>
+
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3b2a5ac..eb1751d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -987,11 +987,18 @@ config X86_CPUID
 	  /dev/cpu/31/cpuid.
 
 config X86_CPU_DEBUG
-	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support"
+	tristate "/sys/kernel/debug/x86/cpu/* - CPU Debug support (DEPRECATED)"
 	---help---
 	  If you select this option, this will provide various x86 CPUs
 	  information through debugfs.
 
+	  This feature is strongly deprecated.  It has been known to cause
+	  problems with some hardware configurations and does not
+	  provide any functionality that is not available through pure
+	  userspace means.  It will be removed in the near future.
+
+	  It is strongly recommended that you select N here.
+
 choice
 	prompt "High Memory Support"
 	default HIGHMEM4G if !X86_NUMAQ
-- 
1.6.2.5


--------------080509030200000306060501--
