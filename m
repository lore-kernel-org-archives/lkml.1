Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968331Ab0B0Ng6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 08:36:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:47374 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968286Ab0B0Ng5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 08:36:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=wv/SMaIY8miaGXvAAxVFJGctuHKMmAveGtsm98/hHsTSpzWZ1JqVqQs2OuCT3ap1bi
         AsMfv1so4d+3rfnETRBdL/rpJDQF0NMjpelx1PfUCqycFs98Xa/LxT7m0lsGnww4F4Rm
         OnV6cHzXO9TIuVWzVruq3IRFIJg6F6xlvj88M=
MIME-Version: 1.0
Date: Sat, 27 Feb 2010 14:36:54 +0100
Message-ID: <d9def9db1002270536t76b7c262u7bc389fe245e5c85@mail.gmail.com>
Subject: Linux 2.6.33 Bugs (CUSE)
From: Markus Rechberger <mrechberger@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

following comes up when cusexmp gets started twice:
$ ./cusexmp --name=foo /foo

[28778.753168] ------------[ cut here ]------------
[28778.753178] WARNING: at fs/sysfs/dir.c:487 sysfs_add_one+0xc5/0x130()
[28778.753181] Hardware name: UL80VT
[28778.753183] sysfs: cannot create duplicate filename
'/devices/virtual/cuse/foo'
[28778.753185] Modules linked in: cuse uinput snd_hda_codec_realtek
nfsd exportfs snd_hda_intel nfs snd_hda_codec lockd snd_pcm_oss
snd_mixer_oss snd_hwdep nfs_acl fbcon snd_seq_dummy snd_pcm tileblit
auth_rpcgss font bitblit softcursor snd_seq_oss snd_seq_midi
snd_rawmidi snd_seq_midi_event i915 sunrpc arc4 snd_seq drm_kms_helper
iwlagn snd_timer iwlcore drm uvcvideo snd_seq_device i2c_algo_bit
videodev asus_laptop psmouse mac80211 video v4l1_compat snd output
intel_agp atl1c led_class v4l2_compat_ioctl32 serio_raw soundcore
btusb cfg80211 snd_page_alloc
[28778.753239] Pid: 19677, comm: lt-cusexmp Not tainted 2.6.33 #4
[28778.753241] Call Trace:
[28778.753248]  [<ffffffff81057f48>] warn_slowpath_common+0x78/0xb0
[28778.753252]  [<ffffffff81057fdc>] warn_slowpath_fmt+0x3c/0x40
[28778.753256]  [<ffffffff81190b25>] sysfs_add_one+0xc5/0x130
[28778.753260]  [<ffffffff81190bf3>] create_dir+0x63/0xb0
[28778.753264]  [<ffffffff81190c74>] sysfs_create_dir+0x34/0x50
[28778.753270]  [<ffffffff8127f98a>] ? kobject_get+0x1a/0x30
[28778.753273]  [<ffffffff8127fae7>] kobject_add_internal+0xb7/0x200
[28778.753277]  [<ffffffff8127fd58>] kobject_add_varg+0x38/0x60
[28778.753281]  [<ffffffff8127fe34>] kobject_add+0x44/0x70
[28778.753287]  [<ffffffff8132f945>] ? get_device_parent+0xc5/0x1b0
[28778.753291]  [<ffffffff81330b6b>] device_add+0xbb/0x5d0
[28778.753294]  [<ffffffff8132fe2c>] ? dev_set_name+0x3c/0x40
[28778.753300]  [<ffffffffa01a25b4>] cuse_process_init_reply+0x2a4/0x450 [cuse]
[28778.753305]  [<ffffffffa01a2310>] ? cuse_process_init_reply+0x0/0x450 [cuse]
[28778.753311]  [<ffffffff812128ab>] request_end+0x16b/0x200
[28778.753315]  [<ffffffff812135e2>] fuse_dev_write+0x3a2/0x4f0
[28778.753321]  [<ffffffff811024ab>] ? __vma_link_rb+0x2b/0x30
[28778.753325]  [<ffffffff81213240>] ? fuse_dev_write+0x0/0x4f0
[28778.753330]  [<ffffffff8112880b>] do_sync_readv_writev+0xcb/0x110
[28778.753336]  [<ffffffff81540960>] ? _raw_spin_lock_irq+0x10/0x20
[28778.753340]  [<ffffffff810fcce9>] ? __do_fault+0x409/0x4d0
[28778.753344]  [<ffffffff8122df41>] ? security_file_permission+0x11/0x20
[28778.753348]  [<ffffffff811297fa>] do_readv_writev+0xca/0x1f0
[28778.753354]  [<ffffffff8102f789>] ? default_spin_lock_flags+0x9/0x10
[28778.753358]  [<ffffffff81283936>] ? __up_read+0xa6/0xd0
[28778.753361]  [<ffffffff8112995e>] vfs_writev+0x3e/0x60
[28778.753364]  [<ffffffff81129a8c>] sys_writev+0x4c/0xb0
[28778.753369]  [<ffffffff81009f42>] system_call_fastpath+0x16/0x1b
[28778.753372] ---[ end trace fba55b2689d0febd ]---
[28778.753376] kobject_add_internal failed for foo with -EEXIST, don't
try to register things with the same name in the same directory.
[28778.753381] Pid: 19677, comm: lt-cusexmp Tainted: G        W  2.6.33 #4
[28778.753383] Call Trace:
[28778.753387]  [<ffffffff8127fb8d>] kobject_add_internal+0x15d/0x200
[28778.753391]  [<ffffffff8127fd58>] kobject_add_varg+0x38/0x60
[28778.753395]  [<ffffffff8127fe34>] kobject_add+0x44/0x70
[28778.753399]  [<ffffffff8132f945>] ? get_device_parent+0xc5/0x1b0
[28778.753402]  [<ffffffff81330b6b>] device_add+0xbb/0x5d0
[28778.753406]  [<ffffffff8132fe2c>] ? dev_set_name+0x3c/0x40
[28778.753410]  [<ffffffffa01a25b4>] cuse_process_init_reply+0x2a4/0x450 [cuse]
[28778.753414]  [<ffffffffa01a2310>] ? cuse_process_init_reply+0x0/0x450 [cuse]
[28778.753419]  [<ffffffff812128ab>] request_end+0x16b/0x200
[28778.753423]  [<ffffffff812135e2>] fuse_dev_write+0x3a2/0x4f0
[28778.753427]  [<ffffffff811024ab>] ? __vma_link_rb+0x2b/0x30
[28778.753431]  [<ffffffff81213240>] ? fuse_dev_write+0x0/0x4f0
[28778.753435]  [<ffffffff8112880b>] do_sync_readv_writev+0xcb/0x110
[28778.753439]  [<ffffffff81540960>] ? _raw_spin_lock_irq+0x10/0x20
[28778.753443]  [<ffffffff810fcce9>] ? __do_fault+0x409/0x4d0
[28778.753446]  [<ffffffff8122df41>] ? security_file_permission+0x11/0x20
[28778.753450]  [<ffffffff811297fa>] do_readv_writev+0xca/0x1f0
[28778.753454]  [<ffffffff8102f789>] ? default_spin_lock_flags+0x9/0x10
[28778.753458]  [<ffffffff81283936>] ? __up_read+0xa6/0xd0
[28778.753461]  [<ffffffff8112995e>] vfs_writev+0x3e/0x60
[28778.753465]  [<ffffffff81129a8c>] sys_writev+0x4c/0xb0
[28778.753469]  [<ffffffff81009f42>] system_call_fastpath+0x16/0x1b

Markus
