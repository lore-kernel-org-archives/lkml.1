Return-Path: <linux-kernel-owner+w=401wt.eu-S1755718AbXKSWQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbXKSWQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 17:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbXKSWQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 17:16:30 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39303 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbXKSWQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 17:16:29 -0500
Date: Mon, 19 Nov 2007 14:15:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: waldo.bastian@intel.com, airlied@gmail.com,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Prospects of DRM TTM making it into 2.6.24?
Message-Id: <20071119141554.649b590e.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.0.82.0711192151010.1284@skynet.skynet.ie>
References: <1B47D24854C7BC4FA8DA28BEBB59B0BA029CD00D@orsmsx419.amr.corp.in
 tel.com>
	<alpine.DEB.0.82.0711192151010.1284@skynet.skynet.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Nov 2007 21:53:05 +0000 (GMT)
Dave Airlie <airlied@linux.ie> wrote:

> 
> > What are the prospects of the DRM TTM changes making it into 2.6.24? I 
> > noticed that Andrew has them [1] in his mm tree... any chance of that 
> > getting pushed into Linus' tree for 2.6.24?
> > 
> 
> No the merge window for 2.6.24 closed a few weeks ago. TTM wasn't in -mm 
> for the 2.6.23 cycle as we hadn't finished the API stabilisation work in 
> time. So I don't expect we'll see it before 2.6.25.
> 
> I also have a few AGP changes I need to line up to support the chipset 
> flushing work I've done to support TTM properly..
> 

Did anything happen with that null-pointer deref I was hitting?



From: Andrew Morton <akpm@linux-foundation.org>

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

Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/drm/drm_fence.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN drivers/char/drm/drm_fence.c~git-drm-oops-fix drivers/char/drm/drm_fence.c
--- a/drivers/char/drm/drm_fence.c~git-drm-oops-fix
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

