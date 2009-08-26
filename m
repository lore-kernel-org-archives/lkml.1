Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZHZRdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZHZRdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZHZRdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:33:19 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34471 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306AbZHZRdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:33:17 -0400
Date: Wed, 26 Aug 2009 10:33:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, mathieu.desnoyers@polymtl.ca,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, laijs@cn.fujitsu.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/rcu] rcu: Remove lockdep annotations from RCU's
	_notrace() API members
Message-ID: <20090826173318.GC6752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090826015337.GA18904@linux.vnet.ibm.com> <tip-06e799764eb7c2e4640888d438c3524d756613e1@git.kernel.org> <20090826084938.GA5023@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826084938.GA5023@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 10:49:38AM +0200, Ingo Molnar wrote:
> 
> * tip-bot for Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Commit-ID:  06e799764eb7c2e4640888d438c3524d756613e1
> > Gitweb:     http://git.kernel.org/tip/06e799764eb7c2e4640888d438c3524d756613e1
> > Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > AuthorDate: Tue, 25 Aug 2009 18:53:37 -0700
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 26 Aug 2009 09:45:41 +0200
> > 
> > rcu: Remove lockdep annotations from RCU's _notrace() API members
> 
> I'm afraid this does not solve the problem either - the attached 
> config crashes too. Does it boot for you? It should boot fine on 
> most 64-bit x86 systems.

OK, got my hands on a 64-bit x86 system, building.  When I did "make
oldconfig" on the attached config file, I ended up with the following
diffs.  If there is some other command I should use, please let me know.
Otherwise, will let you know how this goes.

						Thanx, Paul

--- .config	2009-08-26 03:23:18.000000000 -0700
+++ ../config	2009-08-26 03:10:56.000000000 -0700
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.31-rc6
-# Wed Aug 26 03:23:18 2009
+# Linux kernel version: 2.6.31-rc7
+# Wed Aug 26 10:45:38 2009
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
@@ -161,11 +161,11 @@
 CONFIG_HAVE_ARCH_TRACEHOOK=y
 CONFIG_HAVE_DMA_ATTRS=y
 CONFIG_HAVE_DMA_API_DEBUG=y
+CONFIG_HAVE_HW_BREAKPOINT=y
 
 #
 # GCOV-based kernel profiling
 #
-# CONFIG_GCOV_KERNEL is not set
 CONFIG_SLOW_WORK=y
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
@@ -247,6 +247,7 @@
 # CONFIG_MVIAC7 is not set
 # CONFIG_MPSC is not set
 # CONFIG_MCORE2 is not set
+# CONFIG_MATOM is not set
 CONFIG_GENERIC_CPU=y
 CONFIG_X86_CPU=y
 CONFIG_X86_L1_CACHE_BYTES=64
@@ -303,6 +304,7 @@
 CONFIG_ARCH_SPARSEMEM_DEFAULT=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
 CONFIG_ARCH_SELECT_MEMORY_MODEL=y
+CONFIG_ILLEGAL_POINTER_VALUE=0xdead000000000000
 CONFIG_SELECT_MEMORY_MODEL=y
 # CONFIG_FLATMEM_MANUAL is not set
 # CONFIG_DISCONTIGMEM_MANUAL is not set
@@ -734,7 +736,6 @@
 CONFIG_WIMAX=m
 CONFIG_WIMAX_DEBUG_LEVEL=8
 # CONFIG_RFKILL is not set
-# CONFIG_NET_9P is not set
 
 #
 # Device Drivers
@@ -856,7 +857,6 @@
 # CONFIG_SCSI_SRP_ATTRS is not set
 CONFIG_SCSI_LOWLEVEL=y
 # CONFIG_ISCSI_TCP is not set
-# CONFIG_SCSI_BNX2_ISCSI is not set
 CONFIG_BLK_DEV_3W_XXXX_RAID=m
 CONFIG_SCSI_3W_9XXX=m
 # CONFIG_SCSI_ACARD is not set
@@ -911,7 +911,6 @@
 # CONFIG_SCSI_LPFC is not set
 CONFIG_SCSI_DC395x=y
 CONFIG_SCSI_DC390T=m
-# CONFIG_SCSI_DEBUG is not set
 CONFIG_SCSI_SRP=m
 CONFIG_SCSI_DH=y
 CONFIG_SCSI_DH_RDAC=m
@@ -1008,7 +1007,6 @@
 CONFIG_I2O_LCT_NOTIFY_ON_CHANGES=y
 CONFIG_I2O_EXT_ADAPTEC=y
 # CONFIG_I2O_EXT_ADAPTEC_DMA64 is not set
-# CONFIG_I2O_CONFIG is not set
 CONFIG_I2O_BUS=y
 # CONFIG_I2O_BLOCK is not set
 # CONFIG_I2O_SCSI is not set
@@ -1141,7 +1139,6 @@
 CONFIG_VIA_VELOCITY=y
 CONFIG_TIGON3=y
 CONFIG_BNX2=y
-# CONFIG_CNIC is not set
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 CONFIG_ATL1E=m
@@ -1213,7 +1210,6 @@
 # CONFIG_B43LEGACY is not set
 CONFIG_ZD1211RW=m
 CONFIG_ZD1211RW_DEBUG=y
-# CONFIG_RT2X00 is not set
 CONFIG_HERMES=y
 # CONFIG_HERMES_CACHE_FW_ON_INIT is not set
 # CONFIG_PLX_HERMES is not set
@@ -1227,7 +1223,6 @@
 #
 # WiMAX Wireless Broadband devices
 #
-# CONFIG_WIMAX_I2400M_USB is not set
 # CONFIG_WIMAX_I2400M_SDIO is not set
 
 #
@@ -1292,11 +1287,9 @@
 CONFIG_NET_POLL_CONTROLLER=y
 CONFIG_VIRTIO_NET=m
 CONFIG_ISDN=y
-# CONFIG_MISDN is not set
 # CONFIG_ISDN_I4L is not set
 # CONFIG_ISDN_CAPI is not set
 CONFIG_PHONE=m
-# CONFIG_PHONE_IXJ is not set
 
 #
 # Input device support
@@ -1499,13 +1492,11 @@
 # CONFIG_I2C_ALI1563 is not set
 CONFIG_I2C_ALI15X3=y
 CONFIG_I2C_AMD756=y
-# CONFIG_I2C_AMD756_S4882 is not set
 CONFIG_I2C_AMD8111=y
 CONFIG_I2C_I801=m
 # CONFIG_I2C_ISCH is not set
 # CONFIG_I2C_PIIX4 is not set
 CONFIG_I2C_NFORCE2=m
-# CONFIG_I2C_NFORCE2_S4985 is not set
 CONFIG_I2C_SIS5595=m
 CONFIG_I2C_SIS630=y
 CONFIG_I2C_SIS96X=m
@@ -1674,7 +1665,6 @@
 # CONFIG_MFD_TMIO is not set
 # CONFIG_PMIC_DA903X is not set
 CONFIG_MFD_WM8400=y
-# CONFIG_MFD_WM8350_I2C is not set
 CONFIG_MFD_PCF50633=m
 # CONFIG_PCF50633_ADC is not set
 CONFIG_PCF50633_GPIO=m
@@ -1954,7 +1944,6 @@
 CONFIG_USB_U132_HCD=m
 # CONFIG_USB_SL811_HCD is not set
 # CONFIG_USB_R8A66597_HCD is not set
-# CONFIG_USB_WHCI_HCD is not set
 CONFIG_USB_HWA_HCD=m
 
 #
@@ -2058,7 +2047,6 @@
 CONFIG_USB_TEST=y
 CONFIG_USB_ISIGHTFW=y
 CONFIG_USB_VST=m
-# CONFIG_USB_GADGET is not set
 
 #
 # OTG and related infrastructure
@@ -2398,6 +2386,7 @@
 #
 CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 CONFIG_PRINTK_TIME=y
+CONFIG_ALLOW_WARNINGS=y
 CONFIG_ENABLE_WARN_DEPRECATED=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=2048
@@ -2405,6 +2394,7 @@
 CONFIG_UNUSED_SYMBOLS=y
 CONFIG_DEBUG_FS=y
 CONFIG_HEADERS_CHECK=y
+CONFIG_DEBUG_SECTION_MISMATCH=y
 CONFIG_DEBUG_KERNEL=y
 CONFIG_DEBUG_SHIRQ=y
 # CONFIG_DETECT_SOFTLOCKUP is not set
@@ -2468,7 +2458,7 @@
 CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
 CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
-CONFIG_HAVE_FTRACE_SYSCALLS=y
+CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
 CONFIG_TRACER_MAX_TRACE=y
 CONFIG_RING_BUFFER=y
 CONFIG_FTRACE_NMI_ENTER=y
@@ -2489,6 +2479,8 @@
 # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
 # CONFIG_PROFILE_ALL_BRANCHES is not set
 CONFIG_POWER_TRACER=y
+CONFIG_KSYM_TRACER=y
+# CONFIG_PROFILE_KSYM_TRACER is not set
 CONFIG_STACK_TRACER=y
 CONFIG_KMEMTRACE=y
 CONFIG_WORKQUEUE_TRACER=y
