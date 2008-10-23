Return-Path: <linux-kernel-owner+w=401wt.eu-S1755209AbYJWOWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbYJWOWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 10:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYJWOVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 10:21:55 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36743 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752198AbYJWOVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 10:21:54 -0400
Message-ID: <490088BD.1060606@sgi.com>
Date: Thu, 23 Oct 2008 07:22:53 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct
 cpumask
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu>
In-Reply-To: <20081023125529.GA18327@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> ok, the new cpumask code blew up in -tip testing, with various sorts of 
> slab corruptions during scheduler init:
> 
...
Curious thing happens here.  I created the tree as you suggested (branch tip/cpus4096-v2)
and copied in your .config file.  Running it through "silentoldconfig" (choosing only
the defaults), I get the following changes.  This makes me suspect that I'm not testing
the same thing as you are...?  Perhaps my git setup was not correct?

	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
+	git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
+	branch tip/cpus4096-v2

-CONFIG_BOOTPARAM_SUPPORT_NOT_WANTED=y
-CONFIG_BROKEN_BOOT_ALLOWED4=y
-CONFIG_BROKEN_BOOT_ALLOWED3=y
-# CONFIG_BROKEN_BOOT_ALLOWED2 is not set
-CONFIG_BROKEN_BOOT_EUROPE=y
-CONFIG_BROKEN_BOOT_TITAN=y
-CONFIG_LOCALVERSION=""
+CONFIG_LOCALVERSION="-ingo-config-test-1023-1"
-# CONFIG_SMP_SUPPORT is not set
+CONFIG_SMP=y
-# CONFIG_UP_WANTED_1 is not set
-CONFIG_SMP=y
-# CONFIG_X86_PTRACE_BTS is not set
-CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
-# CONFIG_DIRECT_GBPAGES is not set
-CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
-CONFIG_CC_STACKPROTECTOR_ALL=y
-CONFIG_CC_STACKPROTECTOR=y
+# CONFIG_CMDLINE_OVERRIDE is not set
+# CONFIG_NET_9P is not set
+# CONFIG_MTD is not set
+# CONFIG_IDE is not set
+# CONFIG_SCSI_SAS_LIBSAS is not set
+# CONFIG_SCSI_AIC94XX is not set
+# CONFIG_SCSI_MVSAS is not set
+# CONFIG_SCSI_DEBUG is not set
+# CONFIG_I2O_CONFIG is not set
-CONFIG_VORTEX=y
+# CONFIG_MISDN is not set
+# CONFIG_PHONE_IXJ is not set
+# CONFIG_I2C_NFORCE2_S4985 is not set
+# CONFIG_EUROTECH_WDT is not set
+# CONFIG_MFD_WM8400 is not set
+# CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_VIDEO_CX88 is not set
+# CONFIG_FB_CIRRUS is not set
+# CONFIG_FB_VGA16 is not set
+# CONFIG_FB_RADEON is not set
+# CONFIG_FB_VIRTUAL is not set
+# CONFIG_FRAMEBUFFER_CONSOLE is not set
+# CONFIG_USB_GADGET is not set
+# CONFIG_STAGING is not set
+# CONFIG_ECRYPT_FS is not set
+# CONFIG_ROOT_NFS is not set
-CONFIG_ALLOW_WARNINGS=y
+# CONFIG_DEBUG_KOBJECT is not set
+# CONFIG_DEBUG_INFO is not set
-CONFIG_DEBUG_NOTIFIERS=y
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
-CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_HAVE_FTRACE=y
-
-#
-# Tracers
-#
-CONFIG_FUNCTION_TRACER=y
+CONFIG_FTRACE=y
+# CONFIG_KGDB_TESTS_ON_BOOT is not set
+# CONFIG_DIRECT_GBPAGES is not set
+# CONFIG_SECURITY_ROOTPLUG is not set
+# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
+# CONFIG_SECURITY_SMACK is not set
-CONFIG_FORCE_SUCCESSFUL_BUILD=y
-CONFIG_FORCE_MINIMAL_CONFIG=y
-CONFIG_FORCE_MINIMAL_CONFIG_64=y
-CONFIG_FORCE_MINIMAL_CONFIG_PHYS=y


> 
> i suspect it's due to:
> 
> 01b8bd9: sched: cpumask: get rid of boutique sched.c allocations, use cpumask_va
> 
> note, CONFIG_MAXSMP is set in the .config, so this is with the dynamic 
> cpumask_t.
> 
> 	Ingo
> 

