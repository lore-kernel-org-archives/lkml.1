Return-Path: <linux-kernel-owner+w=401wt.eu-S1758909AbXKMVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909AbXKMVuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 16:50:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758519AbXKMVuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 16:50:35 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53983 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756794AbXKMVue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 16:50:34 -0500
Date: Tue, 13 Nov 2007 13:49:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH series] DRM memory manager core
Message-Id: <20071113134948.635eea83.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0711050612110.8487@skynet.skynet.ie>
References: <Pine.LNX.4.64.0711050612110.8487@skynet.skynet.ie>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007 06:29:26 +0000 (GMT) Dave Airlie <airlied@linux.ie> wrote:

> These patches are the first set of patches containing the core components 
> of the DRI memory manger from Tungsten Graphics.


Something in your tree makes my i915-based Vaio oops when running glxgears:


[  140.659360] BUG: unable to handle kernel NULL pointer dereference at virtual address 0000000c
[  140.659379] printing eip: f8c511b6 *pde = 00000000 
[  140.659395] Oops: 0000 [#1] PREEMPT 
[  140.659411] last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed
[  140.659419] Modules linked in: i915 drm ipw2200 sonypi ipv6 autofs4 hidp l2cap bluetooth sunrpc nf_conntrack_netbios_ns ipt_REJECT nf_conntrack_ipv4 xt_state nf_conntrack xt_tcpudp iptable_filter ip_tables x_tables acpi_cpufreq nvram ohci1394 ehci_hcd ieee1394 uhci_hcd joydev sg snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device sr_mod snd_pcm_oss cdrom snd_mixer_oss snd_pcm snd_timer i2c_i801 piix pcspkr generic snd ieee80211 soundcore ieee80211_crypt i2c_core snd_page_alloc button ext3 jbd ide_disk ide_core
[  140.659677] 
[  140.659685] Pid: 3525, comm: glxgears Not tainted (2.6.24-rc2-mm1 #2)
[  140.659693] EIP: 0060:[<f8c511b6>] EFLAGS: 00010046 CPU: 0
[  140.659725] EIP is at drm_fence_flush_old+0x3d/0xf4 [drm]
[  140.659731] EAX: 00000000 EBX: f6240468 ECX: 00000282 EDX: 00000000
[  140.659738] ESI: 00000002 EDI: 00000002 EBP: e8c33ec8 ESP: e8c33ea8
[  140.659745]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  140.659752] Process glxgears (pid: 3525, ti=E8C32000 task=F113E170 task.ti=E8C32000)
[  140.659758] Stack: f6240000 f624044c 00000000 f13919a0 f62690b8 f737b200 08be829c 000176b8 
[  140.659803]        e8c33f1c f8dbdc76 00000013 f1391cc0 f6240000 f737b200 f8c6d898 00000001 
[  140.659850]        00000001 f737b200 f8e40000 0001ffff 00000013 f737b200 08be8250 00000000 
[  140.659896] Call Trace:
[  140.659906]  [<c0104cec>] show_trace_log_lvl+0x12/0x25
[  140.659921]  [<c0104d8b>] show_stack_log_lvl+0x8c/0x9e
[  140.659932]  [<c0104e27>] show_registers+0x8a/0x1c0
[  140.659944]  [<c010504b>] die+0xee/0x1c4
[  140.659954]  [<c0116a2c>] do_page_fault+0x405/0x4e1
[  140.659966]  [<c031fa22>] error_code+0x6a/0x70
[  140.659979]  [<f8dbdc76>] i915_cmdbuffer+0x3a4/0x3e8 [i915]
[  140.659997]  [<f8c4a73c>] drm_ioctl+0x1ac/0x228 [drm]
[  140.660028]  [<c0179bca>] vfs_ioctl+0x4e/0x67
[  140.660041]  [<c0179e45>] do_vfs_ioctl+0x262/0x279
[  140.660053]  [<c0179e9c>] sys_ioctl+0x40/0x5c
[  140.660064]  [<c0103da2>] syscall_call+0x7/0xb
[  140.660165]  =======================
[  140.660170] INFO: lockdep is turned off.



Pulled yesterday, head is

GIT 1d9e76b53ce8ff0b15b43b679801226add747d4e git+ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git#drm-mm

commit 
Author: Dave Airlie <airlied@linux.ie>
Date:   Mon Nov 5 16:59:20 2007 +1000

    drm/ttm: fix build with AGP disabled


This:

--- a/drivers/char/drm/drm_fence.c~a
+++ a/drivers/char/drm/drm_fence.c
@@ -305,6 +305,9 @@ void drm_fence_flush_old(struct drm_devi
 	struct drm_fence_object *fence;
 	uint32_t diff;
 
+	if (!driver)
+		return;
+
 	write_lock_irqsave(&fm->lock, flags);
 	old_sequence = (sequence - driver->flush_diff) & driver->sequence_mask;
 	diff = (old_sequence - fc->last_exe_flush) & driver->sequence_mask;
_

stops the oops and gets glxgears working OK, so I'll be able to include
git-drm.patch in rc2-mm1, hopefully in a couple of hours from now. 
Hopefully this bug won't affect other drivers..
