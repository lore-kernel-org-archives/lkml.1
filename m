Return-Path: <linux-kernel-owner+w=401wt.eu-S1751809AbZHKPcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbZHKPcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZHKPcR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:32:17 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:57272 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbZHKPcQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:32:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S1qDO5nQTAXRQ6lpSwmRv4EmQxoy7srA1oRZWcc6g4f7Q3+E7Yb071qiWroeKWyV/3
         4IgmPGwGETHOebDI5vaErU1wUn7j2jFt3M1E+MBJLzkTQYG3UKKBalTwLeexiU8MTjk+
         MoBzqZ9GV1G7PPejX56pwZNrcxNe1g67r8HMo=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0908111056550.30494@gentwo.org>
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>
	 <alpine.DEB.1.10.0908111032110.30494@gentwo.org>
	 <c4e36d110908110752x253e30epb00cc71f4683052b@mail.gmail.com>
	 <alpine.DEB.1.10.0908111056550.30494@gentwo.org>
Date: Tue, 11 Aug 2009 17:32:16 +0200
Message-ID: <c4e36d110908110832y21fba830ub8804613df571228@mail.gmail.com>
Subject: Re: System freeze on reboot - general protection fault
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/8/11 Christoph Lameter <cl@linux-foundation.org>:
> On Tue, 11 Aug 2009, Zdenek Kabelac wrote:
>
>> Well - I've tried to switch from  'slub' allocator to  old 'slab'
>> allocator and the problem is gone - shutdown goes without any problem.
>>
>> So it's probably related to 'slub' allocator only?
>
> The slab allocator does not have all the diagnostics of slub. The issue
> may simply not be detected in slab. If you switch off diagnostics in slub
> then everything will seem to work fine as well. But we need to figure out
> what is going wrong here.

Hmm - but there are few things -

My machine runs  Fedora Rawhide. If I run the same kernel within KVM
running Debian unstable I could easily reboot this guest machine
without any problems.

Also if I boot Rawhide only to single mode - I could also reboot
machine without this oops.
The problem seems to be - when I do full machine startup to the
multiuser runlevel 3

Another issue which might make hunting for the problem harder is -
that kvm doesn't have the same ACPI like I have on my Lenovo laptop.
So the KVM doesn't  help here probably?
(I assume most probably some hw initialization overwrites something somewhere ?)


>
>>anything else I could try to better detect this problem?
>
> Does it work with 2.6.30?

I've no idea - I'll need to rebuild couple kernels - I've enabled
these debugs options only recently.


> If you can do debugging during bootstrap (kvm?) then set a breakpoint at
> slab_bug. The registers have enough information to get the error message
> at that point.

How setting the breakpoint during boot process helps here ??
I'm getting this oops during shutdown - just before machine goes off.

>
>> (well the bisect should be last resort - as it might be pretty lengthy
>> - I'm not really sure which kernel would be actually good for the
>> start)
>
> The last released stable kernel is a good point to start.

Ok - I guess it will take couple hours....


Zdenek

>
>> >> # CONFIG_LDM_DEBUG is not set
>> >> # CONFIG_SGI_PARTITION is not set
>> >> # CONFIG_ULTRIX_PARTITION is not set
>> >> # CONFIG_SUN_PARTITION is not set
>> >> # CONFIG_KARMA_PARTITION is not set
>> >> CONFIG_EFI_PARTITION=y
>> >> # CONFIG_SYSV68_PARTITION is not set
>> >> CONFIG_NLS=y
>> >> CONFIG_NLS_DEFAULT="iso8859-1"
>> >> # CONFIG_NLS_CODEPAGE_437 is not set
>> >> # CONFIG_NLS_CODEPAGE_737 is not set
>> >> # CONFIG_NLS_CODEPAGE_775 is not set
>> >> # CONFIG_NLS_CODEPAGE_850 is not set
>> >> CONFIG_NLS_CODEPAGE_852=m
>> >> # CONFIG_NLS_CODEPAGE_855 is not set
>> >> # CONFIG_NLS_CODEPAGE_857 is not set
>> >> # CONFIG_NLS_CODEPAGE_860 is not set
>> >> # CONFIG_NLS_CODEPAGE_861 is not set
>> >> # CONFIG_NLS_CODEPAGE_862 is not set
>> >> # CONFIG_NLS_CODEPAGE_863 is not set
>> >> # CONFIG_NLS_CODEPAGE_864 is not set
>> >> # CONFIG_NLS_CODEPAGE_865 is not set
>> >> # CONFIG_NLS_CODEPAGE_866 is not set
>> >> # CONFIG_NLS_CODEPAGE_869 is not set
>> >> # CONFIG_NLS_CODEPAGE_936 is not set
>> >> # CONFIG_NLS_CODEPAGE_950 is not set
>> >> # CONFIG_NLS_CODEPAGE_932 is not set
>> >> # CONFIG_NLS_CODEPAGE_949 is not set
>> >> # CONFIG_NLS_CODEPAGE_874 is not set
>> >> # CONFIG_NLS_ISO8859_8 is not set
>> >> CONFIG_NLS_CODEPAGE_1250=m
>> >> # CONFIG_NLS_CODEPAGE_1251 is not set
>> >> CONFIG_NLS_ASCII=y
>> >> CONFIG_NLS_ISO8859_1=m
>> >> CONFIG_NLS_ISO8859_2=m
>> >> # CONFIG_NLS_ISO8859_3 is not set
>> >> # CONFIG_NLS_ISO8859_4 is not set
>> >> # CONFIG_NLS_ISO8859_5 is not set
>> >> # CONFIG_NLS_ISO8859_6 is not set
>> >> # CONFIG_NLS_ISO8859_7 is not set
>> >> # CONFIG_NLS_ISO8859_9 is not set
>> >> # CONFIG_NLS_ISO8859_13 is not set
>> >> # CONFIG_NLS_ISO8859_14 is not set
>> >> # CONFIG_NLS_ISO8859_15 is not set
>> >> # CONFIG_NLS_KOI8_R is not set
>> >> # CONFIG_NLS_KOI8_U is not set
>> >> CONFIG_NLS_UTF8=m
>> >> # CONFIG_DLM is not set
>> >>
>> >> #
>> >> # Kernel hacking
>> >> #
>> >> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
>> >> CONFIG_PRINTK_TIME=y
>> >> CONFIG_ENABLE_WARN_DEPRECATED=y
>> >> CONFIG_ENABLE_MUST_CHECK=y
>> >> CONFIG_FRAME_WARN=2048
>> >> CONFIG_MAGIC_SYSRQ=y
>> >> # CONFIG_UNUSED_SYMBOLS is not set
>> >> CONFIG_DEBUG_FS=y
>> >> # CONFIG_HEADERS_CHECK is not set
>> >> CONFIG_DEBUG_KERNEL=y
>> >> CONFIG_DEBUG_SHIRQ=y
>> >> CONFIG_DETECT_SOFTLOCKUP=y
>> >> # CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC is not set
>> >> CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
>> >> CONFIG_DETECT_HUNG_TASK=y
>> >> # CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
>> >> CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
>> >> CONFIG_SCHED_DEBUG=y
>> >> CONFIG_SCHEDSTATS=y
>> >> CONFIG_TIMER_STATS=y
>> >> CONFIG_DEBUG_OBJECTS=y
>> >> # CONFIG_DEBUG_OBJECTS_SELFTEST is not set
>> >> CONFIG_DEBUG_OBJECTS_FREE=y
>> >> CONFIG_DEBUG_OBJECTS_TIMERS=y
>> >> CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=1
>> >> CONFIG_SLUB_DEBUG_ON=y
>> >> # CONFIG_SLUB_STATS is not set
>> >> # CONFIG_DEBUG_KMEMLEAK is not set
>> >> CONFIG_DEBUG_RT_MUTEXES=y
>> >> CONFIG_DEBUG_PI_LIST=y
>> >> # CONFIG_RT_MUTEX_TESTER is not set
>> >> CONFIG_DEBUG_SPINLOCK=y
>> >> CONFIG_DEBUG_MUTEXES=y
>> >> CONFIG_DEBUG_LOCK_ALLOC=y
>> >> CONFIG_PROVE_LOCKING=y
>> >> CONFIG_LOCKDEP=y
>> >> CONFIG_LOCK_STAT=y
>> >> # CONFIG_DEBUG_LOCKDEP is not set
>> >> CONFIG_TRACE_IRQFLAGS=y
>> >> CONFIG_DEBUG_SPINLOCK_SLEEP=y
>> >> # CONFIG_DEBUG_LOCKING_API_SELFTESTS is not set
>> >> CONFIG_STACKTRACE=y
>> >> # CONFIG_DEBUG_KOBJECT is not set
>> >> CONFIG_DEBUG_BUGVERBOSE=y
>> >> CONFIG_DEBUG_INFO=y
>> >> CONFIG_DEBUG_VM=y
>> >> # CONFIG_DEBUG_VIRTUAL is not set
>> >> # CONFIG_DEBUG_WRITECOUNT is not set
>> >> # CONFIG_DEBUG_MEMORY_INIT is not set
>> >> CONFIG_DEBUG_LIST=y
>> >> CONFIG_DEBUG_SG=y
>> >> CONFIG_DEBUG_NOTIFIERS=y
>> >> CONFIG_ARCH_WANT_FRAME_POINTERS=y
>> >> CONFIG_FRAME_POINTER=y
>> >> # CONFIG_BOOT_PRINTK_DELAY is not set
>> >> # CONFIG_RCU_TORTURE_TEST is not set
>> >> CONFIG_RCU_CPU_STALL_DETECTOR=y
>> >> # CONFIG_KPROBES_SANITY_TEST is not set
>> >> # CONFIG_BACKTRACE_SELF_TEST is not set
>> >> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
>> >> # CONFIG_LKDTM is not set
>> >> # CONFIG_FAULT_INJECTION is not set
>> >> CONFIG_LATENCYTOP=y
>> >> # CONFIG_SYSCTL_SYSCALL_CHECK is not set
>> >> CONFIG_DEBUG_PAGEALLOC=y
>> >> CONFIG_USER_STACKTRACE_SUPPORT=y
>> >> CONFIG_NOP_TRACER=y
>> >> CONFIG_HAVE_FTRACE_NMI_ENTER=y
>> >> CONFIG_HAVE_FUNCTION_TRACER=y
>> >> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
>> >> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
>> >> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
>> >> CONFIG_HAVE_DYNAMIC_FTRACE=y
>> >> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
>> >> CONFIG_HAVE_FTRACE_SYSCALLS=y
>> >> CONFIG_TRACER_MAX_TRACE=y
>> >> CONFIG_RING_BUFFER=y
>> >> CONFIG_FTRACE_NMI_ENTER=y
>> >> CONFIG_EVENT_TRACING=y
>> >> CONFIG_CONTEXT_SWITCH_TRACER=y
>> >> CONFIG_TRACING=y
>> >> CONFIG_GENERIC_TRACER=y
>> >> CONFIG_TRACING_SUPPORT=y
>> >> CONFIG_FTRACE=y
>> >> CONFIG_FUNCTION_TRACER=y
>> >> CONFIG_FUNCTION_GRAPH_TRACER=y
>> >> CONFIG_IRQSOFF_TRACER=y
>> >> CONFIG_SYSPROF_TRACER=y
>> >> CONFIG_SCHED_TRACER=y
>> >> # CONFIG_FTRACE_SYSCALLS is not set
>> >> CONFIG_BOOT_TRACER=y
>> >> CONFIG_BRANCH_PROFILE_NONE=y
>> >> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
>> >> # CONFIG_PROFILE_ALL_BRANCHES is not set
>> >> CONFIG_POWER_TRACER=y
>> >> CONFIG_STACK_TRACER=y
>> >> CONFIG_KMEMTRACE=y
>> >> CONFIG_WORKQUEUE_TRACER=y
>> >> # CONFIG_BLK_DEV_IO_TRACE is not set
>> >> CONFIG_DYNAMIC_FTRACE=y
>> >> # CONFIG_FUNCTION_PROFILER is not set
>> >> CONFIG_FTRACE_MCOUNT_RECORD=y
>> >> # CONFIG_FTRACE_STARTUP_TEST is not set
>> >> CONFIG_MMIOTRACE=y
>> >> CONFIG_MMIOTRACE_TEST=m
>> >> # CONFIG_RING_BUFFER_BENCHMARK is not set
>> >> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
>> >> # CONFIG_DYNAMIC_DEBUG is not set
>> >> CONFIG_DMA_API_DEBUG=y
>> >> # CONFIG_SAMPLES is not set
>> >> CONFIG_HAVE_ARCH_KGDB=y
>> >> # CONFIG_KGDB is not set
>> >> CONFIG_HAVE_ARCH_KMEMCHECK=y
>> >> # CONFIG_STRICT_DEVMEM is not set
>> >> CONFIG_X86_VERBOSE_BOOTUP=y
>> >> # CONFIG_EARLY_PRINTK is not set
>> >> CONFIG_DEBUG_STACKOVERFLOW=y
>> >> CONFIG_DEBUG_STACK_USAGE=y
>> >> # CONFIG_DEBUG_PER_CPU_MAPS is not set
>> >> CONFIG_X86_PTDUMP=y
>> >> CONFIG_DEBUG_RODATA=y
>> >> # CONFIG_DEBUG_RODATA_TEST is not set
>> >> # CONFIG_DEBUG_NX_TEST is not set
>> >> # CONFIG_IOMMU_DEBUG is not set
>> >> # CONFIG_IOMMU_STRESS is not set
>> >> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
>> >> CONFIG_IO_DELAY_TYPE_0X80=0
>> >> CONFIG_IO_DELAY_TYPE_0XED=1
>> >> CONFIG_IO_DELAY_TYPE_UDELAY=2
>> >> CONFIG_IO_DELAY_TYPE_NONE=3
>> >> CONFIG_IO_DELAY_0X80=y
>> >> # CONFIG_IO_DELAY_0XED is not set
>> >> # CONFIG_IO_DELAY_UDELAY is not set
>> >> # CONFIG_IO_DELAY_NONE is not set
>> >> CONFIG_DEFAULT_IO_DELAY_TYPE=0
>> >> CONFIG_DEBUG_BOOT_PARAMS=y
>> >> # CONFIG_CPA_DEBUG is not set
>> >> CONFIG_OPTIMIZE_INLINING=y
>> >>
>> >> #
>> >> # Security options
>> >> #
>> >> # CONFIG_KEYS is not set
>> >> CONFIG_SECURITY=y
>> >> # CONFIG_SECURITYFS is not set
>> >> CONFIG_SECURITY_NETWORK=y
>> >> # CONFIG_SECURITY_NETWORK_XFRM is not set
>> >> # CONFIG_SECURITY_PATH is not set
>> >> # CONFIG_SECURITY_FILE_CAPABILITIES is not set
>> >> CONFIG_SECURITY_SELINUX=y
>> >> CONFIG_SECURITY_SELINUX_BOOTPARAM=y
>> >> CONFIG_SECURITY_SELINUX_BOOTPARAM_VALUE=1
>> >> CONFIG_SECURITY_SELINUX_DISABLE=y
>> >> CONFIG_SECURITY_SELINUX_DEVELOP=y
>> >> CONFIG_SECURITY_SELINUX_AVC_STATS=y
>> >> CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
>> >> # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
>> >> # CONFIG_SECURITY_TOMOYO is not set
>> >> # CONFIG_IMA is not set
>> >> CONFIG_XOR_BLOCKS=m
>> >> CONFIG_ASYNC_CORE=m
>> >> CONFIG_ASYNC_MEMCPY=m
>> >> CONFIG_ASYNC_XOR=m
>> >> CONFIG_CRYPTO=y
>> >>
>> >> #
>> >> # Crypto core or helper
>> >> #
>> >> # CONFIG_CRYPTO_FIPS is not set
>> >> CONFIG_CRYPTO_ALGAPI=m
>> >> CONFIG_CRYPTO_ALGAPI2=m
>> >> CONFIG_CRYPTO_AEAD2=m
>> >> CONFIG_CRYPTO_BLKCIPHER=m
>> >> CONFIG_CRYPTO_BLKCIPHER2=m
>> >> CONFIG_CRYPTO_HASH=m
>> >> CONFIG_CRYPTO_HASH2=m
>> >> CONFIG_CRYPTO_RNG2=m
>> >> CONFIG_CRYPTO_PCOMP=m
>> >> CONFIG_CRYPTO_MANAGER=m
>> >> CONFIG_CRYPTO_MANAGER2=m
>> >> # CONFIG_CRYPTO_GF128MUL is not set
>> >> # CONFIG_CRYPTO_NULL is not set
>> >> CONFIG_CRYPTO_WORKQUEUE=m
>> >> # CONFIG_CRYPTO_CRYPTD is not set
>> >> # CONFIG_CRYPTO_AUTHENC is not set
>> >> # CONFIG_CRYPTO_TEST is not set
>> >>
>> >> #
>> >> # Authenticated Encryption with Associated Data
>> >> #
>> >> # CONFIG_CRYPTO_CCM is not set
>> >> # CONFIG_CRYPTO_GCM is not set
>> >> # CONFIG_CRYPTO_SEQIV is not set
>> >>
>> >> #
>> >> # Block modes
>> >> #
>> >> CONFIG_CRYPTO_CBC=m
>> >> # CONFIG_CRYPTO_CTR is not set
>> >> # CONFIG_CRYPTO_CTS is not set
>> >> CONFIG_CRYPTO_ECB=m
>> >> # CONFIG_CRYPTO_LRW is not set
>> >> # CONFIG_CRYPTO_PCBC is not set
>> >> # CONFIG_CRYPTO_XTS is not set
>> >>
>> >> #
>> >> # Hash modes
>> >> #
>> >> CONFIG_CRYPTO_HMAC=m
>> >> # CONFIG_CRYPTO_XCBC is not set
>> >>
>> >> #
>> >> # Digest
>> >> #
>> >> CONFIG_CRYPTO_CRC32C=m
>> >> # CONFIG_CRYPTO_CRC32C_INTEL is not set
>> >> # CONFIG_CRYPTO_MD4 is not set
>> >> CONFIG_CRYPTO_MD5=m
>> >> CONFIG_CRYPTO_MICHAEL_MIC=m
>> >> # CONFIG_CRYPTO_RMD128 is not set
>> >> # CONFIG_CRYPTO_RMD160 is not set
>> >> # CONFIG_CRYPTO_RMD256 is not set
>> >> # CONFIG_CRYPTO_RMD320 is not set
>> >> CONFIG_CRYPTO_SHA1=m
>> >> CONFIG_CRYPTO_SHA256=m
>> >> # CONFIG_CRYPTO_SHA512 is not set
>> >> # CONFIG_CRYPTO_TGR192 is not set
>> >> # CONFIG_CRYPTO_WP512 is not set
>> >>
>> >> #
>> >> # Ciphers
>> >> #
>> >> CONFIG_CRYPTO_AES=m
>> >> # CONFIG_CRYPTO_AES_X86_64 is not set
>> >> # CONFIG_CRYPTO_AES_NI_INTEL is not set
>> >> # CONFIG_CRYPTO_ANUBIS is not set
>> >> CONFIG_CRYPTO_ARC4=m
>> >> # CONFIG_CRYPTO_BLOWFISH is not set
>> >> # CONFIG_CRYPTO_CAMELLIA is not set
>> >> # CONFIG_CRYPTO_CAST5 is not set
>> >> # CONFIG_CRYPTO_CAST6 is not set
>> >> CONFIG_CRYPTO_DES=m
>> >> # CONFIG_CRYPTO_FCRYPT is not set
>> >> # CONFIG_CRYPTO_KHAZAD is not set
>> >> # CONFIG_CRYPTO_SALSA20 is not set
>> >> # CONFIG_CRYPTO_SALSA20_X86_64 is not set
>> >> # CONFIG_CRYPTO_SEED is not set
>> >> # CONFIG_CRYPTO_SERPENT is not set
>> >> # CONFIG_CRYPTO_TEA is not set
>> >> # CONFIG_CRYPTO_TWOFISH is not set
>> >> # CONFIG_CRYPTO_TWOFISH_X86_64 is not set
>> >>
>> >> #
>> >> # Compression
>> >> #
>> >> # CONFIG_CRYPTO_DEFLATE is not set
>> >> # CONFIG_CRYPTO_ZLIB is not set
>> >> # CONFIG_CRYPTO_LZO is not set
>> >>
>> >> #
>> >> # Random Number Generation
>> >> #
>> >> # CONFIG_CRYPTO_ANSI_CPRNG is not set
>> >> CONFIG_CRYPTO_HW=y
>> >> # CONFIG_CRYPTO_DEV_PADLOCK is not set
>> >> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
>> >> CONFIG_HAVE_KVM=y
>> >> CONFIG_HAVE_KVM_IRQCHIP=y
>> >> CONFIG_VIRTUALIZATION=y
>> >> CONFIG_KVM=m
>> >> CONFIG_KVM_INTEL=m
>> >> CONFIG_KVM_AMD=m
>> >> CONFIG_KVM_TRACE=y
>> >> CONFIG_VIRTIO=m
>> >> CONFIG_VIRTIO_RING=m
>> >> CONFIG_VIRTIO_PCI=m
>> >> CONFIG_VIRTIO_BALLOON=m
>> >> CONFIG_BINARY_PRINTF=y
>> >>
>> >> #
>> >> # Library routines
>> >> #
>> >> CONFIG_BITREVERSE=y
>> >> CONFIG_GENERIC_FIND_FIRST_BIT=y
>> >> CONFIG_GENERIC_FIND_NEXT_BIT=y
>> >> CONFIG_GENERIC_FIND_LAST_BIT=y
>> >> CONFIG_CRC_CCITT=m
>> >> CONFIG_CRC16=m
>> >> CONFIG_CRC_T10DIF=y
>> >> CONFIG_CRC_ITU_T=m
>> >> CONFIG_CRC32=y
>> >> # CONFIG_CRC7 is not set
>> >> CONFIG_LIBCRC32C=m
>> >> CONFIG_ZLIB_INFLATE=y
>> >> CONFIG_ZLIB_DEFLATE=m
>> >> CONFIG_LZO_COMPRESS=m
>> >> CONFIG_LZO_DECOMPRESS=m
>> >> CONFIG_DECOMPRESS_GZIP=y
>> >> CONFIG_DECOMPRESS_BZIP2=y
>> >> CONFIG_HAS_IOMEM=y
>> >> CONFIG_HAS_IOPORT=y
>> >> CONFIG_HAS_DMA=y
>> >> CONFIG_NLATTR=y
>> >>
>> >
>>
>>
>
