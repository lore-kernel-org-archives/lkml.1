Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbXHBNtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbXHBNtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 09:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755227AbXHBNtA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 09:49:00 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58152 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752565AbXHBNs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 09:48:59 -0400
Date: Thu, 2 Aug 2007 15:48:38 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Gabriel C <nix.or.die@googlemail.com>, davej@codemonkey.org.uk
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, cpufreq@lists.linux.org.uk
Subject: [-mm patch] CPU_FREQ_GOV_PERFORMANCE must always be y
Message-ID: <20070802134838.GV3972@stusta.de>
References: <a44ae5cd0708011631k7f476af2jcd01d2875f4b4b17@mail.gmail.com> <20070801165704.a26961b7.akpm@linux-foundation.org> <46B12516.4090006@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46B12516.4090006@googlemail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 02:28:06AM +0200, Gabriel C wrote:
> Andrew Morton wrote:
> > On Wed, 1 Aug 2007 16:31:46 -0700
> > "Miles Lane" <miles.lane@gmail.com> wrote:
> > 
> >>   LD      .tmp_vmlinux1
> >> drivers/built-in.o: In function `__cpufreq_governor':
> >> cpufreq.c:(.text+0xaf178): undefined reference to `cpufreq_gov_performance'
> >> cpufreq.c:(.text+0xaf18a): undefined reference to `cpufreq_gov_performance'
> >> make: *** [.tmp_vmlinux1] Error 1
> > 
> > One for Thomas, I expect.
> 
> Is this patch :
> 
> cpufreq-allow-ondemand-and-conservative-cpufreq-governors-to-be-used-as-default.patch
> 
> Reverting it here fixes the error.

Possible fix below.

> Gabriel

cu
Adrian


<--  snip  -->


With the 'performance' governor always as a fallback it must always be 
compiled into the kernel.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

 drivers/cpufreq/Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

d7418849ec236338ec5ac74c0d66e5aaae466ffe 
diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 721f86f..91f7cfd 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -84,7 +84,6 @@ config CPU_FREQ_DEFAULT_GOV_USERSPACE
 config CPU_FREQ_DEFAULT_GOV_ONDEMAND
 	bool "ondemand"
 	select CPU_FREQ_GOV_ONDEMAND
-	select CPU_FREQ_GOV_PERFORMANCE
 	help
 	  Use the CPUFreq governor 'ondemand' as default. This allows
 	  you to get a full dynamic frequency capable system by simply
@@ -96,7 +95,6 @@ config CPU_FREQ_DEFAULT_GOV_ONDEMAND
 config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
 	bool "conservative"
 	select CPU_FREQ_GOV_CONSERVATIVE
-	select CPU_FREQ_GOV_PERFORMANCE
 	help
 	  Use the CPUFreq governor 'conservative' as default. This allows
 	  you to get a full dynamic frequency capable system by simply
@@ -107,7 +105,8 @@ config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
 endchoice
 
 config CPU_FREQ_GOV_PERFORMANCE
-	tristate "'performance' governor"
+	tristate
+	default y
 	help
 	  This cpufreq governor sets the frequency statically to the
 	  highest available CPU frequency.

