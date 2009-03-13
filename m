Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbZCMBYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbZCMBYs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 21:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750813AbZCMBYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 21:24:38 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:32737 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbZCMBYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 21:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=qT2S6Mz2YoevTRj3/gpGzliGasVDx8QZGN4hSpa3mqCdeK24dbmMtUp2VbvNGPjBcd
         6dgILI5PnVbitFGLhPLJVr0Z3iaCJ/Z0BKocr5z/gtf1C0auIPyXdy3KvOhHzQ4BzeEq
         8Dvj1Uw2bhQ+xJxG5qXY+MMWN0ZxKfi90D/tQ=
MIME-Version: 1.0
In-Reply-To: <f14c01620903121753j34de8bf0j28ba3339e560d5db@mail.gmail.com>
References: <f14c01620903121753j34de8bf0j28ba3339e560d5db@mail.gmail.com>
Date: Thu, 12 Mar 2009 18:24:34 -0700
Message-ID: <f14c01620903121824tcf8b988rcb783dafee015c72@mail.gmail.com>
Subject: Re: kernel lockup - copy_user_generic_string+45 -> oops?
From: Kaleb Pederson <kaleb.pederson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's another crash dump including the initial crash output which I
forgot last time.  Both this and the prior call system_call_fastpath
and are going through the vfs layer, but this second one doesn't go
through copy_user_generic_string. I'm not familiar with any of the
kernel source to know what that might imply :(.

Could this be related to a hardware problem (in this case related to
the hard drive)?

      KERNEL: /usr/src/linux/vmlinux
    DUMPFILE: /root/vmcore2
        CPUS: 4
        DATE: Thu Mar 12 18:04:01 2009
      UPTIME: 00:05:53
LOAD AVERAGE: 1.15, 0.28, 0.09
       TASKS: 207
    NODENAME: kibab
     RELEASE: 2.6.29-rc7
     VERSION: #3 SMP Thu Mar 12 13:34:16 PDT 2009
     MACHINE: x86_64  (2608 Mhz)
      MEMORY: 4 GB
       PANIC: ""
         PID: 10935
     COMMAND: "kdeinit4"
        TASK: ffff880129533160  [THREAD_INFO: ffff88012bc26000]
         CPU: 0
       STATE: TASK_RUNNING (NMI)

crash> bt -a
PID: 10935  TASK: ffff880129533160  CPU: 0   COMMAND: "kdeinit4"
 #0 [ffffffff807e8cd0] machine_kexec at ffffffff8021ef5b
 #1 [ffffffff807e8db0] crash_kexec at ffffffff8026326e
 #2 [ffffffff807e8e80] oops_end at ffffffff80554115
 #3 [ffffffff807e8eb0] die_nmi at ffffffff805542ba
 #4 [ffffffff807e8ee0] nmi_watchdog_tick at ffffffff8055461a
 #5 [ffffffff807e8f20] do_nmi at ffffffff80553bc7
 #6 [ffffffff807e8f50] nmi at ffffffff8055398a
    [exception RIP: task_rq_lock+89]
    RIP: ffffffff8022e540  RSP: ffff88012bc27b18  RFLAGS: 00000046
    RAX: ffff88012f8846c0  RBX: ffff88002803a700  RCX: 00000052513686ad
    RDX: 0000000000000001  RSI: ffff88012bc27b58  RDI: ffff88002803a700
    RBP: ffff88012bc27b38   R8: ffff88012bc27ba8   R9: ffff88012bc67ad8
    R10: 0000000000000000  R11: 0000000000000000  R12: ffff88002803a700
    R13: ffff88012bc27b58  R14: ffff880129570500  R15: 0000000000000001
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #7 [ffff88012bc27b18] task_rq_lock at ffffffff8022e540
 #8 [ffff88012bc27b40] try_to_wake_up at ffffffff8023205f
 #9 [ffff88012bc27b90] default_wake_function at ffffffff802321b1
#10 [ffff88012bc27ba0] pollwake at ffffffff802b92f6
#11 [ffff88012bc27bf0] __wake_up_common at ffffffff8022cf28
#12 [ffff88012bc27c30] __wake_up_sync at ffffffff8022df86
#13 [ffff88012bc27c60] sock_def_readable at ffffffff804d0f7c
#14 [ffff88012bc27c80] unix_stream_sendmsg at ffffffff80539143
#15 [ffff88012bc27d10] sock_aio_write at ffffffff804cc8c0
#16 [ffff88012bc27de0] do_sync_write at ffffffff802ab077
#17 [ffff88012bc27f10] vfs_write at ffffffff802ab81f
#18 [ffff88012bc27f40] sys_write at ffffffff802abd8c
#19 [ffff88012bc27f80] system_call_fastpath at ffffffff8020bf5b
    RIP: 00007f1212cd9200  RSP: 00007fff1b4ff510  RFLAGS: 00010293
    RAX: 0000000000000001  RBX: ffffffff8020bf5b  RCX: 000000000062cbe0
    RDX: 0000000000000010  RSI: 00007fff1b4ff9e0  RDI: 0000000000000007
    RBP: 000000000060b560   R8: 00007f1211649eb7   R9: 0000000000002ab7
    R10: 00007f12134c67f0  R11: 0000000000000246  R12: 0000000000409c67
    R13: 0000000000000007  R14: 000000000062d490  R15: 0000000000002b4f
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

PID: 0      TASK: ffff88012f26b410  CPU: 1   COMMAND: "swapper"
 #0 [ffff88012f274e80] crash_nmi_callback at ffffffff8021b588
 #1 [ffff88012f274e90] notifier_call_chain at ffffffff80555ac6
 #2 [ffff88012f274ed0] __atomic_notifier_call_chain at ffffffff80555b05
 #3 [ffff88012f274ee0] atomic_notifier_call_chain at ffffffff80555b16
 #4 [ffff88012f274ef0] notify_die at ffffffff8024f776
 #5 [ffff88012f274f20] do_nmi at ffffffff80553bb1
 #6 [ffff88012f274f50] nmi at ffffffff8055398a
    [exception RIP: default_idle+43]
    RIP: ffffffff80211d9d  RSP: ffff88012f26ded8  RFLAGS: 00000246
    RAX: ffff88012f26dfd8  RBX: ffffffff8076bbb8  RCX: 00000000c0010055
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff806b4d90
    RBP: ffff88012f26ded8   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000000  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #7 [ffff88012f26ded8] default_idle at ffffffff80211d9d
 #8 [ffff88012f26dee0] c1e_idle at ffffffff80211fc5
 #9 [ffff88012f26df10] cpu_idle at ffffffff8020aca0

PID: 11086  TASK: ffff880129aa7550  CPU: 2   COMMAND: "kio_http"
 #0 [ffff88012f2a9e80] crash_nmi_callback at ffffffff8021b588
 #1 [ffff88012f2a9e90] notifier_call_chain at ffffffff80555ac6
 #2 [ffff88012f2a9ed0] __atomic_notifier_call_chain at ffffffff80555b05
 #3 [ffff88012f2a9ee0] atomic_notifier_call_chain at ffffffff80555b16
 #4 [ffff88012f2a9ef0] notify_die at ffffffff8024f776
 #5 [ffff88012f2a9f20] do_nmi at ffffffff80553bb1
 #6 [ffff88012f2a9f50] nmi at ffffffff8055398a
    RIP: 00007f1212a23128  RSP: 00007fff1b4fd070  RFLAGS: 00000207
    RAX: 00007f12132e36c0  RBX: 000000000065ad98  RCX: 0000000000000013
    RDX: 0000000000000001  RSI: 000000000065ef70  RDI: 000000000065ef70
    RBP: 00007fff1b4fd07c   R8: 00007fff1b4fd07c   R9: 0000000000000004
    R10: 0000000000000003  R11: 00007f120fbe5a70  R12: 0000000000665fb8
    R13: 00007fff1b4fdfa0  R14: 00007f12132e36c0  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0033  SS: 002b
--- <exception stack> ---

PID: 0      TASK: ffff88012f2d5490  CPU: 3   COMMAND: "swapper"
 #0 [ffff88012f2e0e80] crash_nmi_callback at ffffffff8021b588
 #1 [ffff88012f2e0e90] notifier_call_chain at ffffffff80555ac6
 #2 [ffff88012f2e0ed0] __atomic_notifier_call_chain at ffffffff80555b05
 #3 [ffff88012f2e0ee0] atomic_notifier_call_chain at ffffffff80555b16
 #4 [ffff88012f2e0ef0] notify_die at ffffffff8024f776
 #5 [ffff88012f2e0f20] do_nmi at ffffffff80553bb1
 #6 [ffff88012f2e0f50] nmi at ffffffff8055398a
    [exception RIP: default_idle+43]
    RIP: ffffffff80211d9d  RSP: ffff88012f2d7ed8  RFLAGS: 00000246
    RAX: ffff88012f2d7fd8  RBX: ffffffff8076bbb8  RCX: 00000000c0010055
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff806b4d90
    RBP: ffff88012f2d7ed8   R8: 0000000000000000   R9: 0000000000000003
    R10: 0000000000000008  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #7 [ffff88012f2d7ed8] default_idle at ffffffff80211d9d
 #8 [ffff88012f2d7ee0] c1e_idle at ffffffff80211fc5
 #9 [ffff88012f2d7f10] cpu_idle at ffffffff8020aca0


Thanks again for the help.

--Kaleb

On Thu, Mar 12, 2009 at 5:53 PM, Kaleb Pederson
<kaleb.pederson@gmail.com> wrote:
> I'm experiencing random but frequent lockups on a newly built system.
> I installed a crashkernel and was able to produce a crash dump which
> follows:
>
> crash> bt -a
> PID: 11672  TASK: ffff88012960d260  CPU: 0   COMMAND: "strings"
>  #0 [ffffffff807e8cd0] machine_kexec at ffffffff8021ef5b
>  #1 [ffffffff807e8db0] crash_kexec at ffffffff8026326e
>  #2 [ffffffff807e8e80] oops_end at ffffffff80554115
>  #3 [ffffffff807e8eb0] die_nmi at ffffffff805542ba
>  #4 [ffffffff807e8ee0] nmi_watchdog_tick at ffffffff8055461a
>  #5 [ffffffff807e8f20] do_nmi at ffffffff80553bc7
>  #6 [ffffffff807e8f50] nmi at ffffffff8055398a
>    [exception RIP: copy_user_generic_string+45]
>    RIP: ffffffff803ca68d  RSP: ffff88012dcb5c60  RFLAGS: 00000246
>    RAX: ffff880000000000  RBX: ffff88012dcb5d08  RCX: 00000000000000af
>    RDX: 0000000000000000  RSI: ffff8801190d1a88  RDI: 00007f5e594f6a98
>    RBP: ffff88012dcb5c98   R8: 0000000000010287   R9: ffffe20003d7adc0
>    R10: 0000000000000002  R11: 0000000000000001  R12: 0000000000001000
>    R13: 0000000000096000  R14: ffffe20003d7adb8  R15: 0000000000000000
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> --- <exception stack> ---
>  #7 [ffff88012dcb5c60] copy_user_generic_string at ffffffff803ca68d
>  #8 [ffff88012dcb5c60] file_read_actor at ffffffff802851f1
>  #9 [ffff88012dcb5ca0] generic_file_aio_read at ffffffff80284ee5
> #10 [ffff88012dcb5d70] xfs_read at ffffffff803926d4
> #11 [ffff88012dcb5dd0] xfs_file_aio_read at ffffffff8038f11b
> #12 [ffff88012dcb5de0] do_sync_read at ffffffff802ab19d
> #13 [ffff88012dcb5f10] vfs_read at ffffffff802ab960
> #14 [ffff88012dcb5f40] sys_read at ffffffff802abd1c
> #15 [ffff88012dcb5f80] system_call_fastpath at ffffffff8020bf5b
>    RIP: 00007f5e59647860  RSP: 00007fff61ffcd80  RFLAGS: 00010202
>    RAX: 0000000000000000  RBX: ffffffff8020bf5b  RCX: 00007f5e596507da
>    RDX: 0000000000359000  RSI: 00007f5e59233010  RDI: 000000000000000a
>    RBP: 0000000000609200   R8: 00007f5e59fd46f0   R9: 00007f5e59233010
>    R10: 0000000000200000  R11: 0000000000000246  R12: 00000000003599af
>    R13: 00007f5e59233010  R14: 00000000003599af  R15: 0000000000000000
>    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b
>
> PID: 0      TASK: ffff88012f26b410  CPU: 1   COMMAND: "swapper"
>  #0 [ffff88012f274e80] crash_nmi_callback at ffffffff8021b588
>  #1 [ffff88012f274e90] notifier_call_chain at ffffffff80555ac6
>  #2 [ffff88012f274ed0] __atomic_notifier_call_chain at ffffffff80555b05
>  #3 [ffff88012f274ee0] atomic_notifier_call_chain at ffffffff80555b16
>  #4 [ffff88012f274ef0] notify_die at ffffffff8024f776
>  #5 [ffff88012f274f20] do_nmi at ffffffff80553bb1
>  #6 [ffff88012f274f50] nmi at ffffffff8055398a
>    [exception RIP: default_idle+43]
>    RIP: ffffffff80211d9d  RSP: ffff88012f26ded8  RFLAGS: 00000246
>    RAX: ffff88012f26dfd8  RBX: ffffffff8076bbb8  RCX: 00000000c0010055
>    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff806b4d90
>    RBP: ffff88012f26ded8   R8: 0000000000000000   R9: 0000000000000001
>    R10: 0000000000000022  R11: 0000000000000246  R12: 0000000000000000
>    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> --- <exception stack> ---
>  #7 [ffff88012f26ded8] default_idle at ffffffff80211d9d
>  #8 [ffff88012f26dee0] c1e_idle at ffffffff80211fc5
>  #9 [ffff88012f26df10] cpu_idle at ffffffff8020aca0
>
> PID: 0      TASK: ffff88012f2a1450  CPU: 2   COMMAND: "swapper"
>  #0 [ffff88012f2a9e80] crash_nmi_callback at ffffffff8021b588
>  #1 [ffff88012f2a9e90] notifier_call_chain at ffffffff80555ac6
>  #2 [ffff88012f2a9ed0] __atomic_notifier_call_chain at ffffffff80555b05
>  #3 [ffff88012f2a9ee0] atomic_notifier_call_chain at ffffffff80555b16
>  #4 [ffff88012f2a9ef0] notify_die at ffffffff8024f776
>  #5 [ffff88012f2a9f20] do_nmi at ffffffff80553bb1
>  #6 [ffff88012f2a9f50] nmi at ffffffff8055398a
>    [exception RIP: default_idle+43]
>    RIP: ffffffff80211d9d  RSP: ffff88012f2a3ed8  RFLAGS: 00000246
>    RAX: ffff88012f2a3fd8  RBX: ffffffff8076bbb8  RCX: 00000000c0010055
>    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff806b4d90
>    RBP: ffff88012f2a3ed8   R8: 0000000000000000   R9: 0000000000000002
>    R10: 0000000000000003  R11: 0000000000000001  R12: 0000000000000000
>    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> --- <exception stack> ---
>  #7 [ffff88012f2a3ed8] default_idle at ffffffff80211d9d
>  #8 [ffff88012f2a3ee0] c1e_idle at ffffffff80211fc5
>  #9 [ffff88012f2a3f10] cpu_idle at ffffffff8020aca0
>
> PID: 0      TASK: ffff88012f2d5490  CPU: 3   COMMAND: "swapper"
>  #0 [ffff88012f2e0e80] crash_nmi_callback at ffffffff8021b588
>  #1 [ffff88012f2e0e90] notifier_call_chain at ffffffff80555ac6
>  #2 [ffff88012f2e0ed0] __atomic_notifier_call_chain at ffffffff80555b05
>  #3 [ffff88012f2e0ee0] atomic_notifier_call_chain at ffffffff80555b16
>  #4 [ffff88012f2e0ef0] notify_die at ffffffff8024f776
>  #5 [ffff88012f2e0f20] do_nmi at ffffffff80553bb1
>  #6 [ffff88012f2e0f50] nmi at ffffffff8055398a
>    [exception RIP: default_idle+43]
>    RIP: ffffffff80211d9d  RSP: ffff88012f2d7ed8  RFLAGS: 00000246
>    RAX: ffff88012f2d7fd8  RBX: ffffffff8076bbb8  RCX: 00000000c0010055
>    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff806b4d90
>    RBP: ffff88012f2d7ed8   R8: 0000000000000000   R9: 0000000000000003
>    R10: 0000000000000003  R11: 0000000000000001  R12: 0000000000000000
>    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
>    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> --- <exception stack> ---
>  #7 [ffff88012f2d7ed8] default_idle at ffffffff80211d9d
>  #8 [ffff88012f2d7ee0] c1e_idle at ffffffff80211fc5
>  #9 [ffff88012f2d7f10] cpu_idle at ffffffff8020aca0
>
> I'm interested in helping arrive at a solution and any workarounds.
> Please let me know if there's anything else useful that I can provide.
>
> Thanks.
>
> --Kaleb
>
