Return-Path: <linux-kernel-owner+w=401wt.eu-S1757257AbYA0LEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257AbYA0LEy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 06:04:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYA0LEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 06:04:30 -0500
Received: from smtp01.pevnalinka.cz ([89.31.40.2]:60122 "EHLO
	mail.pevnalinka.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753580AbYA0LE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 06:04:27 -0500
Message-ID: <479C5F69.1000707@monstr.eu>
Date: Sun, 27 Jan 2008 11:39:37 +0100
From: Michal Simek <monstr@monstr.eu>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       john.williams@petalogix.com, microblaze-uclinux@itee.uq.edu.au,
       sam@ravnborg.org
Subject: Re: [PATCH 01/52] [microblaze] Kconfig patches
References: <8051f6df628e1ff896ec7d580b613da50f718fb4.1201107832.git.monstr@monstr.eu> <20080126093657.f628b0ef.randy.dunlap@oracle.com>
In-Reply-To: <20080126093657.f628b0ef.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

thanks for review. Comments are below.
>> diff --git a/arch/microblaze/Kconfig b/arch/microblaze/Kconfig
>> new file mode 100644
>> index 0000000..6dbc069
>> --- /dev/null
>> +++ b/arch/microblaze/Kconfig
>> @@ -0,0 +1,160 @@
>> +# For a description of the syntax of this configuration file,
>> +# see Documentation/kbuild/config-language.txt.
>>     
>
> It's                          kconfig-language.txt.
>   
I fix it
>> +
>> +mainmenu "Linux/Microblaze Kernel Configuration"
>> +
>> +config MICROBLAZE
>> +	bool
>> +	default y
>>     
>
> The one-line form:
> 	def_bool y
> is preferred, just to be more concise, use less screen real estate...
> Above and many times below.
>   
fix.

>> +config MMU
>> +	bool
>> +	default n
>> +
>> +config SWAP
>> +	bool
>> +	default n
>> +
>> +config RWSEM_GENERIC_SPINLOCK
>> +	bool
>> +	default y
>> +
>> +config RWSEM_XCHGADD_ALGORITHM
>> +	bool
>> +
>> +
>> +config ARCH_HAS_ILOG2_U32
>> +	bool
>> +	default n
>> +
>> +config ARCH_HAS_ILOG2_U64
>> +	bool
>> +	default n
>> +
>> +config GENERIC_FIND_NEXT_BIT
>> +	bool
>> +	default y
>> +
>> +config GENERIC_HWEIGHT
>> +	bool
>> +	default y
>> +
>> +config GENERIC_HARDIRQS
>> +	bool
>> +	default y
>> +
>> +config GENERIC_IRQ_PROBE
>> +	bool
>> +	default y
>> +
>> +config GENERIC_CALIBRATE_DELAY
>> +	bool
>> +	default y
>> +
>> +config PCI
>> +	bool
>> +	default n
>> +
>> +config UID16
>> +	bool
>> +	default y
>> +
>> +config DEFCONFIG_LIST
>> +	string
>> +	default "arch/$ARCH/defconfig"
>> +
>> +source "init/Kconfig"
>> +
>> +source "arch/microblaze/platform/Kconfig.platform"
>> +
>> +menu "Processor type and features"
>> +config PREEMPT
>> +	bool "Preemptible Kernel"
>> +	help
>> +	  This option reduces the latency of the kernel when reacting to
>> +	  real-time or interactive events by allowing a low priority process to
>> +	  be preempted even if it is in kernel mode executing a system call.
>> +	  This allows applications to run more reliably even when the system is
>> +	  under load.
>> +
>> +	  Say Y here if you are building a kernel for a desktop, embedded
>> +	  or real-time system.  Say N if you are unsure.
>> +
>> +config PREEMPT_TIMES
>> +	bool "Collect preemption latency times"
>> +	depends on PREEMPT
>> +	help
>> +	  Allow collection for preemption latency times.
>> +
>> +config XILINX_UNCACHED_SHADOW
>> +    bool "Are you using uncached shadow for RAM ?"
>> +    depends on MICROBLAZE
>> +    default y
>> +    help
>> +      This is needed to be able to allocate uncachable memory regions.
>>     
>
> We don't seem to spell uncacheable consistently.
>
> Kernel source tree:
> 	uncachable - 27 times
> 	uncacheable - 53 times
> google:
> 	uncachable - 11,900 hits
> 	uncacheable - 26,700 hits
>
> so I would use "uncacheable".
>
>   
I don't know if is spelling correct. But I tried to find count of uncached
in kernel tree and a result is interesting. For me is not problem to 
change it.

$ grep -rn "uncached" * | grep -v "microblaze" | grep "*" | wc -l
198
 
>> +      The feature requires the design to define the RAM memory controller window
>> +      to be twice as large as the actual physical memory.
>> +
>> +config LARGE_ALLOCS
>> +       bool "Allow allocating large blocks (> 1MB) of memory"
>> +       help
>> +            Allow the slab memory allocator to keep chains for very large
>> +            memory sizes - upto 32MB. You may need this if your system has
>>     
>
> s/upto/up to/
>   
fix.
>> +            a lot of RAM, and you need to able to allocate very large
>> +            contiguous chunks. If unsure, say N.
>>     
>
> Please indent config symbol help text as indicated in
> Documentation/CodingStyle:  one tab + 2 spaces for each line of help text.
> (Please check all help text.)
>   
fix in all Kconfig files.
>> +comment "Boot options"
>> +
>> +config CMDLINE
>> +	string "Default kernel command string"
>> +	default ""
>> +	help
>> +	  On some architectures there is currently no way for the boot loader
>> +	  to pass arguments to the kernel. For these architectures, you should
>> +	  supply some command-line options at build time by entering them 
>> +	  here. 
>> +
>> +config CMDLINE_FORCE
>> +	bool "Force default kernel command string"
>> +	help
>> +	  Set this to have arguments from the default kernel command string 
>> +	  override those passed by the boot loader
>>     
>
> End with period (".").
>   
fix in all Kconfig files.
>> +
>> +config OF
>> +	bool
>> +	default y
>> +	help
>> +	  Set this to turn on OF
>>     
>
> End with period.  Is this Open Firmware?
>
>   
>> +config OF_DEVICE
>> +	bool
>> +	default y
>> +	help
>> +	  Set this to turn on OF
>>     
>
> Ditto.
>   
Yes. Microblaze architecture use Open Firmware files. I set to this 
value with def_boot y without help part.
>> diff --git a/arch/microblaze/Kconfig.debug b/arch/microblaze/Kconfig.debug
>> new file mode 100644
>> index 0000000..1ccdd84
>> --- /dev/null
>> +++ b/arch/microblaze/Kconfig.debug
>> @@ -0,0 +1,22 @@
>> +menu "Kernel hacking"
>> +
>> +source "lib/Kconfig.debug"
>> +
>> +config EARLY_PRINTK
>> +	bool "EARLY_PRINTK"
>> +	default y
>> +
>> +config EARLY_PRINTK_UARTLITE_ADDRESS
>> +	hex "Physical address where UART Lite for early printk is mapped"
>> +	depends on EARLY_PRINTK
>> +	default "0x40600000"
>> +	help
>> +	  Please enter physcal address where your uart lite is mapped
>>     
>
> End with period.  s/physcal/physical/
>   
fix + all period faults.
>> +endchoice
>> +
>> +# This is stil a bit broken - disabling for now JW 20070504
>>     
>
> s/stil/still/
>   
fix
>> diff --git a/arch/microblaze/platform/generic/Kconfig.auto b/arch/microblaze/platform/generic/Kconfig.auto
>> new file mode 100644
>> index 0000000..751369b
>> --- /dev/null
>> +++ b/arch/microblaze/platform/generic/Kconfig.auto
>> @@ -0,0 +1,45 @@
>> +#
>> +# Platform Kconfig menu for Microblaze generic board
>> +#
>> +
>> +config KERNEL_BASE_ADDR
>> +	hex "Physical address where Linux Kernel is"
>> +	default "0x44000000"
>> +	help
>> +	  BASE Address for kernel
>> +
>> +config XILINX_ERAM_SIZE
>> +       hex "Size address of XILINX_RAM" if ALLOW_EDIT_AUTO && XILINX_UNCACHED_SHADOW
>>     
>
> What is a "Size address"?
>   
Size address is physical size of main memory - fix.
>> +       default 0x02000000
>> +
>> +comment "Definitions for MICROBLAZE0"
>> +      depends on ALLOW_EDIT_AUTO
>> +
>> +config XILINX_MICROBLAZE0_FAMILY
>> +       string "Targetted FPGA family" if ALLOW_EDIT_AUTO
>> +       default spartan3e
>> +
>> +config XILINX_MICROBLAZE0_HW_VER
>> +       string "Core version number" if ALLOW_EDIT_AUTO
>> +       default 5.00.c
>> +
>> +config XILINX_MICROBLAZE0_USE_MSR_INSTR
>> +       int "USE_MSR_INSTR" if ALLOW_EDIT_AUTO
>> +       default 1
>> +
>> +config XILINX_MICROBLAZE0_USE_BARREL
>> +       int "USE_BARREL range (0:1)" if ALLOW_EDIT_AUTO
>> +       default 1
>>     
>
> These (above & below) look like booleans.  If you really need a
> range, config symbols can be specified as ranges.  See
> Documentation/kbuild/kconfig-language.txt.
>   
Fix is with range property.
>> +config XILINX_MICROBLAZE0_USE_DIV
>> +       int "USE_DIV range (0:1)" if ALLOW_EDIT_AUTO
>> +       default 1
>> +
>> +config XILINX_MICROBLAZE0_USE_HW_MUL
>> +       int "USE_HW_MUL range (0:1)" if ALLOW_EDIT_AUTO
>> +       default 1
>> +
>> +config XILINX_MICROBLAZE0_USE_FPU
>> +       int "USE_FPU range (0:1)" if ALLOW_EDIT_AUTO
>> +       default 0
>> +
>> -- 
>>     
>
> ---
> ~Randy
Regards,
Michal Simek
