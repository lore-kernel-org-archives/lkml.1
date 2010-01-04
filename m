Return-Path: <linux-kernel-owner+w=401wt.eu-S1753613Ab0ADWSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0ADWSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:18:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446Ab0ADWST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:18:19 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:46272 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0ADWST convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:18:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=I4YEWi+iwbHWWWErEXELdOBDUeGCIXelKuY+vfDG1sS7dV5Wpnsf4dULEETyG7wK+x
         RfXnqE3hLrybWH/poHUb4QLyHuONRte9aIzuCliV9zD2Y6jjNmyq8djiwXjX8ch1jvvJ
         hS+8fXJLHecV3pHS5fHovaC6IfGPO1kYqdrKY=
MIME-Version: 1.0
In-Reply-To: <20100104090221.6f6fc0a6@jbarnes-piketon>
References: <c4e36d111001040827v850c94ev7166ac02f52e9a38@mail.gmail.com> 
	<20100104090221.6f6fc0a6@jbarnes-piketon>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 4 Jan 2010 17:17:57 -0500
X-Google-Sender-Auth: 98cd2af386b3dcfe
Message-ID: <cb0375e11001041417t354b2da0s41bee7f8777cb2cb@mail.gmail.com>
Subject: Re: i915 drm fails to resume with modeset = 0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       airlied@redhat.com, ajax@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did my fix get lost?  There's a duplicate save/restore of RC6, too.

--Andy

On Mon, Jan 4, 2010 at 12:02 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Mon, 4 Jan 2010 17:27:21 +0100
> Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:
>
>> Hi
>>
>> Resume seems to fail when i915 modeset is 0.  Machine produces
>> following oops:
>>
>> [drm:intel_init_clock_gating] *ERROR* failed to pin power context: -16
>> ------------[ cut here ]------------
>> kernel BUG at drivers/gpu/drm/drm_gem.c:438!
>> invalid opcode: 0000 [#1] PREEMPT SMP
>> last sysfs file: /sys/power/state
>> CPU 0
>> Pid: 2621, comm: pm-suspend Not tainted 2.6.33-rc2-00270-gc31ac8b #49
>> 6464CTO/6464CTO
>> RIP: 0010:[<ffffffffa031482a>]  [<ffffffffa031482a>]
>> drm_gem_object_free+0x5a/0x60 [drm]
>> RSP: 0000:ffff880139cddca8  EFLAGS: 00010246
>> RAX: 0000000000000001 RBX: ffff880139f5f000 RCX: 0000000000000000
>> RDX: 0000000000000001 RSI: ffffffffa03147d0 RDI: ffff880137e1a780
>> RBP: ffff880139cddcb8 R08: 0000000000000001 R09: 0000000000000001
>> R10: 0000000000000000 R11: 0000000000000000 R12: ffff880137e1a780
>> R13: 0000000000000000 R14: 0000000000000000 R15: ffff88013a13c870
>> FS:  00007fdcfaf78700(0000) GS:ffff88002be00000(0000)
>> knlGS:0000000000000000 CS:  0010 DS: 0000 ES: 0000 CR0:
>> 000000008005003b CR2: 00007fd607b1b440 CR3: 0000000139e6b000 CR4:
>> 00000000000006f0 DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> 0000000000000000 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
>> 0000000000000400 Process pm-suspend (pid: 2621, threadinfo
>> ffff880139cdc000, task ffff88013bd64640)
>> Stack:
>>  ffff880137e1a780 ffffffffa03147d0 ffff880139cddcd8 ffffffff81245a07
>> <0> ffff880137e1a780 ffff88013976c000 ffff880139cddce8
>> ffffffffa03779ea <0> ffff880139cddd08 ffffffffa0379bdf
>> ffff88013976c000 ffff880139f5f000 Call Trace:
>>  [<ffffffffa03147d0>] ? drm_gem_object_free+0x0/0x60 [drm]
>>  [<ffffffff81245a07>] kref_put+0x37/0x70
>>  [<ffffffffa03779ea>] drm_gem_object_unreference+0x1a/0x20 [i915]
>>  [<ffffffffa0379bdf>] intel_init_clock_gating+0x32f/0x350 [i915]
>>  [<ffffffffa03675b2>] i915_restore_state+0x202/0x350 [i915]
>>  [<ffffffffa035c097>] i915_resume+0x77/0x100 [i915]
>>  [<ffffffffa031b410>] ? drm_class_resume+0x0/0x50 [drm]
>>  [<ffffffffa031b45b>] drm_class_resume+0x4b/0x50 [drm]
>>  [<ffffffff812fd094>] legacy_resume+0x34/0x80
>>  [<ffffffff812fda19>] dpm_resume_end+0x409/0x430
>>  [<ffffffff81092ae4>] suspend_devices_and_enter+0x124/0x1a0
>>  [<ffffffff81092c3a>] enter_state+0xda/0xf0
>>  [<ffffffff810922f9>] state_store+0x99/0x100
>>  [<ffffffff81244237>] kobj_attr_store+0x17/0x20
>>  [<ffffffff81185fb6>] sysfs_write_file+0xe6/0x170
>>  [<ffffffff811222d8>] vfs_write+0xb8/0x1a0
>>  [<ffffffff81122d31>] sys_write+0x51/0x90
>>  [<ffffffff8100309b>] system_call_fastpath+0x16/0x1b
>> Code: d0 49 8b 7c 24 10 e8 16 f6 e0 e0 f0 ff 8b e0 0a 00 00 41 8b 44
>> 24 60 f0 29 83 e4 0a 00 00 4c 89 e7 e8 cb 57 e0 e0 5b 41 5c c9 c3 <0f>
>> 0b eb fe 66 90 55 48 89 e5 48 83 ec 10 48 89 1c 24 4c 89 64
>> RIP  [<ffffffffa031482a>] drm_gem_object_free+0x5a/0x60 [drm]
>>  RSP <ffff880139cddca8>
>> ---[ end trace e7a3fdc0abc1c39d ]---
>>
>>
>> Hardware is  T61, 4GB, GMA950, 64bit kernel
>>
>> I think the problem is visible on kernels 2.6.32,  33-rcX
>>
>> Zdenek
>
> Something like this might work:
>
> diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_d
> index 279dc96..3f46f81 100644
> --- a/drivers/gpu/drm/i915/intel_display.c
> +++ b/drivers/gpu/drm/i915/intel_display.c
> @@ -4579,7 +4579,7 @@ void intel_init_clock_gating(struct drm_device *dev)
>         * GPU can automatically power down the render unit if given a page
>         * to save state.
>         */
> -       if (I915_HAS_RC6(dev)) {
> +       if (I915_HAS_RC6(dev) && drm_core_check_feature(dev, DRIVER_MODESET)) {
>                struct drm_gem_object *pwrctx;
>                struct drm_i915_gem_object *obj_priv;
>                int ret;
>
>
