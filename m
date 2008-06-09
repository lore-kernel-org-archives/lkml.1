Return-Path: <linux-kernel-owner+w=401wt.eu-S1756750AbYFIRgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750AbYFIRgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbYFIRgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:36:13 -0400
Received: from relay1.sgi.com ([192.48.171.29]:34634 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbYFIRgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:36:12 -0400
Message-ID: <484D6A05.7010508@sgi.com>
Date: Mon, 09 Jun 2008 10:36:05 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] x86: Replace xxx_pda() operations with	x86_xx_percpu().
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <20080604003019.711845000@polaris-admin.engr.sgi.com> <20080609130302.GA20943@elte.hu>
In-Reply-To: <20080609130302.GA20943@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Mike Travis <travis@sgi.com> wrote:
> 
>>   * It is now possible to use percpu operations for pda access
>>     since the pda is in the percpu area. Drop the pda operations.
> 
> FYI, this one didnt build with the attached config.
> 
> 	Ingo
> 

Hi Ingo,

Can you send me the output from the build?  It builds fine on my
machine (a few warnings).  The silentoldconfig made these changes
to the .config file.  (I did a git-remote update and reapplied my
changes before building.)

Thanks,
Mike

--- ../configs/ingo-test-9      2008-06-09 10:25:32.148026511 -0700
+++ ../build/ingo-test-9/.config        2008-06-09 10:30:15.273171501 -0700
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.26-rc5
-# Mon Jun  9 14:59:39 2008
+# Linux kernel version: 2.6.26-rc4
+# Mon Jun  9 10:30:10 2008
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -36,6 +36,7 @@
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
+CONFIG_HAVE_ZERO_BASED_PER_CPU=y
 CONFIG_ARCH_HIBERNATION_POSSIBLE=y
 CONFIG_ARCH_SUSPEND_POSSIBLE=y
 CONFIG_ZONE_DMA32=y
@@ -52,23 +53,16 @@
 CONFIG_X86_BIOS_REBOOT=y
 CONFIG_X86_TRAMPOLINE=y
 # CONFIG_KTIME_SCALAR is not set
-# CONFIG_BOOTPARAM_SUPPORT_WANTED is not set
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"

 #
 # General setup
 #
 CONFIG_EXPERIMENTAL=y
-CONFIG_BROKEN_BOOT_ALLOWED3=y
-CONFIG_BROKEN_BOOT_ALLOWED2=y
-CONFIG_BROKEN_BOOT_ALLOWED=y
-CONFIG_BROKEN_BOOT=y
-CONFIG_BROKEN_BOOT_EUROPE=y
-CONFIG_BROKEN_BOOT_TITAN=y
 CONFIG_LOCK_KERNEL=y
 CONFIG_INIT_ENV_ARG_LIMIT=32
-CONFIG_LOCALVERSION=""
-# CONFIG_LOCALVERSION_AUTO is not set
+CONFIG_LOCALVERSION="-ingo-test-9"
+CONFIG_LOCALVERSION_AUTO=y
 # CONFIG_SWAP is not set
 # CONFIG_SYSVIPC is not set
 # CONFIG_POSIX_MQUEUE is not set
@@ -152,15 +146,16 @@
 # CONFIG_NO_HZ is not set
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
-CONFIG_SMP_SUPPORT=y
-CONFIG_UP_WANTED_1=y
-# CONFIG_UP_WANTED_2 is not set
 CONFIG_SMP=y
 CONFIG_X86_PC=y
 # CONFIG_X86_ELAN is not set
 # CONFIG_X86_VOYAGER is not set
+# CONFIG_X86_NUMAQ is not set
+# CONFIG_X86_SUMMIT is not set
+# CONFIG_X86_BIGSMP is not set
 # CONFIG_X86_VISWS is not set
 # CONFIG_X86_GENERICARCH is not set
+# CONFIG_X86_ES7000 is not set
 # CONFIG_X86_RDC321X is not set
 # CONFIG_X86_VSMP is not set
 CONFIG_PARAVIRT_GUEST=y
@@ -616,6 +611,7 @@
 CONFIG_SCSI_FC_ATTRS=y
 CONFIG_SCSI_FC_TGT_ATTRS=y
 CONFIG_SCSI_ISCSI_ATTRS=y
+# CONFIG_SCSI_SAS_LIBSAS is not set
 CONFIG_SCSI_SRP_ATTRS=y
 CONFIG_SCSI_SRP_TGT_ATTRS=y
 CONFIG_SCSI_LOWLEVEL=y
@@ -626,6 +622,7 @@
 # CONFIG_SCSI_AIC7XXX is not set
 # CONFIG_SCSI_AIC7XXX_OLD is not set
 # CONFIG_SCSI_AIC79XX is not set
+# CONFIG_SCSI_AIC94XX is not set
 CONFIG_SCSI_DPT_I2O=y
 CONFIG_SCSI_ADVANSYS=y
 CONFIG_SCSI_ARCMSR=y
@@ -642,6 +639,7 @@
 CONFIG_SCSI_IPS=y
 # CONFIG_SCSI_INITIO is not set
 CONFIG_SCSI_INIA100=y
+# CONFIG_SCSI_MVSAS is not set
 CONFIG_SCSI_STEX=y
 CONFIG_SCSI_SYM53C8XX_2=y
 CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
@@ -1302,6 +1300,7 @@
 CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
 CONFIG_STACKTRACE=y
 CONFIG_DEBUG_KOBJECT=y
+# CONFIG_DEBUG_INFO is not set
 CONFIG_DEBUG_VM=y
 # CONFIG_DEBUG_WRITECOUNT is not set
 CONFIG_DEBUG_LIST=y
@@ -1460,4 +1459,3 @@
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
-CONFIG_FORCE_SUCCESSFUL_BUILD=y
