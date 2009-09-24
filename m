Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbZIXBoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbZIXBoA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 21:44:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZIXBn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 21:43:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:31904 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbZIXBnx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 21:43:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,441,1249282800"; 
   d="scan'208";a="451143721"
Subject: Re: [origin tree boot crash] NULL pointer dereference, IP:
 [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
From: Lin Ming <ming.m.lin@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@kernel.org>, "Moore, Robert" <robert.moore@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <20090923213052.GA6648@elte.hu>
References: <alpine.LFD.2.00.0909190237560.22030@localhost.localdomain>
	 <20090923213052.GA6648@elte.hu>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 09:35:14 +0800
Message-Id: <1253756114.9794.43.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 05:30 +0800, Ingo Molnar wrote:
> > commit 15b8dd53f5ffaf8e2d9095c423f713423f576c0f
> > Date:   Mon Jun 29 13:39:29 2009 +0800
> >
> >     ACPICA: Major update for acpi_get_object_info external interface
> 
> this one is causing boot crashes in -tip testing:

Hi,

Could you please try below commit at linux-acpi-2.6/release branch.

commit 718fb0de8ff88f71b3b91a8ee8e42e60c88e5128
Author: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Date:   Thu Aug 6 23:18:12 2009 +0000

    ACPI: fix NULL bug for HID/UID string
    
    acpi_device->pnp.hardware_id and unique_id are now allocated pointers,
    replacing the previous arrays.  acpi_device_install_notify_handler()
    oopsed on the NULL hid when probing the video device, and perhaps other
    uses are vulnerable too.  So initialize those pointers to empty strings
    when there is no hid or uid.  Also, free hardware_id and unique_id when
    when acpi_device is going to be freed.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=14096
    
    Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

Thanks,
Lin Ming

> 
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> initcall acpiphp_init+0x0/0x83 returned -19 after 16410 usecs
> calling  ibm_acpiphp_init+0x0/0x190 @ 1
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> IP: [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
> PGD 0
> Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file:
> CPU 0
> Pid: 1, comm: swapper Not tainted 2.6.31-tip #16786 System Product Name
> RIP: 0010:[<ffffffff82b07130>]  [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
> RSP: 0018:ffff88003f2d1d60  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88003f2d1d68 RSI: 00000000000001e4 RDI: 0000000000000000
> RBP: ffff88003f2d1d90 R08: 0000000000000001 R09: ffffffff824b645b
> R10: 000000002d0ef63b R11: ffff88003f2d1a80 R12: ffff88003fa780d0
> R13: ffffffff83940dc8 R14: 0000000000000001 R15: ffffffff83942e10
> FS:  0000000000000000(0000) GS:ffff880005800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000003 CR3: 0000000001001000 CR4: 00000000000006b0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff88003f2d0000, task ffff88003f2c8000)
> Stack:
>  ffff88003f2c8000 ffff88003cfbb690 000000002d0ef63b 0000000000000000
> <0> 0000000000000000 ffff88003fa780d0 ffff88003f2d1e10 ffffffff8156b6b6
> <0> 0000000000000001 0000000100000000 0000000000000000 ffffffff83940dc8
> Call Trace:
>  [<ffffffff8156b6b6>] acpi_ns_walk_namespace+0x11d/0x234
>  [<ffffffff82b070d4>] ? ibm_find_acpi_device+0x0/0xf5
>  [<ffffffff8157b159>] ? acpi_ut_acquire_mutex+0xd9/0x12e
>  [<ffffffff82b070d4>] ? ibm_find_acpi_device+0x0/0xf5
>  [<ffffffff81566dfa>] acpi_walk_namespace+0x105/0x162
>  [<ffffffff81d067bf>] ? acpi_pm_read+0xd/0x3e
>  [<ffffffff82b06f44>] ? ibm_acpiphp_init+0x0/0x190
>  [<ffffffff82b06fa8>] ibm_acpiphp_init+0x64/0x190
>  [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
>  [<ffffffff810edecc>] ? init_irq_proc+0x77/0x9a
>  [<ffffffff82ad8975>] do_basic_setup+0x5e/0x87
>  [<ffffffff82ad8a26>] kernel_init+0x88/0xe2
>  [<ffffffff8103ddfa>] child_rip+0xa/0x20
>  [<ffffffff8103d7bc>] ? restore_args+0x0/0x30
>  [<ffffffff82ad899e>] ? kernel_init+0x0/0xe2
>  [<ffffffff8103ddf0>] ? child_rip+0x0/0x20
> Code: 48 c7 c2 c0 7b 0b 82 48 c7 c6 95 39 4a 82 48 c7 c7 1a 3c 4a 82 31 c0 e8 02 84 4b ff 31 c0 e9 82 00 00 00 48 8b 45 d8 48 8b 40 30 <c6> 40 03 00 48 8b 45 d8 83 78 18 00 74 5f f6 40 0d 04 74 59 48
> RIP  [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
>  RSP <ffff88003f2d1d60>
> CR2: 0000000000000003
> ---[ end trace 5a5d197966b56a2e ]---
> Kernel panic - not syncing: Fatal exception
> Pid: 1, comm: swapper Tainted: G      D    2.6.31-tip #16786
> 
> This is a huge commit which doesnt revert cleanly. I took a stab at it,
> see that revert below - it didnt help.
> 
> Obviously we'd want a fix instead of that - i'm willing to test any
> patch.
> 
> oh. I should have looked at the crash site before bisecting and
> reverting. That sure looks like an unconverted acpi_get_object_info()
> call, right?
> 
>         Ingo
> 
> -------------->
> From 2773b5bd6e64ec04dfbc123841bf6f4c5e58dea5 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Wed, 23 Sep 2009 23:22:49 +0200
> Subject: [PATCH] Revert "ACPICA: Major update for acpi_get_object_info external interface"
> 
> This reverts commit 15b8dd53f5ffaf8e2d9095c423f713423f576c0f.
> 
> Conflicts:
> 
>         drivers/acpi/scan.c
> 
> Causes this crash:
> 
> acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> initcall acpiphp_init+0x0/0x83 returned -19 after 16410 usecs
> calling  ibm_acpiphp_init+0x0/0x190 @ 1
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000003
> IP: [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
> PGD 0
> Oops: 0002 [#1] SMP DEBUG_PAGEALLOC
> last sysfs file:
> CPU 0
> Pid: 1, comm: swapper Not tainted 2.6.31-tip #16786 System Product Name
> RIP: 0010:[<ffffffff82b07130>]  [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
> RSP: 0018:ffff88003f2d1d60  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88003f2d1d68 RSI: 00000000000001e4 RDI: 0000000000000000
> RBP: ffff88003f2d1d90 R08: 0000000000000001 R09: ffffffff824b645b
> R10: 000000002d0ef63b R11: ffff88003f2d1a80 R12: ffff88003fa780d0
> R13: ffffffff83940dc8 R14: 0000000000000001 R15: ffffffff83942e10
> FS:  0000000000000000(0000) GS:ffff880005800000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000003 CR3: 0000000001001000 CR4: 00000000000006b0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 1, threadinfo ffff88003f2d0000, task ffff88003f2c8000)
> Stack:
>  ffff88003f2c8000 ffff88003cfbb690 000000002d0ef63b 0000000000000000
> <0> 0000000000000000 ffff88003fa780d0 ffff88003f2d1e10 ffffffff8156b6b6
> <0> 0000000000000001 0000000100000000 0000000000000000 ffffffff83940dc8
> Call Trace:
>  [<ffffffff8156b6b6>] acpi_ns_walk_namespace+0x11d/0x234
>  [<ffffffff82b070d4>] ? ibm_find_acpi_device+0x0/0xf5
>  [<ffffffff8157b159>] ? acpi_ut_acquire_mutex+0xd9/0x12e
>  [<ffffffff82b070d4>] ? ibm_find_acpi_device+0x0/0xf5
>  [<ffffffff81566dfa>] acpi_walk_namespace+0x105/0x162
>  [<ffffffff81d067bf>] ? acpi_pm_read+0xd/0x3e
>  [<ffffffff82b06f44>] ? ibm_acpiphp_init+0x0/0x190
>  [<ffffffff82b06fa8>] ibm_acpiphp_init+0x64/0x190
>  [<ffffffff810090b4>] do_one_initcall+0x82/0x1a6
>  [<ffffffff810edecc>] ? init_irq_proc+0x77/0x9a
>  [<ffffffff82ad8975>] do_basic_setup+0x5e/0x87
>  [<ffffffff82ad8a26>] kernel_init+0x88/0xe2
>  [<ffffffff8103ddfa>] child_rip+0xa/0x20
>  [<ffffffff8103d7bc>] ? restore_args+0x0/0x30
>  [<ffffffff82ad899e>] ? kernel_init+0x0/0xe2
>  [<ffffffff8103ddf0>] ? child_rip+0x0/0x20
> Code: 48 c7 c2 c0 7b 0b 82 48 c7 c6 95 39 4a 82 48 c7 c7 1a 3c 4a 82 31 c0 e8 02 84 4b ff 31 c0 e9 82 00 00 00 48 8b 45 d8 48 8b 40 30 <c6> 40 03 00 48 8b 45 d8 83 78 18 00 74 5f f6 40 0d 04 74 59 48
> RIP  [<ffffffff82b07130>] ibm_find_acpi_device+0x5c/0xf5
>  RSP <ffff88003f2d1d60>
> CR2: 0000000000000003
> ---[ end trace 5a5d197966b56a2e ]---
> Kernel panic - not syncing: Fatal exception
> Pid: 1, comm: swapper Tainted: G      D    2.6.31-tip #16786
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/ia64/hp/common/sba_iommu.c    |    7 +-
>  drivers/acpi/acpi_memhotplug.c     |   11 +-
>  drivers/acpi/acpica/Makefile       |    2 +-
>  drivers/acpi/acpica/acconfig.h     |    5 -
>  drivers/acpi/acpica/acglobal.h     |    3 +-
>  drivers/acpi/acpica/acinterp.h     |    4 +-
>  drivers/acpi/acpica/acutils.h      |   24 +--
>  drivers/acpi/acpica/evrgnini.c     |   45 ++++-
>  drivers/acpi/acpica/exutils.c      |   53 ++----
>  drivers/acpi/acpica/nsdumpdv.c     |    7 +-
>  drivers/acpi/acpica/nsxfeval.c     |   23 +--
>  drivers/acpi/acpica/nsxfname.c     |  237 +++++-----------------
>  drivers/acpi/acpica/uteval.c       |  375 +++++++++++++++++++++++++++++++----
>  drivers/acpi/acpica/utglobal.c     |   10 +-
>  drivers/acpi/acpica/utids.c        |  382 ------------------------------------
>  drivers/acpi/acpica/utmisc.c       |   28 ---
>  drivers/acpi/container.c           |   11 +-
>  drivers/acpi/dock.c                |    8 +-
>  drivers/acpi/glue.c                |    6 +-
>  drivers/acpi/scan.c                |  151 +++++----------
>  drivers/char/agp/hp-agp.c          |    9 +-
>  drivers/ide/ide-acpi.c             |    5 +-
>  drivers/pci/hotplug/acpiphp_ibm.c  |   12 +-
>  drivers/platform/x86/sony-laptop.c |    7 +-
>  drivers/pnp/pnpacpi/core.c         |    6 +-
>  include/acpi/acpi_bus.h            |    8 +-
>  include/acpi/acpixf.h              |    3 +-
>  include/acpi/actypes.h             |   87 ++++----
>  28 files changed, 628 insertions(+), 901 deletions(-)
> 
> diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
> index 674a837..8cfb001 100644
> --- a/arch/ia64/hp/common/sba_iommu.c
> +++ b/arch/ia64/hp/common/sba_iommu.c
> @@ -2026,21 +2026,24 @@ acpi_sba_ioc_add(struct acpi_device *device)
>         struct ioc *ioc;
>         acpi_status status;
>         u64 hpa, length;
> +       struct acpi_buffer buffer;
>         struct acpi_device_info *dev_info;
> 
>         status = hp_acpi_csr_space(device->handle, &hpa, &length);
>         if (ACPI_FAILURE(status))
>                 return 1;
> 
> -       status = acpi_get_object_info(device->handle, &dev_info);
> +       buffer.length = ACPI_ALLOCATE_LOCAL_BUFFER;
> +       status = acpi_get_object_info(device->handle, &buffer);
>         if (ACPI_FAILURE(status))
>                 return 1;
> +       dev_info = buffer.pointer;
> 
>         /*
>          * For HWP0001, only SBA appears in ACPI namespace.  It encloses the PCI
>          * root bridges, and its CSR space includes the IOC function.
>          */
> -       if (strncmp("HWP0001", dev_info->hardware_id.string, 7) == 0) {
> +       if (strncmp("HWP0001", dev_info->hardware_id.value, 7) == 0) {
>                 hpa += ZX1_IOC_OFFSET;
>                 /* zx1 based systems default to kernel page size iommu pages */
>                 if (!iovp_shift)
> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
> index 28ccdbc..ad9e60a 100644
> --- a/drivers/acpi/acpi_memhotplug.c
> +++ b/drivers/acpi/acpi_memhotplug.c
> @@ -469,23 +469,26 @@ static acpi_status is_memory_device(acpi_handle handle)
>  {
>         char *hardware_id;
>         acpi_status status;
> +       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>         struct acpi_device_info *info;
> 
> -       status = acpi_get_object_info(handle, &info);
> +
> +       status = acpi_get_object_info(handle, &buffer);
>         if (ACPI_FAILURE(status))
>                 return status;
> 
> +       info = buffer.pointer;
>         if (!(info->valid & ACPI_VALID_HID)) {
> -               kfree(info);
> +               kfree(buffer.pointer);
>                 return AE_ERROR;
>         }
> 
> -       hardware_id = info->hardware_id.string;
> +       hardware_id = info->hardware_id.value;
>         if ((hardware_id == NULL) ||
>             (strcmp(hardware_id, ACPI_MEMORY_DEVICE_HID)))
>                 status = AE_ERROR;
> 
> -       kfree(info);
> +       kfree(buffer.pointer);
>         return status;
>  }
> 
> diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
> index e7973bc..0ff924e 100644
> --- a/drivers/acpi/acpica/Makefile
> +++ b/drivers/acpi/acpica/Makefile
> @@ -44,4 +44,4 @@ acpi-y += tbxface.o tbinstal.o tbutils.o tbfind.o tbfadt.o tbxfroot.o
> 
>  acpi-y += utalloc.o utdebug.o uteval.o utinit.o utmisc.o utxface.o \
>                 utcopy.o utdelete.o utglobal.o utmath.o utobject.o \
> -               utstate.o utmutex.o utobject.o utresrc.o utlock.o utids.o
> +               utstate.o utmutex.o utobject.o utresrc.o utlock.o
> diff --git a/drivers/acpi/acpica/acconfig.h b/drivers/acpi/acpica/acconfig.h
> index 8e679ef..581be4b 100644
> --- a/drivers/acpi/acpica/acconfig.h
> +++ b/drivers/acpi/acpica/acconfig.h
> @@ -204,11 +204,6 @@
>  #define ACPI_SMBUS_BUFFER_SIZE          34
>  #define ACPI_IPMI_BUFFER_SIZE           66
> 
> -/* _sx_d and _sx_w control methods */
> -
> -#define ACPI_NUM_sx_d_METHODS           4
> -#define ACPI_NUM_sx_w_METHODS           5
> -
>  /******************************************************************************
>   *
>   * ACPI AML Debugger
> diff --git a/drivers/acpi/acpica/acglobal.h b/drivers/acpi/acpica/acglobal.h
> index 29ba66d..91c6cb1 100644
> --- a/drivers/acpi/acpica/acglobal.h
> +++ b/drivers/acpi/acpica/acglobal.h
> @@ -265,8 +265,7 @@ ACPI_EXTERN u8 acpi_gbl_osi_data;
>  extern u8 acpi_gbl_shutdown;
>  extern u32 acpi_gbl_startup_flags;
>  extern const char *acpi_gbl_sleep_state_names[ACPI_S_STATE_COUNT];
> -extern const char *acpi_gbl_lowest_dstate_names[ACPI_NUM_sx_w_METHODS];
> -extern const char *acpi_gbl_highest_dstate_names[ACPI_NUM_sx_d_METHODS];
> +extern const char *acpi_gbl_highest_dstate_names[4];
>  extern const struct acpi_opcode_info acpi_gbl_aml_op_info[AML_NUM_OPCODES];
>  extern const char *acpi_gbl_region_types[ACPI_NUM_PREDEFINED_REGIONS];
> 
> diff --git a/drivers/acpi/acpica/acinterp.h b/drivers/acpi/acpica/acinterp.h
> index 5db9f29..e8db7a3 100644
> --- a/drivers/acpi/acpica/acinterp.h
> +++ b/drivers/acpi/acpica/acinterp.h
> @@ -461,9 +461,9 @@ void acpi_ex_acquire_global_lock(u32 rule);
> 
>  void acpi_ex_release_global_lock(u32 rule);
> 
> -void acpi_ex_eisa_id_to_string(char *dest, acpi_integer compressed_id);
> +void acpi_ex_eisa_id_to_string(u32 numeric_id, char *out_string);
> 
> -void acpi_ex_integer_to_string(char *dest, acpi_integer value);
> +void acpi_ex_unsigned_integer_to_string(acpi_integer value, char *out_string);
> 
>  /*
>   * exregion - default op_region handlers
> diff --git a/drivers/acpi/acpica/acutils.h b/drivers/acpi/acpica/acutils.h
> index 863a264..14cc666 100644
> --- a/drivers/acpi/acpica/acutils.h
> +++ b/drivers/acpi/acpica/acutils.h
> @@ -324,30 +324,26 @@ acpi_ut_evaluate_object(struct acpi_namespace_node *prefix_node,
>  acpi_status
>  acpi_ut_evaluate_numeric_object(char *object_name,
>                                 struct acpi_namespace_node *device_node,
> -                               acpi_integer *value);
> +                               acpi_integer * address);
> 
>  acpi_status
> -acpi_ut_execute_STA(struct acpi_namespace_node *device_node, u32 *status_flags);
> +acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
> +                   struct acpica_device_id *hid);
> 
>  acpi_status
> -acpi_ut_execute_power_methods(struct acpi_namespace_node *device_node,
> -                             const char **method_names,
> -                             u8 method_count, u8 *out_values);
> +acpi_ut_execute_CID(struct acpi_namespace_node *device_node,
> +                   struct acpi_compatible_id_list **return_cid_list);
> 
> -/*
> - * utids - device ID support
> - */
>  acpi_status
> -acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
> -                   struct acpica_device_id **return_id);
> +acpi_ut_execute_STA(struct acpi_namespace_node *device_node,
> +                   u32 * status_flags);
> 
>  acpi_status
>  acpi_ut_execute_UID(struct acpi_namespace_node *device_node,
> -                   struct acpica_device_id **return_id);
> +                   struct acpica_device_id *uid);
> 
>  acpi_status
> -acpi_ut_execute_CID(struct acpi_namespace_node *device_node,
> -                   struct acpica_device_id_list **return_cid_list);
> +acpi_ut_execute_sxds(struct acpi_namespace_node *device_node, u8 * highest);
> 
>  /*
>   * utlock - reader/writer locks
> @@ -449,8 +445,6 @@ acpi_ut_short_divide(acpi_integer in_dividend,
>   */
>  const char *acpi_ut_validate_exception(acpi_status status);
> 
> -u8 acpi_ut_is_pci_root_bridge(char *id);
> -
>  u8 acpi_ut_is_aml_table(struct acpi_table_header *table);
> 
>  acpi_status acpi_ut_allocate_owner_id(acpi_owner_id * owner_id);
> diff --git a/drivers/acpi/acpica/evrgnini.c b/drivers/acpi/acpica/evrgnini.c
> index cf29c49..284a7be 100644
> --- a/drivers/acpi/acpica/evrgnini.c
> +++ b/drivers/acpi/acpica/evrgnini.c
> @@ -50,6 +50,8 @@
>  ACPI_MODULE_NAME("evrgnini")
> 
>  /* Local prototypes */
> +static u8 acpi_ev_match_pci_root_bridge(char *id);
> +
>  static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
> 
>  /*******************************************************************************
> @@ -330,6 +332,37 @@ acpi_ev_pci_config_region_setup(acpi_handle handle,
> 
>  /*******************************************************************************
>   *
> + * FUNCTION:    acpi_ev_match_pci_root_bridge
> + *
> + * PARAMETERS:  Id              - The HID/CID in string format
> + *
> + * RETURN:      TRUE if the Id is a match for a PCI/PCI-Express Root Bridge
> + *
> + * DESCRIPTION: Determine if the input ID is a PCI Root Bridge ID.
> + *
> + ******************************************************************************/
> +
> +static u8 acpi_ev_match_pci_root_bridge(char *id)
> +{
> +
> +       /*
> +        * Check if this is a PCI root.
> +        * ACPI 3.0+: check for a PCI Express root also.
> +        */
> +       if (!(ACPI_STRNCMP(id,
> +                          PCI_ROOT_HID_STRING,
> +                          sizeof(PCI_ROOT_HID_STRING))) ||
> +           !(ACPI_STRNCMP(id,
> +                          PCI_EXPRESS_ROOT_HID_STRING,
> +                          sizeof(PCI_EXPRESS_ROOT_HID_STRING)))) {
> +               return (TRUE);
> +       }
> +
> +       return (FALSE);
> +}
> +
> +/*******************************************************************************
> + *
>   * FUNCTION:    acpi_ev_is_pci_root_bridge
>   *
>   * PARAMETERS:  Node            - Device node being examined
> @@ -344,10 +377,9 @@ acpi_ev_pci_config_region_setup(acpi_handle handle,
>  static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
>  {
>         acpi_status status;
> -       struct acpica_device_id *hid;
> -       struct acpica_device_id_list *cid;
> +       struct acpica_device_id hid;
> +       struct acpi_compatible_id_list *cid;
>         u32 i;
> -       u8 match;
> 
>         /* Get the _HID and check for a PCI Root Bridge */
> 
> @@ -356,10 +388,7 @@ static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
>                 return (FALSE);
>         }
> 
> -       match = acpi_ut_is_pci_root_bridge(hid->string);
> -       ACPI_FREE(hid);
> -
> -       if (match) {
> +       if (acpi_ev_match_pci_root_bridge(hid.value)) {
>                 return (TRUE);
>         }
> 
> @@ -373,7 +402,7 @@ static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
>         /* Check all _CIDs in the returned list */
> 
>         for (i = 0; i < cid->count; i++) {
> -               if (acpi_ut_is_pci_root_bridge(cid->ids[i].string)) {
> +               if (acpi_ev_match_pci_root_bridge(cid->id[i].value)) {
>                         ACPI_FREE(cid);
>                         return (TRUE);
>                 }
> diff --git a/drivers/acpi/acpica/exutils.c b/drivers/acpi/acpica/exutils.c
> index 7d41f99..87730e9 100644
> --- a/drivers/acpi/acpica/exutils.c
> +++ b/drivers/acpi/acpica/exutils.c
> @@ -358,67 +358,50 @@ static u32 acpi_ex_digits_needed(acpi_integer value, u32 base)
>   *
>   * FUNCTION:    acpi_ex_eisa_id_to_string
>   *
> - * PARAMETERS:  compressed_id   - EISAID to be converted
> + * PARAMETERS:  numeric_id      - EISA ID to be converted
>   *              out_string      - Where to put the converted string (8 bytes)
>   *
>   * RETURN:      None
>   *
> - * DESCRIPTION: Convert a numeric EISAID to string representation. Return
> - *              buffer must be large enough to hold the string. The string
> - *              returned is always exactly of length ACPI_EISAID_STRING_SIZE
> - *              (includes null terminator). The EISAID is always 32 bits.
> + * DESCRIPTION: Convert a numeric EISA ID to string representation
>   *
>   ******************************************************************************/
> 
> -void acpi_ex_eisa_id_to_string(char *out_string, acpi_integer compressed_id)
> +void acpi_ex_eisa_id_to_string(u32 numeric_id, char *out_string)
>  {
> -       u32 swapped_id;
> +       u32 eisa_id;
> 
>         ACPI_FUNCTION_ENTRY();
> 
> -       /* The EISAID should be a 32-bit integer */
> -
> -       if (compressed_id > ACPI_UINT32_MAX) {
> -               ACPI_WARNING((AE_INFO,
> -                             "Expected EISAID is larger than 32 bits: 0x%8.8X%8.8X, truncating",
> -                             ACPI_FORMAT_UINT64(compressed_id)));
> -       }
> -
>         /* Swap ID to big-endian to get contiguous bits */
> 
> -       swapped_id = acpi_ut_dword_byte_swap((u32)compressed_id);
> +       eisa_id = acpi_ut_dword_byte_swap(numeric_id);
> 
> -       /* First 3 bytes are uppercase letters. Next 4 bytes are hexadecimal */
> -
> -       out_string[0] =
> -           (char)(0x40 + (((unsigned long)swapped_id >> 26) & 0x1F));
> -       out_string[1] = (char)(0x40 + ((swapped_id >> 21) & 0x1F));
> -       out_string[2] = (char)(0x40 + ((swapped_id >> 16) & 0x1F));
> -       out_string[3] = acpi_ut_hex_to_ascii_char((acpi_integer)swapped_id, 12);
> -       out_string[4] = acpi_ut_hex_to_ascii_char((acpi_integer)swapped_id, 8);
> -       out_string[5] = acpi_ut_hex_to_ascii_char((acpi_integer)swapped_id, 4);
> -       out_string[6] = acpi_ut_hex_to_ascii_char((acpi_integer)swapped_id, 0);
> +       out_string[0] = (char)('@' + (((unsigned long)eisa_id >> 26) & 0x1f));
> +       out_string[1] = (char)('@' + ((eisa_id >> 21) & 0x1f));
> +       out_string[2] = (char)('@' + ((eisa_id >> 16) & 0x1f));
> +       out_string[3] = acpi_ut_hex_to_ascii_char((acpi_integer) eisa_id, 12);
> +       out_string[4] = acpi_ut_hex_to_ascii_char((acpi_integer) eisa_id, 8);
> +       out_string[5] = acpi_ut_hex_to_ascii_char((acpi_integer) eisa_id, 4);
> +       out_string[6] = acpi_ut_hex_to_ascii_char((acpi_integer) eisa_id, 0);
>         out_string[7] = 0;
>  }
> 
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_ex_integer_to_string
> + * FUNCTION:    acpi_ex_unsigned_integer_to_string
>   *
> - * PARAMETERS:  out_string      - Where to put the converted string. At least
> - *                                21 bytes are needed to hold the largest
> - *                                possible 64-bit integer.
> - *              Value           - Value to be converted
> + * PARAMETERS:  Value           - Value to be converted
> + *              out_string      - Where to put the converted string (8 bytes)
>   *
>   * RETURN:      None, string
>   *
> - * DESCRIPTION: Convert a 64-bit integer to decimal string representation.
> - *              Assumes string buffer is large enough to hold the string. The
> - *              largest string is (ACPI_MAX64_DECIMAL_DIGITS + 1).
> + * DESCRIPTION: Convert a number to string representation. Assumes string
> + *              buffer is large enough to hold the string.
>   *
>   ******************************************************************************/
> 
> -void acpi_ex_integer_to_string(char *out_string, acpi_integer value)
> +void acpi_ex_unsigned_integer_to_string(acpi_integer value, char *out_string)
>  {
>         u32 count;
>         u32 digits_needed;
> diff --git a/drivers/acpi/acpica/nsdumpdv.c b/drivers/acpi/acpica/nsdumpdv.c
> index 0fe87f1..41994fe 100644
> --- a/drivers/acpi/acpica/nsdumpdv.c
> +++ b/drivers/acpi/acpica/nsdumpdv.c
> @@ -70,6 +70,7 @@ static acpi_status
>  acpi_ns_dump_one_device(acpi_handle obj_handle,
>                         u32 level, void *context, void **return_value)
>  {
> +       struct acpi_buffer buffer;
>         struct acpi_device_info *info;
>         acpi_status status;
>         u32 i;
> @@ -79,15 +80,17 @@ acpi_ns_dump_one_device(acpi_handle obj_handle,
>         status =
>             acpi_ns_dump_one_object(obj_handle, level, context, return_value);
> 
> -       status = acpi_get_object_info(obj_handle, &info);
> +       buffer.length = ACPI_ALLOCATE_LOCAL_BUFFER;
> +       status = acpi_get_object_info(obj_handle, &buffer);
>         if (ACPI_SUCCESS(status)) {
> +               info = buffer.pointer;
>                 for (i = 0; i < level; i++) {
>                         ACPI_DEBUG_PRINT_RAW((ACPI_DB_TABLES, " "));
>                 }
> 
>                 ACPI_DEBUG_PRINT_RAW((ACPI_DB_TABLES,
>                                       "    HID: %s, ADR: %8.8X%8.8X, Status: %X\n",
> -                                     info->hardware_id.string,
> +                                     info->hardware_id.value,
>                                       ACPI_FORMAT_UINT64(info->address),
>                                       info->current_status));
>                 ACPI_FREE(info);
> diff --git a/drivers/acpi/acpica/nsxfeval.c b/drivers/acpi/acpica/nsxfeval.c
> index eaacbf4..18d0ca1 100644
> --- a/drivers/acpi/acpica/nsxfeval.c
> +++ b/drivers/acpi/acpica/nsxfeval.c
> @@ -538,11 +538,10 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
>         acpi_status status;
>         struct acpi_namespace_node *node;
>         u32 flags;
> -       struct acpica_device_id *hid;
> -       struct acpica_device_id_list *cid;
> +       struct acpica_device_id hid;
> +       struct acpi_compatible_id_list *cid;
>         u32 i;
> -       u8 found;
> -       int no_match;
> +       int found;
> 
>         status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
>         if (ACPI_FAILURE(status)) {
> @@ -586,14 +585,10 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
>                         return (AE_CTRL_DEPTH);
>                 }
> 
> -               no_match = ACPI_STRCMP(hid->string, info->hid);
> -               ACPI_FREE(hid);
> +               if (ACPI_STRNCMP(hid.value, info->hid, sizeof(hid.value)) != 0) {
> +
> +                       /* Get the list of Compatible IDs */
> 
> -               if (no_match) {
> -                       /*
> -                        * HID does not match, attempt match within the
> -                        * list of Compatible IDs (CIDs)
> -                        */
>                         status = acpi_ut_execute_CID(node, &cid);
>                         if (status == AE_NOT_FOUND) {
>                                 return (AE_OK);
> @@ -605,8 +600,10 @@ acpi_ns_get_device_callback(acpi_handle obj_handle,
> 
>                         found = 0;
>                         for (i = 0; i < cid->count; i++) {
> -                               if (ACPI_STRCMP(cid->ids[i].string, info->hid)
> -                                   == 0) {
> +                               if (ACPI_STRNCMP(cid->id[i].value, info->hid,
> +                                                sizeof(struct
> +                                                       acpi_compatible_id)) ==
> +                                   0) {
>                                         found = 1;
>                                         break;
>                                 }
> diff --git a/drivers/acpi/acpica/nsxfname.c b/drivers/acpi/acpica/nsxfname.c
> index ddc84af..f23593d 100644
> --- a/drivers/acpi/acpica/nsxfname.c
> +++ b/drivers/acpi/acpica/nsxfname.c
> @@ -51,11 +51,6 @@
>  #define _COMPONENT          ACPI_NAMESPACE
>  ACPI_MODULE_NAME("nsxfname")
> 
> -/* Local prototypes */
> -static char *acpi_ns_copy_device_id(struct acpica_device_id *dest,
> -                                   struct acpica_device_id *source,
> -                                   char *string_area);
> -
>  /******************************************************************************
>   *
>   * FUNCTION:    acpi_get_handle
> @@ -73,7 +68,6 @@ static char *acpi_ns_copy_device_id(struct acpica_device_id *dest,
>   *              namespace handle.
>   *
>   ******************************************************************************/
> -
>  acpi_status
>  acpi_get_handle(acpi_handle parent,
>                 acpi_string pathname, acpi_handle * ret_handle)
> @@ -216,38 +210,10 @@ ACPI_EXPORT_SYMBOL(acpi_get_name)
> 
>  /******************************************************************************
>   *
> - * FUNCTION:    acpi_ns_copy_device_id
> - *
> - * PARAMETERS:  Dest                - Pointer to the destination DEVICE_ID
> - *              Source              - Pointer to the source DEVICE_ID
> - *              string_area         - Pointer to where to copy the dest string
> - *
> - * RETURN:      Pointer to the next string area
> - *
> - * DESCRIPTION: Copy a single DEVICE_ID, including the string data.
> - *
> - ******************************************************************************/
> -static char *acpi_ns_copy_device_id(struct acpica_device_id *dest,
> -                                   struct acpica_device_id *source,
> -                                   char *string_area)
> -{
> -       /* Create the destination DEVICE_ID */
> -
> -       dest->string = string_area;
> -       dest->length = source->length;
> -
> -       /* Copy actual string and return a pointer to the next string area */
> -
> -       ACPI_MEMCPY(string_area, source->string, source->length);
> -       return (string_area + source->length);
> -}
> -
> -/******************************************************************************
> - *
>   * FUNCTION:    acpi_get_object_info
>   *
> - * PARAMETERS:  Handle              - Object Handle
> - *              return_buffer       - Where the info is returned
> + * PARAMETERS:  Handle          - Object Handle
> + *              Buffer          - Where the info is returned
>   *
>   * RETURN:      Status
>   *
> @@ -255,37 +221,33 @@ static char *acpi_ns_copy_device_id(struct acpica_device_id *dest,
>   *              namespace node and possibly by running several standard
>   *              control methods (Such as in the case of a device.)
>   *
> - * For Device and Processor objects, run the Device _HID, _UID, _CID, _STA,
> - * _ADR, _sx_w, and _sx_d methods.
> - *
> - * Note: Allocates the return buffer, must be freed by the caller.
> - *
>   ******************************************************************************/
> -
>  acpi_status
> -acpi_get_object_info(acpi_handle handle,
> -                    struct acpi_device_info **return_buffer)
> +acpi_get_object_info(acpi_handle handle, struct acpi_buffer * buffer)
>  {
> +       acpi_status status;
>         struct acpi_namespace_node *node;
>         struct acpi_device_info *info;
> -       struct acpica_device_id_list *cid_list = NULL;
> -       struct acpica_device_id *hid = NULL;
> -       struct acpica_device_id *uid = NULL;
> -       char *next_id_string;
> -       acpi_object_type type;
> -       acpi_name name;
> -       u8 param_count = 0;
> -       u8 valid = 0;
> -       u32 info_size;
> -       u32 i;
> -       acpi_status status;
> +       struct acpi_device_info *return_info;
> +       struct acpi_compatible_id_list *cid_list = NULL;
> +       acpi_size size;
> 
>         /* Parameter validation */
> 
> -       if (!handle || !return_buffer) {
> +       if (!handle || !buffer) {
>                 return (AE_BAD_PARAMETER);
>         }
> 
> +       status = acpi_ut_validate_buffer(buffer);
> +       if (ACPI_FAILURE(status)) {
> +               return (status);
> +       }
> +
> +       info = ACPI_ALLOCATE_ZEROED(sizeof(struct acpi_device_info));
> +       if (!info) {
> +               return (AE_NO_MEMORY);
> +       }
> +
>         status = acpi_ut_acquire_mutex(ACPI_MTX_NAMESPACE);
>         if (ACPI_FAILURE(status)) {
>                 goto cleanup;
> @@ -294,91 +256,66 @@ acpi_get_object_info(acpi_handle handle,
>         node = acpi_ns_map_handle_to_node(handle);
>         if (!node) {
>                 (void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
> -               return (AE_BAD_PARAMETER);
> +               status = AE_BAD_PARAMETER;
> +               goto cleanup;
>         }
> 
> -       /* Get the namespace node data while the namespace is locked */
> +       /* Init return structure */
> +
> +       size = sizeof(struct acpi_device_info);
> 
> -       info_size = sizeof(struct acpi_device_info);
> -       type = node->type;
> -       name = node->name.integer;
> +       info->type = node->type;
> +       info->name = node->name.integer;
> +       info->valid = 0;
> 
>         if (node->type == ACPI_TYPE_METHOD) {
> -               param_count = node->object->method.param_count;
> +               info->param_count = node->object->method.param_count;
>         }
> 
>         status = acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
>         if (ACPI_FAILURE(status)) {
> -               return (status);
> +               goto cleanup;
>         }
> 
> -       if ((type == ACPI_TYPE_DEVICE) || (type == ACPI_TYPE_PROCESSOR)) {
> +       /* If not a device, we are all done */
> +
> +       if (info->type == ACPI_TYPE_DEVICE) {
>                 /*
> -                * Get extra info for ACPI Device/Processor objects only:
> -                * Run the Device _HID, _UID, and _CID methods.
> +                * Get extra info for ACPI Devices objects only:
> +                * Run the Device _HID, _UID, _CID, _STA, _ADR and _sx_d methods.
>                  *
>                  * Note: none of these methods are required, so they may or may
> -                * not be present for this device. The Info->Valid bitfield is used
> -                * to indicate which methods were found and run successfully.
> +                * not be present for this device.  The Info->Valid bitfield is used
> +                * to indicate which methods were found and ran successfully.
>                  */
> 
>                 /* Execute the Device._HID method */
> 
> -               status = acpi_ut_execute_HID(node, &hid);
> +               status = acpi_ut_execute_HID(node, &info->hardware_id);
>                 if (ACPI_SUCCESS(status)) {
> -                       info_size += hid->length;
> -                       valid |= ACPI_VALID_HID;
> +                       info->valid |= ACPI_VALID_HID;
>                 }
> 
>                 /* Execute the Device._UID method */
> 
> -               status = acpi_ut_execute_UID(node, &uid);
> +               status = acpi_ut_execute_UID(node, &info->unique_id);
>                 if (ACPI_SUCCESS(status)) {
> -                       info_size += uid->length;
> -                       valid |= ACPI_VALID_UID;
> +                       info->valid |= ACPI_VALID_UID;
>                 }
> 
>                 /* Execute the Device._CID method */
> 
>                 status = acpi_ut_execute_CID(node, &cid_list);
>                 if (ACPI_SUCCESS(status)) {
> -
> -                       /* Add size of CID strings and CID pointer array */
> -
> -                       info_size +=
> -                           (cid_list->list_size -
> -                            sizeof(struct acpica_device_id_list));
> -                       valid |= ACPI_VALID_CID;
> +                       size += cid_list->size;
> +                       info->valid |= ACPI_VALID_CID;
>                 }
> -       }
> -
> -       /*
> -        * Now that we have the variable-length data, we can allocate the
> -        * return buffer
> -        */
> -       info = ACPI_ALLOCATE_ZEROED(info_size);
> -       if (!info) {
> -               status = AE_NO_MEMORY;
> -               goto cleanup;
> -       }
> -
> -       /* Get the fixed-length data */
> -
> -       if ((type == ACPI_TYPE_DEVICE) || (type == ACPI_TYPE_PROCESSOR)) {
> -               /*
> -                * Get extra info for ACPI Device/Processor objects only:
> -                * Run the _STA, _ADR and, sx_w, and _sx_d methods.
> -                *
> -                * Note: none of these methods are required, so they may or may
> -                * not be present for this device. The Info->Valid bitfield is used
> -                * to indicate which methods were found and run successfully.
> -                */
> 
>                 /* Execute the Device._STA method */
> 
>                 status = acpi_ut_execute_STA(node, &info->current_status);
>                 if (ACPI_SUCCESS(status)) {
> -                       valid |= ACPI_VALID_STA;
> +                       info->valid |= ACPI_VALID_STA;
>                 }
> 
>                 /* Execute the Device._ADR method */
> @@ -386,100 +323,36 @@ acpi_get_object_info(acpi_handle handle,
>                 status = acpi_ut_evaluate_numeric_object(METHOD_NAME__ADR, node,
>                                                          &info->address);
>                 if (ACPI_SUCCESS(status)) {
> -                       valid |= ACPI_VALID_ADR;
> -               }
> -
> -               /* Execute the Device._sx_w methods */
> -
> -               status = acpi_ut_execute_power_methods(node,
> -                                                      acpi_gbl_lowest_dstate_names,
> -                                                      ACPI_NUM_sx_w_METHODS,
> -                                                      info->lowest_dstates);
> -               if (ACPI_SUCCESS(status)) {
> -                       valid |= ACPI_VALID_SXWS;
> +                       info->valid |= ACPI_VALID_ADR;
>                 }
> 
>                 /* Execute the Device._sx_d methods */
> 
> -               status = acpi_ut_execute_power_methods(node,
> -                                                      acpi_gbl_highest_dstate_names,
> -                                                      ACPI_NUM_sx_d_METHODS,
> -                                                      info->highest_dstates);
> +               status = acpi_ut_execute_sxds(node, info->highest_dstates);
>                 if (ACPI_SUCCESS(status)) {
> -                       valid |= ACPI_VALID_SXDS;
> +                       info->valid |= ACPI_VALID_SXDS;
>                 }
>         }
> 
> -       /*
> -        * Create a pointer to the string area of the return buffer.
> -        * Point to the end of the base struct acpi_device_info structure.
> -        */
> -       next_id_string = ACPI_CAST_PTR(char, info->compatible_id_list.ids);
> -       if (cid_list) {
> -
> -               /* Point past the CID DEVICE_ID array */
> +       /* Validate/Allocate/Clear caller buffer */
> 
> -               next_id_string +=
> -                   ((acpi_size) cid_list->count *
> -                    sizeof(struct acpica_device_id));
> +       status = acpi_ut_initialize_buffer(buffer, size);
> +       if (ACPI_FAILURE(status)) {
> +               goto cleanup;
>         }
> 
> -       /*
> -        * Copy the HID, UID, and CIDs to the return buffer. The variable-length
> -        * strings are copied to the reserved area at the end of the buffer.
> -        *
> -        * For HID and CID, check if the ID is a PCI Root Bridge.
> -        */
> -       if (hid) {
> -               next_id_string = acpi_ns_copy_device_id(&info->hardware_id,
> -                                                       hid, next_id_string);
> -
> -               if (acpi_ut_is_pci_root_bridge(hid->string)) {
> -                       info->flags |= ACPI_PCI_ROOT_BRIDGE;
> -               }
> -       }
> +       /* Populate the return buffer */
> 
> -       if (uid) {
> -               next_id_string = acpi_ns_copy_device_id(&info->unique_id,
> -                                                       uid, next_id_string);
> -       }
> +       return_info = buffer->pointer;
> +       ACPI_MEMCPY(return_info, info, sizeof(struct acpi_device_info));
> 
>         if (cid_list) {
> -               info->compatible_id_list.count = cid_list->count;
> -               info->compatible_id_list.list_size = cid_list->list_size;
> -
> -               /* Copy each CID */
> -
> -               for (i = 0; i < cid_list->count; i++) {
> -                       next_id_string =
> -                           acpi_ns_copy_device_id(&info->compatible_id_list.
> -                                                  ids[i], &cid_list->ids[i],
> -                                                  next_id_string);
> -
> -                       if (acpi_ut_is_pci_root_bridge(cid_list->ids[i].string)) {
> -                               info->flags |= ACPI_PCI_ROOT_BRIDGE;
> -                       }
> -               }
> +               ACPI_MEMCPY(&return_info->compatibility_id, cid_list,
> +                           cid_list->size);
>         }
> 
> -       /* Copy the fixed-length data */
> -
> -       info->info_size = info_size;
> -       info->type = type;
> -       info->name = name;
> -       info->param_count = param_count;
> -       info->valid = valid;
> -
> -       *return_buffer = info;
> -       status = AE_OK;
> -
>        cleanup:
> -       if (hid) {
> -               ACPI_FREE(hid);
> -       }
> -       if (uid) {
> -               ACPI_FREE(uid);
> -       }
> +       ACPI_FREE(info);
>         if (cid_list) {
>                 ACPI_FREE(cid_list);
>         }
> diff --git a/drivers/acpi/acpica/uteval.c b/drivers/acpi/acpica/uteval.c
> index 5d54e36..a4734ac 100644
> --- a/drivers/acpi/acpica/uteval.c
> +++ b/drivers/acpi/acpica/uteval.c
> @@ -44,10 +44,19 @@
>  #include <acpi/acpi.h>
>  #include "accommon.h"
>  #include "acnamesp.h"
> +#include "acinterp.h"
> 
>  #define _COMPONENT          ACPI_UTILITIES
>  ACPI_MODULE_NAME("uteval")
> 
> +/* Local prototypes */
> +static void
> +acpi_ut_copy_id_string(char *destination, char *source, acpi_size max_length);
> +
> +static acpi_status
> +acpi_ut_translate_one_cid(union acpi_operand_object *obj_desc,
> +                         struct acpi_compatible_id *one_cid);
> +
>  /*
>   * Strings supported by the _OSI predefined (internal) method.
>   *
> @@ -207,7 +216,7 @@ acpi_status acpi_osi_invalidate(char *interface)
>   * RETURN:      Status
>   *
>   * DESCRIPTION: Evaluates a namespace object and verifies the type of the
> - *              return object. Common code that simplifies accessing objects
> + *              return object.  Common code that simplifies accessing objects
>   *              that have required return objects of fixed types.
>   *
>   *              NOTE: Internal function, no parameter validation
> @@ -292,7 +301,7 @@ acpi_ut_evaluate_object(struct acpi_namespace_node *prefix_node,
> 
>         if ((acpi_gbl_enable_interpreter_slack) && (!expected_return_btypes)) {
>                 /*
> -                * We received a return object, but one was not expected. This can
> +                * We received a return object, but one was not expected.  This can
>                  * happen frequently if the "implicit return" feature is enabled.
>                  * Just delete the return object and return AE_OK.
>                  */
> @@ -334,12 +343,12 @@ acpi_ut_evaluate_object(struct acpi_namespace_node *prefix_node,
>   *
>   * PARAMETERS:  object_name         - Object name to be evaluated
>   *              device_node         - Node for the device
> - *              Value               - Where the value is returned
> + *              Address             - Where the value is returned
>   *
>   * RETURN:      Status
>   *
>   * DESCRIPTION: Evaluates a numeric namespace object for a selected device
> - *              and stores result in *Value.
> + *              and stores result in *Address.
>   *
>   *              NOTE: Internal function, no parameter validation
>   *
> @@ -348,7 +357,7 @@ acpi_ut_evaluate_object(struct acpi_namespace_node *prefix_node,
>  acpi_status
>  acpi_ut_evaluate_numeric_object(char *object_name,
>                                 struct acpi_namespace_node *device_node,
> -                               acpi_integer *value)
> +                               acpi_integer * address)
>  {
>         union acpi_operand_object *obj_desc;
>         acpi_status status;
> @@ -363,7 +372,295 @@ acpi_ut_evaluate_numeric_object(char *object_name,
> 
>         /* Get the returned Integer */
> 
> -       *value = obj_desc->integer.value;
> +       *address = obj_desc->integer.value;
> +
> +       /* On exit, we must delete the return object */
> +
> +       acpi_ut_remove_reference(obj_desc);
> +       return_ACPI_STATUS(status);
> +}
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_ut_copy_id_string
> + *
> + * PARAMETERS:  Destination         - Where to copy the string
> + *              Source              - Source string
> + *              max_length          - Length of the destination buffer
> + *
> + * RETURN:      None
> + *
> + * DESCRIPTION: Copies an ID string for the _HID, _CID, and _UID methods.
> + *              Performs removal of a leading asterisk if present -- workaround
> + *              for a known issue on a bunch of machines.
> + *
> + ******************************************************************************/
> +
> +static void
> +acpi_ut_copy_id_string(char *destination, char *source, acpi_size max_length)
> +{
> +
> +       /*
> +        * Workaround for ID strings that have a leading asterisk. This construct
> +        * is not allowed by the ACPI specification  (ID strings must be
> +        * alphanumeric), but enough existing machines have this embedded in their
> +        * ID strings that the following code is useful.
> +        */
> +       if (*source == '*') {
> +               source++;
> +       }
> +
> +       /* Do the actual copy */
> +
> +       ACPI_STRNCPY(destination, source, max_length);
> +}
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_ut_execute_HID
> + *
> + * PARAMETERS:  device_node         - Node for the device
> + *              Hid                 - Where the HID is returned
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Executes the _HID control method that returns the hardware
> + *              ID of the device.
> + *
> + *              NOTE: Internal function, no parameter validation
> + *
> + ******************************************************************************/
> +
> +acpi_status
> +acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
> +                   struct acpica_device_id *hid)
> +{
> +       union acpi_operand_object *obj_desc;
> +       acpi_status status;
> +
> +       ACPI_FUNCTION_TRACE(ut_execute_HID);
> +
> +       status = acpi_ut_evaluate_object(device_node, METHOD_NAME__HID,
> +                                        ACPI_BTYPE_INTEGER | ACPI_BTYPE_STRING,
> +                                        &obj_desc);
> +       if (ACPI_FAILURE(status)) {
> +               return_ACPI_STATUS(status);
> +       }
> +
> +       if (obj_desc->common.type == ACPI_TYPE_INTEGER) {
> +
> +               /* Convert the Numeric HID to string */
> +
> +               acpi_ex_eisa_id_to_string((u32) obj_desc->integer.value,
> +                                         hid->value);
> +       } else {
> +               /* Copy the String HID from the returned object */
> +
> +               acpi_ut_copy_id_string(hid->value, obj_desc->string.pointer,
> +                                      sizeof(hid->value));
> +       }
> +
> +       /* On exit, we must delete the return object */
> +
> +       acpi_ut_remove_reference(obj_desc);
> +       return_ACPI_STATUS(status);
> +}
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_ut_translate_one_cid
> + *
> + * PARAMETERS:  obj_desc            - _CID object, must be integer or string
> + *              one_cid             - Where the CID string is returned
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Return a numeric or string _CID value as a string.
> + *              (Compatible ID)
> + *
> + *              NOTE:  Assumes a maximum _CID string length of
> + *                     ACPI_MAX_CID_LENGTH.
> + *
> + ******************************************************************************/
> +
> +static acpi_status
> +acpi_ut_translate_one_cid(union acpi_operand_object *obj_desc,
> +                         struct acpi_compatible_id *one_cid)
> +{
> +
> +       switch (obj_desc->common.type) {
> +       case ACPI_TYPE_INTEGER:
> +
> +               /* Convert the Numeric CID to string */
> +
> +               acpi_ex_eisa_id_to_string((u32) obj_desc->integer.value,
> +                                         one_cid->value);
> +               return (AE_OK);
> +
> +       case ACPI_TYPE_STRING:
> +
> +               if (obj_desc->string.length > ACPI_MAX_CID_LENGTH) {
> +                       return (AE_AML_STRING_LIMIT);
> +               }
> +
> +               /* Copy the String CID from the returned object */
> +
> +               acpi_ut_copy_id_string(one_cid->value, obj_desc->string.pointer,
> +                                      ACPI_MAX_CID_LENGTH);
> +               return (AE_OK);
> +
> +       default:
> +
> +               return (AE_TYPE);
> +       }
> +}
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_ut_execute_CID
> + *
> + * PARAMETERS:  device_node         - Node for the device
> + *              return_cid_list     - Where the CID list is returned
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Executes the _CID control method that returns one or more
> + *              compatible hardware IDs for the device.
> + *
> + *              NOTE: Internal function, no parameter validation
> + *
> + ******************************************************************************/
> +
> +acpi_status
> +acpi_ut_execute_CID(struct acpi_namespace_node * device_node,
> +                   struct acpi_compatible_id_list ** return_cid_list)
> +{
> +       union acpi_operand_object *obj_desc;
> +       acpi_status status;
> +       u32 count;
> +       u32 size;
> +       struct acpi_compatible_id_list *cid_list;
> +       u32 i;
> +
> +       ACPI_FUNCTION_TRACE(ut_execute_CID);
> +
> +       /* Evaluate the _CID method for this device */
> +
> +       status = acpi_ut_evaluate_object(device_node, METHOD_NAME__CID,
> +                                        ACPI_BTYPE_INTEGER | ACPI_BTYPE_STRING
> +                                        | ACPI_BTYPE_PACKAGE, &obj_desc);
> +       if (ACPI_FAILURE(status)) {
> +               return_ACPI_STATUS(status);
> +       }
> +
> +       /* Get the number of _CIDs returned */
> +
> +       count = 1;
> +       if (obj_desc->common.type == ACPI_TYPE_PACKAGE) {
> +               count = obj_desc->package.count;
> +       }
> +
> +       /* Allocate a worst-case buffer for the _CIDs */
> +
> +       size = (((count - 1) * sizeof(struct acpi_compatible_id)) +
> +               sizeof(struct acpi_compatible_id_list));
> +
> +       cid_list = ACPI_ALLOCATE_ZEROED((acpi_size) size);
> +       if (!cid_list) {
> +               return_ACPI_STATUS(AE_NO_MEMORY);
> +       }
> +
> +       /* Init CID list */
> +
> +       cid_list->count = count;
> +       cid_list->size = size;
> +
> +       /*
> +        *  A _CID can return either a single compatible ID or a package of
> +        *  compatible IDs.  Each compatible ID can be one of the following:
> +        *  1) Integer (32 bit compressed EISA ID) or
> +        *  2) String (PCI ID format, e.g. "PCI\VEN_vvvv&DEV_dddd&SUBSYS_ssssssss")
> +        */
> +
> +       /* The _CID object can be either a single CID or a package (list) of CIDs */
> +
> +       if (obj_desc->common.type == ACPI_TYPE_PACKAGE) {
> +
> +               /* Translate each package element */
> +
> +               for (i = 0; i < count; i++) {
> +                       status =
> +                           acpi_ut_translate_one_cid(obj_desc->package.
> +                                                     elements[i],
> +                                                     &cid_list->id[i]);
> +                       if (ACPI_FAILURE(status)) {
> +                               break;
> +                       }
> +               }
> +       } else {
> +               /* Only one CID, translate to a string */
> +
> +               status = acpi_ut_translate_one_cid(obj_desc, cid_list->id);
> +       }
> +
> +       /* Cleanup on error */
> +
> +       if (ACPI_FAILURE(status)) {
> +               ACPI_FREE(cid_list);
> +       } else {
> +               *return_cid_list = cid_list;
> +       }
> +
> +       /* On exit, we must delete the _CID return object */
> +
> +       acpi_ut_remove_reference(obj_desc);
> +       return_ACPI_STATUS(status);
> +}
> +
> +/*******************************************************************************
> + *
> + * FUNCTION:    acpi_ut_execute_UID
> + *
> + * PARAMETERS:  device_node         - Node for the device
> + *              Uid                 - Where the UID is returned
> + *
> + * RETURN:      Status
> + *
> + * DESCRIPTION: Executes the _UID control method that returns the hardware
> + *              ID of the device.
> + *
> + *              NOTE: Internal function, no parameter validation
> + *
> + ******************************************************************************/
> +
> +acpi_status
> +acpi_ut_execute_UID(struct acpi_namespace_node *device_node,
> +                   struct acpica_device_id *uid)
> +{
> +       union acpi_operand_object *obj_desc;
> +       acpi_status status;
> +
> +       ACPI_FUNCTION_TRACE(ut_execute_UID);
> +
> +       status = acpi_ut_evaluate_object(device_node, METHOD_NAME__UID,
> +                                        ACPI_BTYPE_INTEGER | ACPI_BTYPE_STRING,
> +                                        &obj_desc);
> +       if (ACPI_FAILURE(status)) {
> +               return_ACPI_STATUS(status);
> +       }
> +
> +       if (obj_desc->common.type == ACPI_TYPE_INTEGER) {
> +
> +               /* Convert the Numeric UID to string */
> +
> +               acpi_ex_unsigned_integer_to_string(obj_desc->integer.value,
> +                                                  uid->value);
> +       } else {
> +               /* Copy the String UID from the returned object */
> +
> +               acpi_ut_copy_id_string(uid->value, obj_desc->string.pointer,
> +                                      sizeof(uid->value));
> +       }
> 
>         /* On exit, we must delete the return object */
> 
> @@ -422,64 +719,60 @@ acpi_ut_execute_STA(struct acpi_namespace_node *device_node, u32 * flags)
> 
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_ut_execute_power_methods
> + * FUNCTION:    acpi_ut_execute_Sxds
>   *
>   * PARAMETERS:  device_node         - Node for the device
> - *              method_names        - Array of power method names
> - *              method_count        - Number of methods to execute
> - *              out_values          - Where the power method values are returned
> + *              Flags               - Where the status flags are returned
>   *
> - * RETURN:      Status, out_values
> + * RETURN:      Status
>   *
> - * DESCRIPTION: Executes the specified power methods for the device and returns
> - *              the result(s).
> + * DESCRIPTION: Executes _STA for selected device and stores results in
> + *              *Flags.
>   *
>   *              NOTE: Internal function, no parameter validation
>   *
> -******************************************************************************/
> + ******************************************************************************/
> 
>  acpi_status
> -acpi_ut_execute_power_methods(struct acpi_namespace_node *device_node,
> -                             const char **method_names,
> -                             u8 method_count, u8 *out_values)
> +acpi_ut_execute_sxds(struct acpi_namespace_node *device_node, u8 * highest)
>  {
>         union acpi_operand_object *obj_desc;
>         acpi_status status;
> -       acpi_status final_status = AE_NOT_FOUND;
>         u32 i;
> 
> -       ACPI_FUNCTION_TRACE(ut_execute_power_methods);
> +       ACPI_FUNCTION_TRACE(ut_execute_sxds);
> 
> -       for (i = 0; i < method_count; i++) {
> -               /*
> -                * Execute the power method (_sx_d or _sx_w). The only allowable
> -                * return type is an Integer.
> -                */
> +       for (i = 0; i < 4; i++) {
> +               highest[i] = 0xFF;
>                 status = acpi_ut_evaluate_object(device_node,
>                                                  ACPI_CAST_PTR(char,
> -                                                              method_names[i]),
> +                                                              acpi_gbl_highest_dstate_names
> +                                                              [i]),
>                                                  ACPI_BTYPE_INTEGER, &obj_desc);
> -               if (ACPI_SUCCESS(status)) {
> -                       out_values[i] = (u8)obj_desc->integer.value;
> +               if (ACPI_FAILURE(status)) {
> +                       if (status != AE_NOT_FOUND) {
> +                               ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
> +                                                 "%s on Device %4.4s, %s\n",
> +                                                 ACPI_CAST_PTR(char,
> +                                                               acpi_gbl_highest_dstate_names
> +                                                               [i]),
> +                                                 acpi_ut_get_node_name
> +                                                 (device_node),
> +                                                 acpi_format_exception
> +                                                 (status)));
> +
> +                               return_ACPI_STATUS(status);
> +                       }
> +               } else {
> +                       /* Extract the Dstate value */
> +
> +                       highest[i] = (u8) obj_desc->integer.value;
> 
>                         /* Delete the return object */
> 
>                         acpi_ut_remove_reference(obj_desc);
> -                       final_status = AE_OK;   /* At least one value is valid */
> -                       continue;
>                 }
> -
> -               out_values[i] = ACPI_UINT8_MAX;
> -               if (status == AE_NOT_FOUND) {
> -                       continue;       /* Ignore if not found */
> -               }
> -
> -               ACPI_DEBUG_PRINT((ACPI_DB_EXEC,
> -                                 "Failed %s on Device %4.4s, %s\n",
> -                                 ACPI_CAST_PTR(char, method_names[i]),
> -                                 acpi_ut_get_node_name(device_node),
> -                                 acpi_format_exception(status)));
>         }
> 
> -       return_ACPI_STATUS(final_status);
> +       return_ACPI_STATUS(AE_OK);
>  }
> diff --git a/drivers/acpi/acpica/utglobal.c b/drivers/acpi/acpica/utglobal.c
> index 3f2c68f..1d83dd5 100644
> --- a/drivers/acpi/acpica/utglobal.c
> +++ b/drivers/acpi/acpica/utglobal.c
> @@ -90,15 +90,7 @@ const char *acpi_gbl_sleep_state_names[ACPI_S_STATE_COUNT] = {
>         "\\_S5_"
>  };
> 
> -const char *acpi_gbl_lowest_dstate_names[ACPI_NUM_sx_w_METHODS] = {
> -       "_S0W",
> -       "_S1W",
> -       "_S2W",
> -       "_S3W",
> -       "_S4W"
> -};
> -
> -const char *acpi_gbl_highest_dstate_names[ACPI_NUM_sx_d_METHODS] = {
> +const char *acpi_gbl_highest_dstate_names[4] = {
>         "_S1D",
>         "_S2D",
>         "_S3D",
> diff --git a/drivers/acpi/acpica/utids.c b/drivers/acpi/acpica/utids.c
> deleted file mode 100644
> index 52eaae4..0000000
> --- a/drivers/acpi/acpica/utids.c
> +++ /dev/null
> @@ -1,382 +0,0 @@
> -/******************************************************************************
> - *
> - * Module Name: utids - support for device IDs - HID, UID, CID
> - *
> - *****************************************************************************/
> -
> -/*
> - * Copyright (C) 2000 - 2009, Intel Corp.
> - * All rights reserved.
> - *
> - * Redistribution and use in source and binary forms, with or without
> - * modification, are permitted provided that the following conditions
> - * are met:
> - * 1. Redistributions of source code must retain the above copyright
> - *    notice, this list of conditions, and the following disclaimer,
> - *    without modification.
> - * 2. Redistributions in binary form must reproduce at minimum a disclaimer
> - *    substantially similar to the "NO WARRANTY" disclaimer below
> - *    ("Disclaimer") and any redistribution must be conditioned upon
> - *    including a substantially similar Disclaimer requirement for further
> - *    binary redistribution.
> - * 3. Neither the names of the above-listed copyright holders nor the names
> - *    of any contributors may be used to endorse or promote products derived
> - *    from this software without specific prior written permission.
> - *
> - * Alternatively, this software may be distributed under the terms of the
> - * GNU General Public License ("GPL") version 2 as published by the Free
> - * Software Foundation.
> - *
> - * NO WARRANTY
> - * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
> - * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
> - * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
> - * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
> - * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> - * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
> - * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
> - * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
> - * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
> - * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
> - * POSSIBILITY OF SUCH DAMAGES.
> - */
> -
> -#include <acpi/acpi.h>
> -#include "accommon.h"
> -#include "acinterp.h"
> -
> -#define _COMPONENT          ACPI_UTILITIES
> -ACPI_MODULE_NAME("utids")
> -
> -/* Local prototypes */
> -static void acpi_ut_copy_id_string(char *destination, char *source);
> -
> -/*******************************************************************************
> - *
> - * FUNCTION:    acpi_ut_copy_id_string
> - *
> - * PARAMETERS:  Destination         - Where to copy the string
> - *              Source              - Source string
> - *
> - * RETURN:      None
> - *
> - * DESCRIPTION: Copies an ID string for the _HID, _CID, and _UID methods.
> - *              Performs removal of a leading asterisk if present -- workaround
> - *              for a known issue on a bunch of machines.
> - *
> - ******************************************************************************/
> -
> -static void acpi_ut_copy_id_string(char *destination, char *source)
> -{
> -
> -       /*
> -        * Workaround for ID strings that have a leading asterisk. This construct
> -        * is not allowed by the ACPI specification  (ID strings must be
> -        * alphanumeric), but enough existing machines have this embedded in their
> -        * ID strings that the following code is useful.
> -        */
> -       if (*source == '*') {
> -               source++;
> -       }
> -
> -       /* Do the actual copy */
> -
> -       ACPI_STRCPY(destination, source);
> -}
> -
> -/*******************************************************************************
> - *
> - * FUNCTION:    acpi_ut_execute_HID
> - *
> - * PARAMETERS:  device_node         - Node for the device
> - *              return_id           - Where the string HID is returned
> - *
> - * RETURN:      Status
> - *
> - * DESCRIPTION: Executes the _HID control method that returns the hardware
> - *              ID of the device. The HID is either an 32-bit encoded EISAID
> - *              Integer or a String. A string is always returned. An EISAID
> - *              is converted to a string.
> - *
> - *              NOTE: Internal function, no parameter validation
> - *
> - ******************************************************************************/
> -
> -acpi_status
> -acpi_ut_execute_HID(struct acpi_namespace_node *device_node,
> -                   struct acpica_device_id **return_id)
> -{
> -       union acpi_operand_object *obj_desc;
> -       struct acpica_device_id *hid;
> -       u32 length;
> -       acpi_status status;
> -
> -       ACPI_FUNCTION_TRACE(ut_execute_HID);
> -
> -       status = acpi_ut_evaluate_object(device_node, METHOD_NAME__HID,
> -                                        ACPI_BTYPE_INTEGER | ACPI_BTYPE_STRING,
> -                                        &obj_desc);
> -       if (ACPI_FAILURE(status)) {
> -               return_ACPI_STATUS(status);
> -       }
> -
> -       /* Get the size of the String to be returned, includes null terminator */
> -
> -       if (obj_desc->common.type == ACPI_TYPE_INTEGER) {
> -               length = ACPI_EISAID_STRING_SIZE;
> -       } else {
> -               length = obj_desc->string.length + 1;
> -       }
> -
> -       /* Allocate a buffer for the HID */
> -
> -       hid =
> -           ACPI_ALLOCATE_ZEROED(sizeof(struct acpica_device_id) +
> -                                (acpi_size) length);
> -       if (!hid) {
> -               status = AE_NO_MEMORY;
> -               goto cleanup;
> -       }
> -
> -       /* Area for the string starts after DEVICE_ID struct */
> -
> -       hid->string = ACPI_ADD_PTR(char, hid, sizeof(struct acpica_device_id));
> -
> -       /* Convert EISAID to a string or simply copy existing string */
> -
> -       if (obj_desc->common.type == ACPI_TYPE_INTEGER) {
> -               acpi_ex_eisa_id_to_string(hid->string, obj_desc->integer.value);
> -       } else {
> -               acpi_ut_copy_id_string(hid->string, obj_desc->string.pointer);
> -       }
> -
> -       hid->length = length;
> -       *return_id = hid;
> -
> -cleanup:
> -
> -       /* On exit, we must delete the return object */
> -
> -       acpi_ut_remove_reference(obj_desc);
> -       return_ACPI_STATUS(status);
> -}
> -
> -/*******************************************************************************
> - *
> - * FUNCTION:    acpi_ut_execute_UID
> - *
> - * PARAMETERS:  device_node         - Node for the device
> - *              return_id           - Where the string UID is returned
> - *
> - * RETURN:      Status
> - *
> - * DESCRIPTION: Executes the _UID control method that returns the unique
> - *              ID of the device. The UID is either a 64-bit Integer (NOT an
> - *              EISAID) or a string. Always returns a string. A 64-bit integer
> - *              is converted to a decimal string.
> - *
> - *              NOTE: Internal function, no parameter validation
> - *
> - ******************************************************************************/
> -
> -acpi_status
> -acpi_ut_execute_UID(struct acpi_namespace_node *device_node,
> -                   struct acpica_device_id **return_id)
> -{
> -       union acpi_operand_object *obj_desc;
> -       struct acpica_device_id *uid;
> -       u32 length;
> -       acpi_status status;
> -
> -       ACPI_FUNCTION_TRACE(ut_execute_UID);
> -
> -       status = acpi_ut_evaluate_object(device_node, METHOD_NAME__UID,
> -                                        ACPI_BTYPE_INTEGER | ACPI_BTYPE_STRING,
> -                                        &obj_desc);
> -       if (ACPI_FAILURE(status)) {
> -               return_ACPI_STATUS(status);
> -       }
> -
> -       /* Get the size of the String to be returned, includes null terminator */
> -
> -       if (obj_desc->common.type == ACPI_TYPE_INTEGER) {
> -               length = ACPI_MAX64_DECIMAL_DIGITS + 1;
> -       } else {
> -               length = obj_desc->string.length + 1;
> -       }
> -
> -       /* Allocate a buffer for the UID */
> -
> -       uid =
> -           ACPI_ALLOCATE_ZEROED(sizeof(struct acpica_device_id) +
> -                                (acpi_size) length);
> -       if (!uid) {
> -               status = AE_NO_MEMORY;
> -               goto cleanup;
> -       }
> -
> -       /* Area for the string starts after DEVICE_ID struct */
> -
> -       uid->string = ACPI_ADD_PTR(char, uid, sizeof(struct acpica_device_id));
> -
> -       /* Convert an Integer to string, or just copy an existing string */
> -
> -       if (obj_desc->common.type == ACPI_TYPE_INTEGER) {
> -               acpi_ex_integer_to_string(uid->string, obj_desc->integer.value);
> -       } else {
> -               acpi_ut_copy_id_string(uid->string, obj_desc->string.pointer);
> -       }
> -
> -       uid->length = length;
> -       *return_id = uid;
> -
> -cleanup:
> -
> -       /* On exit, we must delete the return object */
> -
> -       acpi_ut_remove_reference(obj_desc);
> -       return_ACPI_STATUS(status);
> -}
> -
> -/*******************************************************************************
> - *
> - * FUNCTION:    acpi_ut_execute_CID
> - *
> - * PARAMETERS:  device_node         - Node for the device
> - *              return_cid_list     - Where the CID list is returned
> - *
> - * RETURN:      Status, list of CID strings
> - *
> - * DESCRIPTION: Executes the _CID control method that returns one or more
> - *              compatible hardware IDs for the device.
> - *
> - *              NOTE: Internal function, no parameter validation
> - *
> - * A _CID method can return either a single compatible ID or a package of
> - * compatible IDs. Each compatible ID can be one of the following:
> - * 1) Integer (32 bit compressed EISA ID) or
> - * 2) String (PCI ID format, e.g. "PCI\VEN_vvvv&DEV_dddd&SUBSYS_ssssssss")
> - *
> - * The Integer CIDs are converted to string format by this function.
> - *
> - ******************************************************************************/
> -
> -acpi_status
> -acpi_ut_execute_CID(struct acpi_namespace_node *device_node,
> -                   struct acpica_device_id_list **return_cid_list)
> -{
> -       union acpi_operand_object **cid_objects;
> -       union acpi_operand_object *obj_desc;
> -       struct acpica_device_id_list *cid_list;
> -       char *next_id_string;
> -       u32 string_area_size;
> -       u32 length;
> -       u32 cid_list_size;
> -       acpi_status status;
> -       u32 count;
> -       u32 i;
> -
> -       ACPI_FUNCTION_TRACE(ut_execute_CID);
> -
> -       /* Evaluate the _CID method for this device */
> -
> -       status = acpi_ut_evaluate_object(device_node, METHOD_NAME__CID,
> -                                        ACPI_BTYPE_INTEGER | ACPI_BTYPE_STRING
> -                                        | ACPI_BTYPE_PACKAGE, &obj_desc);
> -       if (ACPI_FAILURE(status)) {
> -               return_ACPI_STATUS(status);
> -       }
> -
> -       /*
> -        * Get the count and size of the returned _CIDs. _CID can return either
> -        * a Package of Integers/Strings or a single Integer or String.
> -        * Note: This section also validates that all CID elements are of the
> -        * correct type (Integer or String).
> -        */
> -       if (obj_desc->common.type == ACPI_TYPE_PACKAGE) {
> -               count = obj_desc->package.count;
> -               cid_objects = obj_desc->package.elements;
> -       } else {                /* Single Integer or String CID */
> -
> -               count = 1;
> -               cid_objects = &obj_desc;
> -       }
> -
> -       string_area_size = 0;
> -       for (i = 0; i < count; i++) {
> -
> -               /* String lengths include null terminator */
> -
> -               switch (cid_objects[i]->common.type) {
> -               case ACPI_TYPE_INTEGER:
> -                       string_area_size += ACPI_EISAID_STRING_SIZE;
> -                       break;
> -
> -               case ACPI_TYPE_STRING:
> -                       string_area_size += cid_objects[i]->string.length + 1;
> -                       break;
> -
> -               default:
> -                       status = AE_TYPE;
> -                       goto cleanup;
> -               }
> -       }
> -
> -       /*
> -        * Now that we know the length of the CIDs, allocate return buffer:
> -        * 1) Size of the base structure +
> -        * 2) Size of the CID DEVICE_ID array +
> -        * 3) Size of the actual CID strings
> -        */
> -       cid_list_size = sizeof(struct acpica_device_id_list) +
> -           ((count - 1) * sizeof(struct acpica_device_id)) + string_area_size;
> -
> -       cid_list = ACPI_ALLOCATE_ZEROED(cid_list_size);
> -       if (!cid_list) {
> -               status = AE_NO_MEMORY;
> -               goto cleanup;
> -       }
> -
> -       /* Area for CID strings starts after the CID DEVICE_ID array */
> -
> -       next_id_string = ACPI_CAST_PTR(char, cid_list->ids) +
> -           ((acpi_size) count * sizeof(struct acpica_device_id));
> -
> -       /* Copy/convert the CIDs to the return buffer */
> -
> -       for (i = 0; i < count; i++) {
> -               if (cid_objects[i]->common.type == ACPI_TYPE_INTEGER) {
> -
> -                       /* Convert the Integer (EISAID) CID to a string */
> -
> -                       acpi_ex_eisa_id_to_string(next_id_string,
> -                                                 cid_objects[i]->integer.
> -                                                 value);
> -                       length = ACPI_EISAID_STRING_SIZE;
> -               } else {        /* ACPI_TYPE_STRING */
> -
> -                       /* Copy the String CID from the returned object */
> -
> -                       acpi_ut_copy_id_string(next_id_string,
> -                                              cid_objects[i]->string.pointer);
> -                       length = cid_objects[i]->string.length + 1;
> -               }
> -
> -               cid_list->ids[i].string = next_id_string;
> -               cid_list->ids[i].length = length;
> -               next_id_string += length;
> -       }
> -
> -       /* Finish the CID list */
> -
> -       cid_list->count = count;
> -       cid_list->list_size = cid_list_size;
> -       *return_cid_list = cid_list;
> -
> -cleanup:
> -
> -       /* On exit, we must delete the _CID return object */
> -
> -       acpi_ut_remove_reference(obj_desc);
> -       return_ACPI_STATUS(status);
> -}
> diff --git a/drivers/acpi/acpica/utmisc.c b/drivers/acpi/acpica/utmisc.c
> index 61f6315..75d2d93 100644
> --- a/drivers/acpi/acpica/utmisc.c
> +++ b/drivers/acpi/acpica/utmisc.c
> @@ -125,34 +125,6 @@ const char *acpi_ut_validate_exception(acpi_status status)
> 
>  /*******************************************************************************
>   *
> - * FUNCTION:    acpi_ut_is_pci_root_bridge
> - *
> - * PARAMETERS:  Id              - The HID/CID in string format
> - *
> - * RETURN:      TRUE if the Id is a match for a PCI/PCI-Express Root Bridge
> - *
> - * DESCRIPTION: Determine if the input ID is a PCI Root Bridge ID.
> - *
> - ******************************************************************************/
> -
> -u8 acpi_ut_is_pci_root_bridge(char *id)
> -{
> -
> -       /*
> -        * Check if this is a PCI root bridge.
> -        * ACPI 3.0+: check for a PCI Express root also.
> -        */
> -       if (!(ACPI_STRCMP(id,
> -                         PCI_ROOT_HID_STRING)) ||
> -           !(ACPI_STRCMP(id, PCI_EXPRESS_ROOT_HID_STRING))) {
> -               return (TRUE);
> -       }
> -
> -       return (FALSE);
> -}
> -
> -/*******************************************************************************
> - *
>   * FUNCTION:    acpi_ut_is_aml_table
>   *
>   * PARAMETERS:  Table               - An ACPI table
> diff --git a/drivers/acpi/container.c b/drivers/acpi/container.c
> index 642bb30..5f2c3c0 100644
> --- a/drivers/acpi/container.c
> +++ b/drivers/acpi/container.c
> @@ -202,17 +202,20 @@ container_walk_namespace_cb(acpi_handle handle,
>                             u32 lvl, void *context, void **rv)
>  {
>         char *hid = NULL;
> +       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>         struct acpi_device_info *info;
>         acpi_status status;
>         int *action = context;
> 
> -       status = acpi_get_object_info(handle, &info);
> -       if (ACPI_FAILURE(status)) {
> +
> +       status = acpi_get_object_info(handle, &buffer);
> +       if (ACPI_FAILURE(status) || !buffer.pointer) {
>                 return AE_OK;
>         }
> 
> +       info = buffer.pointer;
>         if (info->valid & ACPI_VALID_HID)
> -               hid = info->hardware_id.string;
> +               hid = info->hardware_id.value;
> 
>         if (hid == NULL) {
>                 goto end;
> @@ -239,7 +242,7 @@ container_walk_namespace_cb(acpi_handle handle,
>         }
> 
>        end:
> -       kfree(info);
> +       kfree(buffer.pointer);
> 
>         return AE_OK;
>  }
> diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
> index 3a2cfef..9a85566 100644
> --- a/drivers/acpi/dock.c
> +++ b/drivers/acpi/dock.c
> @@ -233,16 +233,18 @@ static int is_ata(acpi_handle handle)
>  static int is_battery(acpi_handle handle)
>  {
>         struct acpi_device_info *info;
> +       struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
>         int ret = 1;
> 
> -       if (!ACPI_SUCCESS(acpi_get_object_info(handle, &info)))
> +       if (!ACPI_SUCCESS(acpi_get_object_info(handle, &buffer)))
>                 return 0;
> +       info = buffer.pointer;
>         if (!(info->valid & ACPI_VALID_HID))
>                 ret = 0;
>         else
> -               ret = !strcmp("PNP0C0A", info->hardware_id.string);
> +               ret = !strcmp("PNP0C0A", info->hardware_id.value);
> 
> -       kfree(info);
> +       kfree(buffer.pointer);
>         return ret;
>  }
> 
> diff --git a/drivers/acpi/glue.c b/drivers/acpi/glue.c
> index c6645f2..82daa75 100644
> --- a/drivers/acpi/glue.c
> +++ b/drivers/acpi/glue.c
> @@ -95,13 +95,15 @@ do_acpi_find_child(acpi_handle handle, u32 lvl, void *context, void **rv)
>  {
>         acpi_status status;
>         struct acpi_device_info *info;
> +       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>         struct acpi_find_child *find = context;
> 
> -       status = acpi_get_object_info(handle, &info);
> +       status = acpi_get_object_info(handle, &buffer);
>         if (ACPI_SUCCESS(status)) {
> +               info = buffer.pointer;
>                 if (info->address == find->address)
>                         find->handle = handle;
> -               kfree(info);
> +               kfree(buffer.pointer);
>         }
>         return AE_OK;
>  }
> diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> index 408ebde..056f17c 100644
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -60,13 +60,13 @@ static int create_modalias(struct acpi_device *acpi_dev, char *modalias,
>         }
> 
>         if (acpi_dev->flags.compatible_ids) {
> -               struct acpica_device_id_list *cid_list;
> +               struct acpi_compatible_id_list *cid_list;
>                 int i;
> 
>                 cid_list = acpi_dev->pnp.cid_list;
>                 for (i = 0; i < cid_list->count; i++) {
>                         count = snprintf(&modalias[len], size, "%s:",
> -                                        cid_list->ids[i].string);
> +                                        cid_list->id[i].value);
>                         if (count < 0 || count >= size) {
>                                 printk(KERN_ERR PREFIX "%s cid[%i] exceeds event buffer size",
>                                        acpi_dev->pnp.device_name, i);
> @@ -287,14 +287,14 @@ int acpi_match_device_ids(struct acpi_device *device,
>         }
> 
>         if (device->flags.compatible_ids) {
> -               struct acpica_device_id_list *cid_list = device->pnp.cid_list;
> +               struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
>                 int i;
> 
>                 for (id = ids; id->id[0]; id++) {
>                         /* compare multiple _CID entries against driver ids */
>                         for (i = 0; i < cid_list->count; i++) {
>                                 if (!strcmp((char*)id->id,
> -                                           cid_list->ids[i].string))
> +                                           cid_list->id[i].value))
>                                         return 0;
>                         }
>                 }
> @@ -1000,89 +1000,33 @@ static int acpi_dock_match(struct acpi_device *device)
>         return acpi_get_handle(device->handle, "_DCK", &tmp);
>  }
> 
> -static struct acpica_device_id_list*
> -acpi_add_cid(
> -       struct acpi_device_info         *info,
> -       struct acpica_device_id         *new_cid)
> -{
> -       struct acpica_device_id_list    *cid;
> -       char                            *next_id_string;
> -       acpi_size                       cid_length;
> -       acpi_size                       new_cid_length;
> -       u32                             i;
> -
> -
> -       /* Allocate new CID list with room for the new CID */
> -
> -       if (!new_cid)
> -               new_cid_length = info->compatible_id_list.list_size;
> -       else if (info->compatible_id_list.list_size)
> -               new_cid_length = info->compatible_id_list.list_size +
> -                       new_cid->length + sizeof(struct acpica_device_id);
> -       else
> -               new_cid_length = sizeof(struct acpica_device_id_list) + new_cid->length;
> -
> -       cid = ACPI_ALLOCATE_ZEROED(new_cid_length);
> -       if (!cid) {
> -               return NULL;
> -       }
> -
> -       cid->list_size = new_cid_length;
> -       cid->count = info->compatible_id_list.count;
> -       if (new_cid)
> -               cid->count++;
> -       next_id_string = (char *) cid->ids + (cid->count * sizeof(struct acpica_device_id));
> -
> -       /* Copy all existing CIDs */
> -
> -       for (i = 0; i < info->compatible_id_list.count; i++) {
> -               cid_length = info->compatible_id_list.ids[i].length;
> -               cid->ids[i].string = next_id_string;
> -               cid->ids[i].length = cid_length;
> -
> -               ACPI_MEMCPY(next_id_string, info->compatible_id_list.ids[i].string,
> -                       cid_length);
> -
> -               next_id_string += cid_length;
> -       }
> -
> -       /* Append the new CID */
> -
> -       if (new_cid) {
> -               cid->ids[i].string = next_id_string;
> -               cid->ids[i].length = new_cid->length;
> -
> -               ACPI_MEMCPY(next_id_string, new_cid->string, new_cid->length);
> -       }
> -
> -       return cid;
> -}
> -
>  static void acpi_device_set_id(struct acpi_device *device,
>                                struct acpi_device *parent, acpi_handle handle,
>                                int type)
>  {
> -       struct acpi_device_info *info = NULL;
> +       struct acpi_device_info *info;
> +       struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>         char *hid = NULL;
>         char *uid = NULL;
> -       struct acpica_device_id_list *cid_list = NULL;
> -       char *cid_add = NULL;
> +       struct acpi_compatible_id_list *cid_list = NULL;
> +       const char *cid_add = NULL;
>         acpi_status status;
> 
>         switch (type) {
>         case ACPI_BUS_TYPE_DEVICE:
> -               status = acpi_get_object_info(handle, &info);
> +               status = acpi_get_object_info(handle, &buffer);
>                 if (ACPI_FAILURE(status)) {
>                         printk(KERN_ERR PREFIX "%s: Error reading device info\n", __func__);
>                         return;
>                 }
> 
> +               info = buffer.pointer;
>                 if (info->valid & ACPI_VALID_HID)
> -                       hid = info->hardware_id.string;
> +                       hid = info->hardware_id.value;
>                 if (info->valid & ACPI_VALID_UID)
> -                       uid = info->unique_id.string;
> +                       uid = info->unique_id.value;
>                 if (info->valid & ACPI_VALID_CID)
> -                       cid_list = &info->compatible_id_list;
> +                       cid_list = &info->compatibility_id;
>                 if (info->valid & ACPI_VALID_ADR) {
>                         device->pnp.bus_address = info->address;
>                         device->flags.bus_address = 1;
> @@ -1133,46 +1077,55 @@ static void acpi_device_set_id(struct acpi_device *device,
>         }
> 
>         if (hid) {
> -               device->pnp.hardware_id = ACPI_ALLOCATE_ZEROED(strlen (hid) + 1);
> -               if (device->pnp.hardware_id) {
> -                       strcpy(device->pnp.hardware_id, hid);
> -                       device->flags.hardware_id = 1;
> -               }
> +               strcpy(device->pnp.hardware_id, hid);
> +               device->flags.hardware_id = 1;
>         }
> -       if (!device->flags.hardware_id)
> -               device->pnp.hardware_id = "";
> -
>         if (uid) {
> -               device->pnp.unique_id = ACPI_ALLOCATE_ZEROED(strlen (uid) + 1);
> -               if (device->pnp.unique_id) {
> -                       strcpy(device->pnp.unique_id, uid);
> -                       device->flags.unique_id = 1;
> -               }
> +               strcpy(device->pnp.unique_id, uid);
> +               device->flags.unique_id = 1;
>         }
> -       if (!device->flags.unique_id)
> -               device->pnp.unique_id = "";
> -
>         if (cid_list || cid_add) {
> -               struct acpica_device_id_list *list;
> -
> -               if (cid_add) {
> -                       struct acpica_device_id cid;
> -                       cid.length = strlen (cid_add) + 1;
> -                       cid.string = cid_add;
> -
> -                       list = acpi_add_cid(info, &cid);
> -               } else {
> -                       list = acpi_add_cid(info, NULL);
> +               struct  acpi_compatible_id_list *list;
> +               int size = 0;
> +               int count = 0;
> +
> +               if (cid_list) {
> +                       size = cid_list->size;
> +               } else if (cid_add) {
> +                       size = sizeof(struct acpi_compatible_id_list);
> +                       cid_list = ACPI_ALLOCATE_ZEROED((acpi_size) size);
> +                       if (!cid_list) {
> +                               printk(KERN_ERR "Memory allocation error\n");
> +                               kfree(buffer.pointer);
> +                               return;
> +                       } else {
> +                               cid_list->count = 0;
> +                               cid_list->size = size;
> +                       }
>                 }
> +               if (cid_add)
> +                       size += sizeof(struct acpi_compatible_id);
> +               list = kmalloc(size, GFP_KERNEL);
> 
>                 if (list) {
> -                       device->pnp.cid_list = list;
> -                       if (cid_add)
> +                       if (cid_list) {
> +                               memcpy(list, cid_list, cid_list->size);
> +                               count = cid_list->count;
> +                       }
> +                       if (cid_add) {
> +                               strncpy(list->id[count].value, cid_add,
> +                                       ACPI_MAX_CID_LENGTH);
> +                               count++;
>                                 device->flags.compatible_ids = 1;
> -               }
> +                       }
> +                       list->size = size;
> +                       list->count = count;
> +                       device->pnp.cid_list = list;
> +               } else
> +                       printk(KERN_ERR PREFIX "Memory allocation error\n");
>         }
> 
> -       kfree(info);
> +       kfree(buffer.pointer);
>  }
> 
>  static int acpi_device_set_context(struct acpi_device *device, int type)
> diff --git a/drivers/char/agp/hp-agp.c b/drivers/char/agp/hp-agp.c
> index 9047b27..501e293 100644
> --- a/drivers/char/agp/hp-agp.c
> +++ b/drivers/char/agp/hp-agp.c
> @@ -476,6 +476,7 @@ zx1_gart_probe (acpi_handle obj, u32 depth, void *context, void **ret)
>  {
>         acpi_handle handle, parent;
>         acpi_status status;
> +       struct acpi_buffer buffer;
>         struct acpi_device_info *info;
>         u64 lba_hpa, sba_hpa, length;
>         int match;
> @@ -487,11 +488,13 @@ zx1_gart_probe (acpi_handle obj, u32 depth, void *context, void **ret)
>         /* Look for an enclosing IOC scope and find its CSR space */
>         handle = obj;
>         do {
> -               status = acpi_get_object_info(handle, &info);
> +               buffer.length = ACPI_ALLOCATE_LOCAL_BUFFER;
> +               status = acpi_get_object_info(handle, &buffer);
>                 if (ACPI_SUCCESS(status)) {
>                         /* TBD check _CID also */
> -                       info->hardware_id.string[sizeof(info->hardware_id.length)-1] = '\0';
> -                       match = (strcmp(info->hardware_id.string, "HWP0001") == 0);
> +                       info = buffer.pointer;
> +                       info->hardware_id.value[sizeof(info->hardware_id)-1] = '\0';
> +                       match = (strcmp(info->hardware_id.value, "HWP0001") == 0);
>                         kfree(info);
>                         if (match) {
>                                 status = hp_acpi_csr_space(handle, &sba_hpa, &length);
> diff --git a/drivers/ide/ide-acpi.c b/drivers/ide/ide-acpi.c
> index c0cf45a..c509c99 100644
> --- a/drivers/ide/ide-acpi.c
> +++ b/drivers/ide/ide-acpi.c
> @@ -114,6 +114,8 @@ static int ide_get_dev_handle(struct device *dev, acpi_handle *handle,
>         unsigned int bus, devnum, func;
>         acpi_integer addr;
>         acpi_handle dev_handle;
> +       struct acpi_buffer buffer = {.length = ACPI_ALLOCATE_BUFFER,
> +                                       .pointer = NULL};
>         acpi_status status;
>         struct acpi_device_info *dinfo = NULL;
>         int ret = -ENODEV;
> @@ -132,11 +134,12 @@ static int ide_get_dev_handle(struct device *dev, acpi_handle *handle,
>                 goto err;
>         }
> 
> -       status = acpi_get_object_info(dev_handle, &dinfo);
> +       status = acpi_get_object_info(dev_handle, &buffer);
>         if (ACPI_FAILURE(status)) {
>                 DEBPRINT("get_object_info for device failed\n");
>                 goto err;
>         }
> +       dinfo = buffer.pointer;
>         if (dinfo && (dinfo->valid & ACPI_VALID_ADR) &&
>             dinfo->address == addr) {
>                 *pcidevfn = addr;
> diff --git a/drivers/pci/hotplug/acpiphp_ibm.c b/drivers/pci/hotplug/acpiphp_ibm.c
> index a9d926b..5befa7e 100644
> --- a/drivers/pci/hotplug/acpiphp_ibm.c
> +++ b/drivers/pci/hotplug/acpiphp_ibm.c
> @@ -398,21 +398,23 @@ static acpi_status __init ibm_find_acpi_device(acpi_handle handle,
>         acpi_handle *phandle = (acpi_handle *)context;
>         acpi_status status;
>         struct acpi_device_info *info;
> +       struct acpi_buffer info_buffer = { ACPI_ALLOCATE_BUFFER, NULL };
>         int retval = 0;
> 
> -       status = acpi_get_object_info(handle, &info);
> +       status = acpi_get_object_info(handle, &info_buffer);
>         if (ACPI_FAILURE(status)) {
>                 err("%s:  Failed to get device information status=0x%x\n",
>                         __func__, status);
>                 return retval;
>         }
> -       info->hardware_id.string[sizeof(info->hardware_id.length) - 1] = '\0';
> +       info = info_buffer.pointer;
> +       info->hardware_id.value[sizeof(info->hardware_id.value) - 1] = '\0';
> 
>         if (info->current_status && (info->valid & ACPI_VALID_HID) &&
> -                       (!strcmp(info->hardware_id.string, IBM_HARDWARE_ID1) ||
> -                        !strcmp(info->hardware_id.string, IBM_HARDWARE_ID2))) {
> +                       (!strcmp(info->hardware_id.value, IBM_HARDWARE_ID1) ||
> +                        !strcmp(info->hardware_id.value, IBM_HARDWARE_ID2))) {
>                 dbg("found hardware: %s, handle: %p\n",
> -                       info->hardware_id.string, handle);
> +                       info->hardware_id.value, handle);
>                 *phandle = handle;
>                 /* returning non-zero causes the search to stop
>                  * and returns this value to the caller of
> diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
> index f9f68e0..dafaa4a 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -976,12 +976,15 @@ static acpi_status sony_walk_callback(acpi_handle handle, u32 level,
>                                       void *context, void **return_value)
>  {
>         struct acpi_device_info *info;
> +       struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
> +
> +       if (ACPI_SUCCESS(acpi_get_object_info(handle, &buffer))) {
> +               info = buffer.pointer;
> 
> -       if (ACPI_SUCCESS(acpi_get_object_info(handle, &info))) {
>                 printk(KERN_WARNING DRV_PFX "method: name: %4.4s, args %X\n",
>                         (char *)&info->name, info->param_count);
> 
> -               kfree(info);
> +               kfree(buffer.pointer);
>         }
> 
>         return AE_OK;
> diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
> index c07fdb9..9496494 100644
> --- a/drivers/pnp/pnpacpi/core.c
> +++ b/drivers/pnp/pnpacpi/core.c
> @@ -194,13 +194,13 @@ static int __init pnpacpi_add_device(struct acpi_device *device)
>                 pnpacpi_parse_resource_option_data(dev);
> 
>         if (device->flags.compatible_ids) {
> -               struct acpica_device_id_list *cid_list = device->pnp.cid_list;
> +               struct acpi_compatible_id_list *cid_list = device->pnp.cid_list;
>                 int i;
> 
>                 for (i = 0; i < cid_list->count; i++) {
> -                       if (!ispnpidacpi(cid_list->ids[i].string))
> +                       if (!ispnpidacpi(cid_list->id[i].value))
>                                 continue;
> -                       pnp_add_id(dev, cid_list->ids[i].string);
> +                       pnp_add_id(dev, cid_list->id[i].value);
>                 }
>         }
> 
> diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
> index 1cef139..7f2cabb 100644
> --- a/include/acpi/acpi_bus.h
> +++ b/include/acpi/acpi_bus.h
> @@ -169,15 +169,17 @@ struct acpi_device_dir {
> 
>  typedef char acpi_bus_id[8];
>  typedef unsigned long acpi_bus_address;
> +typedef char acpi_hardware_id[15];
> +typedef char acpi_unique_id[9];
>  typedef char acpi_device_name[40];
>  typedef char acpi_device_class[20];
> 
>  struct acpi_device_pnp {
>         acpi_bus_id bus_id;     /* Object name */
>         acpi_bus_address bus_address;   /* _ADR */
> -       char *hardware_id;      /* _HID */
> -       struct acpica_device_id_list *cid_list; /* _CIDs */
> -       char *unique_id;        /* _UID */
> +       acpi_hardware_id hardware_id;   /* _HID */
> +       struct acpi_compatible_id_list *cid_list;       /* _CIDs */
> +       acpi_unique_id unique_id;       /* _UID */
>         acpi_device_name device_name;   /* Driver-determined */
>         acpi_device_class device_class; /*        "          */
>  };
> diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
> index e723b0f..a7eecb4 100644
> --- a/include/acpi/acpixf.h
> +++ b/include/acpi/acpixf.h
> @@ -200,8 +200,7 @@ acpi_evaluate_object_typed(acpi_handle object,
>                            acpi_object_type return_type);
> 
>  acpi_status
> -acpi_get_object_info(acpi_handle handle,
> -                    struct acpi_device_info **return_buffer);
> +acpi_get_object_info(acpi_handle handle, struct acpi_buffer *return_buffer);
> 
>  acpi_status acpi_install_method(u8 *buffer);
> 
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index 153f12d..90df86f 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -338,7 +338,7 @@ typedef u32 acpi_physical_address;
> 
>  /* PM Timer ticks per second (HZ) */
> 
> -#define PM_TIMER_FREQUENCY              3579545
> +#define PM_TIMER_FREQUENCY  3579545
> 
>  /*******************************************************************************
>   *
> @@ -970,60 +970,38 @@ acpi_status(*acpi_walk_callback) (acpi_handle obj_handle,
>  #define ACPI_INTERRUPT_NOT_HANDLED      0x00
>  #define ACPI_INTERRUPT_HANDLED          0x01
> 
> -/* Length of 32-bit EISAID values when converted back to a string */
> -
> -#define ACPI_EISAID_STRING_SIZE         8      /* Includes null terminator */
> -
> -/* Length of UUID (string) values */
> +/* Length of _HID, _UID, _CID, and UUID values */
> 
> +#define ACPI_DEVICE_ID_LENGTH           0x09
> +#define ACPI_MAX_CID_LENGTH             48
>  #define ACPI_UUID_LENGTH                16
> 
> -/* Structures used for device/processor HID, UID, CID */
> +/* Common string version of device HIDs and UIDs */
> 
>  struct acpica_device_id {
> -       u32 length;             /* Length of string + null */
> -       char *string;
> +       char value[ACPI_DEVICE_ID_LENGTH];
>  };
> 
> -struct acpica_device_id_list {
> -       u32 count;              /* Number of IDs in Ids array */
> -       u32 list_size;          /* Size of list, including ID strings */
> -       struct acpica_device_id ids[1]; /* ID array */
> -};
> +/* Common string version of device CIDs */
> 
> -/*
> - * Structure returned from acpi_get_object_info.
> - * Optimized for both 32- and 64-bit builds
> - */
> -struct acpi_device_info {
> -       u32 info_size;          /* Size of info, including ID strings */
> -       u32 name;               /* ACPI object Name */
> -       acpi_object_type type;  /* ACPI object Type */
> -       u8 param_count;         /* If a method, required parameter count */
> -       u8 valid;               /* Indicates which optional fields are valid */
> -       u8 flags;               /* Miscellaneous info */
> -       u8 highest_dstates[4];  /* _sx_d values: 0xFF indicates not valid */
> -       u8 lowest_dstates[5];   /* _sx_w values: 0xFF indicates not valid */
> -       u32 current_status;     /* _STA value */
> -       acpi_integer address;   /* _ADR value */
> -       struct acpica_device_id hardware_id;    /* _HID value */
> -       struct acpica_device_id unique_id;      /* _UID value */
> -       struct acpica_device_id_list compatible_id_list;        /* _CID list <must be last> */
> +struct acpi_compatible_id {
> +       char value[ACPI_MAX_CID_LENGTH];
>  };
> 
> -/* Values for Flags field above (acpi_get_object_info) */
> -
> -#define ACPI_PCI_ROOT_BRIDGE            0x01
> +struct acpi_compatible_id_list {
> +       u32 count;
> +       u32 size;
> +       struct acpi_compatible_id id[1];
> +};
> 
> -/* Flags for Valid field above (acpi_get_object_info) */
> +/* Structure and flags for acpi_get_object_info */
> 
> -#define ACPI_VALID_STA                  0x01
> -#define ACPI_VALID_ADR                  0x02
> -#define ACPI_VALID_HID                  0x04
> -#define ACPI_VALID_UID                  0x08
> -#define ACPI_VALID_CID                  0x10
> -#define ACPI_VALID_SXDS                 0x20
> -#define ACPI_VALID_SXWS                 0x40
> +#define ACPI_VALID_STA                  0x0001
> +#define ACPI_VALID_ADR                  0x0002
> +#define ACPI_VALID_HID                  0x0004
> +#define ACPI_VALID_UID                  0x0008
> +#define ACPI_VALID_CID                  0x0010
> +#define ACPI_VALID_SXDS                 0x0020
> 
>  /* Flags for _STA method */
> 
> @@ -1034,6 +1012,29 @@ struct acpi_device_info {
>  #define ACPI_STA_DEVICE_OK              0x08   /* Synonym */
>  #define ACPI_STA_BATTERY_PRESENT        0x10
> 
> +#define ACPI_COMMON_OBJ_INFO \
> +       acpi_object_type                type;           /* ACPI object type */ \
> +       acpi_name                       name    /* ACPI object Name */
> +
> +struct acpi_obj_info_header {
> +       ACPI_COMMON_OBJ_INFO;
> +};
> +
> +/* Structure returned from Get Object Info */
> +
> +struct acpi_device_info {
> +       ACPI_COMMON_OBJ_INFO;
> +
> +       u32 param_count;        /* If a method, required parameter count */
> +       u32 valid;              /* Indicates which fields below are valid */
> +       u32 current_status;     /* _STA value */
> +       acpi_integer address;   /* _ADR value if any */
> +       struct acpica_device_id hardware_id;    /* _HID value if any */
> +       struct acpica_device_id unique_id;      /* _UID value if any */
> +       u8 highest_dstates[4];  /* _sx_d values: 0xFF indicates not valid */
> +       struct acpi_compatible_id_list compatibility_id;        /* List of _CIDs if any */
> +};
> +
>  /* Context structs for address space handlers */
> 
>  struct acpi_pci_id {

