Return-Path: <linux-kernel-owner+w=401wt.eu-S1753252AbZGTSKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbZGTSKT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:10:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751644AbZGTSKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:10:18 -0400
Received: from outbound-mail-307.bluehost.com ([67.222.53.253]:38136 "HELO
	outbound-mail-307.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751451AbZGTSKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:10:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=HpgrG34oM5zcd8P0lN80EqGdSkJsBRbINDxU0d69A8yEoA+dTIymyKr+7CoupR/AqS8yEJW9bg7N4C1+gAvm1/ORJ4aPOLr7y5AQWOzDpM2xTL7WkjOrAngQbWQWtcRd;
Date: Mon, 20 Jul 2009 11:10:10 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alberto Gonzalez <alberto6674@gmail.com>
Cc: Michal Soltys <soltys@ziu.info>, Alberto Gonzalez <alberto6674@gmail.com>,
       Dave Airlie <airlied@linux.ie>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, linux-hotplug@vger.kernel.org
Subject: Re: Kernel 2.6.30 and udevd problem
Message-ID: <20090720111010.28bf7b76@jbarnes-g45>
In-Reply-To: <200907050010.44254.info@gnebu.es>
References: <200906280821.58631.info@gnebu.es>
	<200907022137.27847.info@gnebu.es>
	<4A4D2E11.4020707@ziu.info>
	<200907050010.44254.info@gnebu.es>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Jul 2009 00:10:43 +0200
Alberto Gonzalez <alberto6674@gmail.com> wrote:

> On Friday 03 July 2009 00:00:49 Michal Soltys wrote:
> > Regarding Arch's default distro kernel - it's a bit patched. Most
> > of the patch file is addition of aufs, but there're other diffs
> > included as well, some of them modifying i915_reg.h,
> > intel_display.c and intel_tv.c
> >
> > ftp://ftp.archlinux.org/other/kernel26/patch-2.6.30-5-ARCH.bz2
> >
> > Not sure how relevant that is, but fyi.
> 
> Yes, thanks for pointing that out.
> 
> I now tried a vanilla 2.6.30.1 kernel with a custom config (so I
> don't have to wait 45 minutes for it to compile) and I still see the
> problem. This is what I get in dmesg:
> 
> [   83.506496] ------------[ cut here ]------------
> [   83.506500] WARNING: at drivers/gpu/drm/drm_sysfs.c:452 
> drm_sysfs_hotplug_event+0x2b/0x63()
> [   83.506502] Hardware name: Studio 540
> [   83.506503] hotplug uevent
> [   83.506504] Modules linked in:
> [   83.506506] Pid: 7, comm: events/0 Tainted: G        W  2.6.30.1 #1
> [   83.506507] Call Trace:
> [   83.506511]  [<c1025df9>] warn_slowpath_common+0x65/0x7c
> [   83.506514]  [<c11e9f9e>] ? drm_sysfs_hotplug_event+0x2b/0x63
> [   83.506517]  [<c1025e44>] warn_slowpath_fmt+0x24/0x27
> [   83.506520]  [<c11e9f9e>] drm_sysfs_hotplug_event+0x2b/0x63
> [   83.506523]  [<c11f33de>] i915_hotplug_work_func+0xe/0x10
> [   83.506525]  [<c1032f28>] worker_thread+0x131/0x1ab
> [   83.506528]  [<c11f33d0>] ? i915_hotplug_work_func+0x0/0x10
> [   83.506531]  [<c1035f61>] ? autoremove_wake_function+0x0/0x2f
> [   83.506534]  [<c1032df7>] ? worker_thread+0x0/0x1ab
> [   83.506536]  [<c1035c84>] kthread+0x46/0x6a
> [   83.506538]  [<c1035c3e>] ? kthread+0x0/0x6a
> [   83.506541]  [<c10033cf>] kernel_thread_helper+0x7/0x10
> [   83.506542] ---[ end trace 08f91010f92f7c3c ]---

Sorry I missed this update; what about the register dump part of the
patch?  Presumably you get a ton of these in your log, but with some
IIR register info beforehand?

-- 
Jesse Barnes, Intel Open Source Technology Center
