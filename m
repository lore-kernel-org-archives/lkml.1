Return-Path: <linux-kernel-owner+w=401wt.eu-S1754725AbYHKQbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725AbYHKQbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbYHKQbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:31:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48348 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYHKQbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:31:35 -0400
Date: Mon, 11 Aug 2008 18:31:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH] x86: Remove EXPERIMENTAL restriction from
	CONFIG_HOTPLUG_CPU
Message-ID: <20080811163111.GD4524@elte.hu>
References: <20080811154646.GB8181@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080811154646.GB8181@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dimitri Sivanich <sivanich@sgi.com> wrote:

> This removes the EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU on 
> the x86 architecture.
>
> One question, should we default to 'Y'?

CONFIG_SUSPECT will select it anyway, and when suspend is disabled in 
all likelyhood it's an UP system that does not need any hotplug CPU 
support. So we dont want to enable it by default.

>  config HOTPLUG_CPU
> -	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
> -	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
> +	bool "Support for suspend on SMP and hot-pluggable CPUs"
> +	depends on SMP && HOTPLUG && !X86_VOYAGER
>  	---help---
> -	  Say Y here to experiment with turning CPUs off and on, and to
> -	  enable suspend on SMP systems. CPUs can be controlled through
> +	  Say Y here to allow turning CPUs off and on, and to enable
> +	  suspend on SMP systems. CPUs can be controlled through
>  	  /sys/devices/system/cpu.
>  	  Say N if you want to disable CPU hotplug and don't need to
>  	  suspend.

actually, the original text was incorrect/outdated, as HOTPLUG_CPU was 
already selected outside of EXPERIMENTAL, by PM_SLEEP_SMP.

So for all practical purposes HOTPLUG_CPU was already enabled in the 
Linux distro space by the side-effect of SUSPEND+PM_SLEEP enabling.

Where this change might matter is when CONFIG_PM is disabled 
intentionally on SMP - which is rather rare.

So i've clarified the text as per the commit below - is this fine with 
you?

	Ingo

------------------>
>From 7c13e6a3d15a4ebcc3f40df5f4d19665479f8ca3 Mon Sep 17 00:00:00 2001
From: Dimitri Sivanich <sivanich@sgi.com>
Date: Mon, 11 Aug 2008 10:46:46 -0500
Subject: [PATCH] x86: remove EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU

This removes the EXPERIMENTAL restriction from CONFIG_HOTPLUG_CPU
on the x86 architecture.

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3d0f2b6..7917962 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1371,14 +1371,14 @@ config PHYSICAL_ALIGN
 	  Don't change this unless you know what you are doing.
 
 config HOTPLUG_CPU
-	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
-	depends on SMP && HOTPLUG && EXPERIMENTAL && !X86_VOYAGER
+	bool "Support for hot-pluggable CPUs"
+	depends on SMP && HOTPLUG && !X86_VOYAGER
 	---help---
-	  Say Y here to experiment with turning CPUs off and on, and to
-	  enable suspend on SMP systems. CPUs can be controlled through
-	  /sys/devices/system/cpu.
-	  Say N if you want to disable CPU hotplug and don't need to
-	  suspend.
+	  Say Y here to allow turning CPUs off and on. CPUs can be
+	  controlled through /sys/devices/system/cpu.
+	  ( Note: power management support will enable this option
+	    automatically on SMP systems. )
+	  Say N if you want to disable CPU hotplug.
 
 config COMPAT_VDSO
 	def_bool y
