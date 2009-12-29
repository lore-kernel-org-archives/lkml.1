Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZL2WWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZL2WWL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 17:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZL2WWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 17:22:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbZL2WWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 17:22:05 -0500
Message-ID: <4B3A80FA.9030705@redhat.com>
Date: Tue, 29 Dec 2009 17:21:46 -0500
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>
CC: dri-devel mailing list <dri-devel@lists.sourceforge.net>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: radeon list corruption bug in 2.6.31.9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

here is a call trace of the list corruption I am seeing with
the latest Fedora kernel, 2.6.31.9-174.fc12.x86_64, on my
home system with two radeon video cards:

02:00.0 VGA compatible controller: ATI Technologies Inc RV730 [FirePro 
V5700]
03:00.0 VGA compatible controller: ATI Technologies Inc RV370 5B60 
[Radeon X300 (PCIE)]
03:00.1 Display controller: ATI Technologies Inc RV370 [Radeon X300SE]

Usually these get followed quite quickly by a kernel crash, but
I got a few today that allowed me to make this nice cut'n'paste
for you.

I tried out the 2.6.32.2 based rawhide kernel, but of course
that one did not even boot here, due to the other radeon issue :)

Is there anything I can do to help narrow down the issue, or has
the code been rewritten enough in 2.6.32 and 2.6.33 that I should
just upgrade to .32 once that one works?

------------[ cut here ]------------
WARNING: at lib/list_debug.c:30 __list_add+0x68/0x81() (Not tainted)
Hardware name: Precision WorkStation T3500
list_add corruption. prev->next should be next (ffff88032dc32da0), but 
was ffff8
800ad5aa530. (prev=ffff880292066730).
Modules linked in: fuse tun netconsole configfs autofs4 max6650 coretemp 
sunrpc bridge stp llc ipv6 cpufreq_ondemand acpi_cpufreq freq_table 
dm_multipath kvm_intel kvm uinput snd_hda_codec_analog snd_ens1371 
gameport snd_ac97_codec ppdev snd_hda_intel ac97_bus parport_pc 
snd_usb_audio pl2303 snd_hda_codec snd_seq snd_pcm snd_usb_lib 
snd_rawmidi snd_timer snd_seq_device snd_hwdep usbserial snd parport 
iTCO_wdt tg3 iTCO_vendor_support i2c_i801 dcdbas snd_page_alloc 
serio_raw soundcore wmi radeon ttm drm_kms_helper drm i2c_algo_bit 
i2c_core [last unloaded: microcode]
Pid: 1945, comm: Xorg Not tainted 2.6.31.9-174.fc12.x86_64 #1
Call Trace:
  [<ffffffff81051710>] warn_slowpath_common+0x84/0x9c
  [<ffffffff8105177f>] warn_slowpath_fmt+0x41/0x43
  [<ffffffffa004df78>] ? ttm_buffer_object_init+0x338/0x361 [ttm]
  [<ffffffff81207e23>] __list_add+0x68/0x81
  [<ffffffffa007ab3d>] radeon_object_create+0x1cb/0x1de [radeon]
  [<ffffffffa007a925>] ? radeon_ttm_object_object_destroy+0x0/0x4d [radeon]
  [<ffffffffa008586d>] radeon_gem_object_create+0x90/0xfe [radeon]
  [<ffffffffa0086e00>] ? radeon_cs_ioctl+0x14a/0x19a [radeon]
  [<ffffffffa00858db>] ? radeon_gem_create_ioctl+0x0/0xdf [radeon]
  [<ffffffffa0085935>] radeon_gem_create_ioctl+0x5a/0xdf [radeon]
  [<ffffffffa001521f>] drm_ioctl+0x237/0x2f4 [drm]
  [<ffffffff81108cc5>] vfs_ioctl+0x6f/0x87
  [<ffffffff811091d4>] do_vfs_ioctl+0x47b/0x4c1
  [<ffffffff81109270>] sys_ioctl+0x56/0x79
  [<ffffffff8141dd20>] ? do_device_not_available+0x9/0xb
  [<ffffffff81011cf2>] system_call_fastpath+0x16/0x1b
---[ end trace 6286fa6c2ff39104 ]---
