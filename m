Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZGDWP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZGDWP7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 18:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZGDWPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 18:15:49 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:47822 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbZGDWPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 18:15:48 -0400
X-Greylist: delayed 302 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jul 2009 18:15:47 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=UR4fApodHFMNmybISUJlwqHGw9Qd3lILOz860heORYkdHPb1GA+Hmjcejl3qDSU+ut
         BpO3pDSYP22jm8Ul/6+2XaMlzYhhz6sVyM1R43Sl9BKBKNsFnhY00KreiQA5a2VIzs/G
         BZGw8j4U5Bz5wm08P6cfWPn3wgH/0OfvJ2Pg4=
From: Alberto Gonzalez <alberto6674@gmail.com>
To: Michal Soltys <soltys@ziu.info>
Subject: Re: Kernel 2.6.30 and udevd problem
Date: Sun, 5 Jul 2009 00:10:43 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29-ARCH; KDE/4.2.4; x86_64; ; )
Cc: Alberto Gonzalez <alberto6674@gmail.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Dave Airlie <airlied@linux.ie>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       linux-hotplug@vger.kernel.org
References: <200906280821.58631.info@gnebu.es> <200907022137.27847.info@gnebu.es> <4A4D2E11.4020707@ziu.info>
In-Reply-To: <4A4D2E11.4020707@ziu.info>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907050010.44254.info@gnebu.es>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 July 2009 00:00:49 Michal Soltys wrote:
> Regarding Arch's default distro kernel - it's a bit patched. Most of the
> patch file is addition of aufs, but there're other diffs included as
> well, some of them modifying i915_reg.h, intel_display.c and intel_tv.c
>
> ftp://ftp.archlinux.org/other/kernel26/patch-2.6.30-5-ARCH.bz2
>
> Not sure how relevant that is, but fyi.

Yes, thanks for pointing that out.

I now tried a vanilla 2.6.30.1 kernel with a custom config (so I don't have to 
wait 45 minutes for it to compile) and I still see the problem. This is what I 
get in dmesg:

[   83.506496] ------------[ cut here ]------------
[   83.506500] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 
drm_sysfs_hotplug_event+0x2b/0x63()
[   83.506502] Hardware name: Studio 540
[   83.506503] hotplug uevent
[   83.506504] Modules linked in:
[   83.506506] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
[   83.506507] Call Trace:
[   83.506511]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
[   83.506514]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
[   83.506517]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
[   83.506520]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
[   83.506523]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
[   83.506525]  [<c1032f28>] worker_thread+0x131/0x1ab
[   83.506528]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
[   83.506531]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
[   83.506534]  [<c1032df7>] ? worker_thread+0x0/0x1ab
[   83.506536]  [<c1035c84>] kthread+0x46/0x6a
[   83.506538]  [<c1035c3e>] ? kthread+0x0/0x6a
[   83.506541]  [<c10033cf>] kernel_thread_helper+0x7/0x10
[   83.506542] ---[ end trace 08f91010f92f7c3c ]---

Thanks,
Alberto.
