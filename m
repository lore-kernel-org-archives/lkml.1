Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbZCMAxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbZCMAxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbZCMAxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:53:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:19103 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754139AbZCMAxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:53:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=OuxauMhG51Cag4vho0It1UX0+Mx3ON1PHcz9G2tXuzbWPiAAXWCRLAAMZ3bZVsKo2f
         LfPJ2fZNiiqbUtAnSPVVvbEAiqr7vAdIaoJ+obYVWbfX9cfj84zTxw6hY/IhUTQion98
         8POz2oAqNeBw4W/DTk9Ow/bsMIzqw9EzOGZIA=
MIME-Version: 1.0
Date: Thu, 12 Mar 2009 17:53:11 -0700
Message-ID: <f14c01620903121753j34de8bf0j28ba3339e560d5db@mail.gmail.com>
Subject: kernel lockup - copy_user_generic_string+45 -> oops?
From: Kaleb Pederson <kaleb.pederson@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm experiencing random but frequent lockups on a newly built system.
I installed a crashkernel and was able to produce a crash dump which
follows:

crash> bt -a
PID: 11672  TASK: ffff88012960d260  CPU: 0   COMMAND: "strings"
 #0 [ffffffff807e8cd0] machine_kexec at ffffffff8021ef5b
 #1 [ffffffff807e8db0] crash_kexec at ffffffff8026326e
 #2 [ffffffff807e8e80] oops_end at ffffffff80554115
 #3 [ffffffff807e8eb0] die_nmi at ffffffff805542ba
 #4 [ffffffff807e8ee0] nmi_watchdog_tick at ffffffff8055461a
 #5 [ffffffff807e8f20] do_nmi at ffffffff80553bc7
 #6 [ffffffff807e8f50] nmi at ffffffff8055398a
    [exception RIP: copy_user_generic_string+45]
    RIP: ffffffff803ca68d  RSP: ffff88012dcb5c60  RFLAGS: 00000246
    RAX: ffff880000000000  RBX: ffff88012dcb5d08  RCX: 00000000000000af
    RDX: 0000000000000000  RSI: ffff8801190d1a88  RDI: 00007f5e594f6a98
    RBP: ffff88012dcb5c98   R8: 0000000000010287   R9: ffffe20003d7adc0
    R10: 0000000000000002  R11: 0000000000000001  R12: 0000000000001000
    R13: 0000000000096000  R14: ffffe20003d7adb8  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #7 [ffff88012dcb5c60] copy_user_generic_string at ffffffff803ca68d
 #8 [ffff88012dcb5c60] file_read_actor at ffffffff802851f1
 #9 [ffff88012dcb5ca0] generic_file_aio_read at ffffffff80284ee5
#10 [ffff88012dcb5d70] xfs_read at ffffffff803926d4
#11 [ffff88012dcb5dd0] xfs_file_aio_read at ffffffff8038f11b
#12 [ffff88012dcb5de0] do_sync_read at ffffffff802ab19d
#13 [ffff88012dcb5f10] vfs_read at ffffffff802ab960
#14 [ffff88012dcb5f40] sys_read at ffffffff802abd1c
#15 [ffff88012dcb5f80] system_call_fastpath at ffffffff8020bf5b
    RIP: 00007f5e59647860  RSP: 00007fff61ffcd80  RFLAGS: 00010202
    RAX: 0000000000000000  RBX: ffffffff8020bf5b  RCX: 00007f5e596507da
    RDX: 0000000000359000  RSI: 00007f5e59233010  RDI: 000000000000000a
    RBP: 0000000000609200   R8: 00007f5e59fd46f0   R9: 00007f5e59233010
    R10: 0000000000200000  R11: 0000000000000246  R12: 00000000003599af
    R13: 00007f5e59233010  R14: 00000000003599af  R15: 0000000000000000
    ORIG_RAX: 0000000000000000  CS: 0033  SS: 002b

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
    R10: 0000000000000022  R11: 0000000000000246  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #7 [ffff88012f26ded8] default_idle at ffffffff80211d9d
 #8 [ffff88012f26dee0] c1e_idle at ffffffff80211fc5
 #9 [ffff88012f26df10] cpu_idle at ffffffff8020aca0

PID: 0      TASK: ffff88012f2a1450  CPU: 2   COMMAND: "swapper"
 #0 [ffff88012f2a9e80] crash_nmi_callback at ffffffff8021b588
 #1 [ffff88012f2a9e90] notifier_call_chain at ffffffff80555ac6
 #2 [ffff88012f2a9ed0] __atomic_notifier_call_chain at ffffffff80555b05
 #3 [ffff88012f2a9ee0] atomic_notifier_call_chain at ffffffff80555b16
 #4 [ffff88012f2a9ef0] notify_die at ffffffff8024f776
 #5 [ffff88012f2a9f20] do_nmi at ffffffff80553bb1
 #6 [ffff88012f2a9f50] nmi at ffffffff8055398a
    [exception RIP: default_idle+43]
    RIP: ffffffff80211d9d  RSP: ffff88012f2a3ed8  RFLAGS: 00000246
    RAX: ffff88012f2a3fd8  RBX: ffffffff8076bbb8  RCX: 00000000c0010055
    RDX: 0000000000000000  RSI: 0000000000000001  RDI: ffffffff806b4d90
    RBP: ffff88012f2a3ed8   R8: 0000000000000000   R9: 0000000000000002
    R10: 0000000000000003  R11: 0000000000000001  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #7 [ffff88012f2a3ed8] default_idle at ffffffff80211d9d
 #8 [ffff88012f2a3ee0] c1e_idle at ffffffff80211fc5
 #9 [ffff88012f2a3f10] cpu_idle at ffffffff8020aca0

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
    R10: 0000000000000003  R11: 0000000000000001  R12: 0000000000000000
    R13: 0000000000000000  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
--- <exception stack> ---
 #7 [ffff88012f2d7ed8] default_idle at ffffffff80211d9d
 #8 [ffff88012f2d7ee0] c1e_idle at ffffffff80211fc5
 #9 [ffff88012f2d7f10] cpu_idle at ffffffff8020aca0

I'm interested in helping arrive at a solution and any workarounds.
Please let me know if there's anything else useful that I can provide.

Thanks.

--Kaleb
