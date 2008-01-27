Return-Path: <linux-kernel-owner+w=401wt.eu-S1757848AbYA0RTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848AbYA0RTc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 12:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYA0RTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 12:19:23 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:13424 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbYA0RTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 12:19:22 -0500
Date: Sun, 27 Jan 2008 09:15:51 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       sam@ravnborg.org
Subject: Re: [PATCH 01/52] [microblaze] Kconfig patches v2
Message-Id: <20080127091551.2438910a.randy.dunlap@oracle.com>
In-Reply-To: <479C5FBD.4090702@monstr.eu>
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu>
	<20080126093657.f628b0ef.randy.dunlap@oracle.com>
	<479C5FBD.4090702@monstr.eu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 11:41:01 +0100 Michal Simek wrote:

>  From cd9e680aa7a732c1ff1188a22f2a0950f5d24e3b Mon Sep 17 00:00:00 2001
> Message-Id: 
> <cd9e680aa7a732c1ff1188a22f2a0950f5d24e3b.1201429312.git.monstr@monstr.eu>
> From: Michal Simek <monstr@monstr.eu>
> Date: Sun, 27 Jan 2008 11:21:34 +0100
> Subject: [PATCH 1/1] [microblaze] Kconfig patches v2
> 
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> ---
>  arch/microblaze/Kconfig                       |  140 
> +++++++++++++++++++++++++
>  arch/microblaze/Kconfig.debug                 |   22 ++++
>  arch/microblaze/platform/Kconfig.platform     |   48 +++++++++
>  arch/microblaze/platform/generic/Kconfig.auto |   51 +++++++++
>  4 files changed, 261 insertions(+), 0 deletions(-)
>  create mode 100644 arch/microblaze/Kconfig
>  create mode 100644 arch/microblaze/Kconfig.debug
>  create mode 100644 arch/microblaze/platform/Kconfig.platform
>  create mode 100644 arch/microblaze/platform/generic/Kconfig.auto
> 
> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
> new file mode 100644
> index 0000000..3ef7be5
> --- /dev/null
> +++ b/arch/microblaze/Kconfig
> @@ -0,0 +1,140 @@
> +# For a description of the syntax of this configuration file,
> +# see Documentation/kbuild/kconfig-language.txt.
> +
> +mainmenu "Linux/Microblaze Kernel Configuration"
> +
> +config MICROBLAZE
> +    def_bool y
> +
> +config MMU
> +    def_bool n
> +
> +config SWAP
> +    def_bool n
> +
> +config RWSEM_GENERIC_SPINLOCK
> +    def_bool y
> +
> +config RWSEM_XCHGADD_ALGORITHM
> +    bool
> +
> +config ARCH_HAS_ILOG2_U32
> +    def_bool n
> +
> +config ARCH_HAS_ILOG2_U64
> +    def_bool n
> +
> +config GENERIC_FIND_NEXT_BIT
> +    def_bool y
> +
> +config GENERIC_HWEIGHT
> +    def_bool y
> +
> +config GENERIC_HARDIRQS
> +    def_bool y
> +
> +config GENERIC_IRQ_PROBE
> +    def_bool y
> +
> +config GENERIC_CALIBRATE_DELAY
> +    def_bool y
> +
> +config PCI
> +    def_bool n
> +
> +config UID16
> +    def_bool y
> +
> +config DEFCONFIG_LIST
> +    string
> +    default "arch/$ARCH/defconfig"
> +
> +source "init/Kconfig"
> +
> +source "arch/microblaze/platform/Kconfig.platform"
> +
> +menu "Processor type and features"
> +config PREEMPT
> +    bool "Preemptible Kernel"
> +    help
> +      This option reduces the latency of the kernel when reacting to
> +      real-time or interactive events by allowing a low priority process to
> +      be preempted even if it is in kernel mode executing a system call.
> +      This allows applications to run more reliably even when the system is
> +      under load.
> +
> +      Say Y here if you are building a kernel for a desktop, embedded
> +      or real-time system.  Say N if you are unsure.
> +
> +config PREEMPT_TIMES
> +    bool "Collect preemption latency times"
> +    depends on PREEMPT
> +    help
> +      Allow collection for preemption latency times.
> +
> +config XILINX_UNCACHED_SHADOW
> +    bool "Are you using uncached shadow for RAM ?"
> +    depends on MICROBLAZE
> +    default y
> +    help
> +      This is needed to be able to allocate uncachable memory regions.
> +      The feature requires the design to define the RAM memory 
> controller window
> +      to be twice as large as the actual physical memory.

Hi,

In my MUA, the "controller window" text is on a line by itself
but it shouldn't be.  (http://lkml.org/lkml/2008/1/27/85
shows the same condition.)
I guess that Thunderbird is doing this for you (sadly).
Please see if Documentation/email-clients.txt can help you with
this.

A larger issue is that I don't see any tabs in the patch.
Kconfig reserved words (like bool and def_bool) should be indented
by 1 tab, and help text by 1 tab + 2 spaces.
I suppose that Thunderbird could have done this also.  :(

> +
> +config LARGE_ALLOCS
> +    bool "Allow allocating large blocks (> 1MB) of memory"
> +    help
> +      Allow the slab memory allocator to keep chains for very large
> +      memory sizes - up to 32MB. You may need this if your system has
> +      a lot of RAM, and you need to able to allocate very large
> +      contiguous chunks. If unsure, say N.
> +
> +comment "Boot options"
> +
> +config CMDLINE
> +    string "Default kernel command string"
> +    default ""
> +    help
> +      On some architectures there is currently no way for the boot loader
> +      to pass arguments to the kernel. For these architectures, you should
> +      supply some command-line options at build time by entering them
> +      here.
> +
> +config CMDLINE_FORCE
> +    bool "Force default kernel command string"
> +    help
> +      Set this to have arguments from the default kernel command string
> +      override those passed by the boot loader.
> +
> +config OF
> +    def_bool y
> +
> +config OF_DEVICE
> +    def_bool y
> +
> +endmenu
> +
> +config APM_EMULATION
> +    bool
> +
> +source "mm/Kconfig"
> +
> +menu "Exectuable file formats"
> +
> +source "fs/Kconfig.binfmt"
> +
> +endmenu
> +
> +source "net/Kconfig"
> +
> +source "drivers/Kconfig"
> +
> +source "fs/Kconfig"
> +
> +source "arch/microblaze/Kconfig.debug"
> +
> +source "security/Kconfig"
> +
> +source "crypto/Kconfig"
> +
> +source "lib/Kconfig"
> diff --git a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
> new file mode 100644
> index 0000000..f75d3e8
> --- /dev/null
> +++ b/arch/microblaze/Kconfig.debug
> @@ -0,0 +1,22 @@
> +# For a description of the syntax of this configuration file,
> +# see Documentation/kbuild/kconfig-language.txt.
> +
> +menu "Kernel hacking"
> +
> +source "lib/Kconfig.debug"
> +
> +config EARLY_PRINTK
> +    def_bool y
> +
> +config EARLY_PRINTK_UARTLITE_ADDRESS
> +    hex "Physical address where UART Lite for early printk is mapped"
> +    depends on EARLY_PRINTK
> +    default "0x40600000"
> +    help
> +      Please enter physical address where your uart lite is mapped.
> +
> +config DEBUG_BOOTMEM
> +    depends on DEBUG_KERNEL
> +    bool "Debug BOOTMEM initialization"
> +
> +endmenu
> diff --git a/arch/microblaze/platform/Kconfig.platform 
> b/arch/microblaze/platform/Kconfig.platform
> new file mode 100644
> index 0000000..6733dc9
> --- /dev/null
> +++ b/arch/microblaze/platform/Kconfig.platform
> @@ -0,0 +1,48 @@
> +# For a description of the syntax of this configuration file,
> +# see Documentation/kbuild/kconfig-language.txt.
> +#
> +# Platform selection Kconfig menu for MicroBlaze targets
> +#
> +
> +menu "Platform options"
> +choice
> +    prompt "Platform"
> +    default PLATFORM_MICROBLAZE_AUTO
> +    help
> +      Choose which hardware board/platform you are targeting.
> +
> +config PLATFORM_GENERIC
> +    bool "Generic"
> +    help
> +      Choose this option for the Generic platform.
> +
> +endchoice
> +
> +# This is still a bit broken - disabling for now JW 20070504
> +config ALLOW_EDIT_AUTO
> +    bool "Permit Display/edit of Kconfig.auto platform settings"
> +    default n
> +    help
> +      Allows the editing of auto-generated platform settings from
> +      the Kconfig.auto file.  Obviously this does not change the
> +      underlying hardware, so be very careful if you go editing
> +      these settings.
> +
> +      Also, if you enable this, and edit various Kconfig.auto
> +      settings, YOUR CHANGES WILL BE LOST if you then disable it
> +      again. You have been warned!
> +
> +      If unsure, say no.
> +
> +# Ok, the platform is chosen.  Source the kconfig.auto to get all of the
> +# system settings.
> +# If user selected CONFIG_EDIT_AUTO, these will be rendered in gory detail
> +# and be able to be edited
> +comment "Automatic platform settings from Kconfig.auto"
> +    depends on ALLOW_EDIT_AUTO
> +
> +if PLATFORM_GENERIC=y
> +    source "arch/microblaze/platform/generic/Kconfig.auto"
> +endif
> +
> +endmenu
> diff --git a/arch/microblaze/platform/generic/Kconfig.auto 
> b/arch/microblaze/platform/generic/Kconfig.auto
> new file mode 100644
> index 0000000..1022a1a
> --- /dev/null
> +++ b/arch/microblaze/platform/generic/Kconfig.auto
> @@ -0,0 +1,51 @@
> +# For a description of the syntax of this configuration file,
> +# see Documentation/kbuild/kconfig-language.txt.
> +#
> +# Platform Kconfig menu for Microblaze generic board
> +#
> +
> +config KERNEL_BASE_ADDR
> +    hex "Physical address where Linux Kernel is"
> +    default "0x44000000"
> +    help
> +      BASE Address for kernel
> +
> +config XILINX_ERAM_SIZE
> +    hex "Memory size of XILINX_RAM" if XILINX_UNCACHED_SHADOW
> +    default 0x02000000
> +
> +comment "Definitions for MICROBLAZE0"
> +    depends on ALLOW_EDIT_AUTO
> +
> +config XILINX_MICROBLAZE0_FAMILY
> +    string "Targetted FPGA family" if ALLOW_EDIT_AUTO
> +    default spartan3e
> +
> +config XILINX_MICROBLAZE0_HW_VER
> +    string "Core version number" if ALLOW_EDIT_AUTO
> +    default 5.00.c
> +
> +config XILINX_MICROBLAZE0_USE_MSR_INSTR
> +    int "USE_MSR_INSTR" if ALLOW_EDIT_AUTO
> +    default 1
> +    range 0 1
> +
> +config XILINX_MICROBLAZE0_USE_BARREL
> +    int "USE_BARREL" if ALLOW_EDIT_AUTO
> +    default 1
> +    range 0 1
> +
> +config XILINX_MICROBLAZE0_USE_DIV
> +    int "USE_DIV" if ALLOW_EDIT_AUTO
> +    default 1
> +    range 0 1
> +
> +config XILINX_MICROBLAZE0_USE_HW_MUL
> +    int "USE_HW_MUL" if ALLOW_EDIT_AUTO
> +    default 1
> +    range 0 2
> +
> +config XILINX_MICROBLAZE0_USE_FPU
> +    int "USE_FPU" if ALLOW_EDIT_AUTO
> +    default 0
> +    range 0 1
> -- 

---
~Randy
