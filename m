Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbYLKCi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbYLKCi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 21:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754342AbYLKCiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 21:38:19 -0500
Received: from mail-bw0-f13.google.com ([209.85.218.13]:48340 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754156AbYLKCiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 21:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iRCctaW+nLykvaGBPZ1U0yyoAcN0cpI7C5Y5PBESHI5hRjAS64s5qTgr6+bdoq3F3F
         +LVMcZIm+u7GgH5xw/heUosEoEeV7LCtWoZb6ZvhXKi/bL/fyTjzbhRDkOF2DhzZX22c
         Muf5tbHYsUk0rA4nOU63MGiRwyD6S1H8m0D/o=
Message-ID: <49407CE1.9090600@googlemail.com>
Date: Thu, 11 Dec 2008 03:37:21 +0100
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081122)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.28-rc8
References: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812101651130.3340@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While I got some time again I decided to test rc8 and noticed the following warning :

...

[   23.090942] resource map sanity check conflict: 0xd0000000 0xdfffffff 0xd0000000 0xd07effff vesafb
[   23.090948] ------------[ cut here ]------------
[   23.090951] WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0xc7/0x2c9()
[   23.090952] Modules linked in: i915 binfmt_misc acpi_cpufreq freq_table w83627ehf hwmon_vid fuse loop lp ppdev joydev i2c_i801 parport_pc button evdev parport intel_agp processor sg pcspkr
[   23.090969] Pid: 4632, comm: X Not tainted 2.6.28-rc8-dirty #25
[   23.090971] Call Trace:
[   23.090976]  [<ffffffff8024106f>] warn_on_slowpath+0x58/0x7d
[   23.090979]  [<ffffffff8022c255>] ? change_page_attr_set_clr+0x136/0x304
[   23.090982]  [<ffffffff8022c65b>] ? _set_memory_uc+0x22/0x24
[   23.090985]  [<ffffffff8022b0a3>] ? ioremap_change_attr+0x18/0x28
[   23.090989]  [<ffffffff8022b17a>] __ioremap_caller+0xc7/0x2c9
[   23.090997]  [<ffffffffa00b1e1e>] ? i915_gem_entervt_ioctl+0x451/0x4e6 [i915]
[   23.091000]  [<ffffffff8022b46c>] ioremap_wc+0x1b/0x27
[   23.091006]  [<ffffffffa00b1e1e>] i915_gem_entervt_ioctl+0x451/0x4e6 [i915]
[   23.091010]  [<ffffffff802a8f6f>] ? do_sync_write+0xe7/0x12d
[   23.091014]  [<ffffffff803e1e36>] drm_ioctl+0x1d6/0x25e
[   23.091020]  [<ffffffffa00b19cd>] ? i915_gem_entervt_ioctl+0x0/0x4e6 [i915]
[   23.091024]  [<ffffffff802b55d9>] vfs_ioctl+0x5f/0x78
[   23.091026]  [<ffffffff802b5984>] do_vfs_ioctl+0x392/0x3c0
[   23.091030]  [<ffffffff80554049>] ? _spin_unlock+0x9/0x32
[   23.091033]  [<ffffffff802b5a07>] sys_ioctl+0x55/0x77
[   23.091036]  [<ffffffff8020c15a>] system_call_fastpath+0x16/0x1b
[   23.091038] ---[ end trace 79a035f1175c4e1d ]---

...


I'm sure this warning was not present on rc1/rc2 back when I've tested these.
Also this warning is not present in 2.6.27.*


Regards,

Gabriel C

