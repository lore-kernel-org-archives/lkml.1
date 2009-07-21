Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbZGUVOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbZGUVOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 17:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZGUVOA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 17:14:00 -0400
Received: from outbound-mail-121.bluehost.com ([67.222.38.21]:39021 "HELO
	outbound-mail-121.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754111AbZGUVN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 17:13:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Kow9YkgEefdIZ93tlSw2T92AmP5o5to3/Z/N3199WFRNTs03NFrEHvuCmJLcLXTCHU8AztpqWDeXJIW1+GsbRevt/vabYW29L1YvOlt/F6YDRuWrUvD7IvjOfk03U2ZZ;
Date: Tue, 21 Jul 2009 14:07:18 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Diego Calleja <diegocg@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>, Eric Anholt <eric@anholt.net>,
       airlied@gmail.com, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: KMS oops on 945G system
Message-ID: <20090721140718.371af9b9@jbarnes-g45>
In-Reply-To: <200907212250.31353.diegocg@gmail.com>
References: <200907212250.31353.diegocg@gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Jul 2009 22:50:31 +0200
Diego Calleja <diegocg@gmail.com> wrote:

> Hi, I'm hitting an oops when I try to enable kernel modesetting. I'm
> using one of the latests git snapshots, the one which includes some
> DRM fixes (2.6.31-rc3-00096-g78af08d-dirty). It's not a regression,
> it's the first time I try this. xserver-xorg-video-intel version is
> what was released today, 2.8.0. The problem seems to be a "division
> error" here:
> 
> (gdb) l *(intel_update_watermarks+0x5c2)
> 0x12652 is in intel_update_watermarks
> (drivers/gpu/drm/i915/intel_display.c:1881). 1876            if
> (!planea_clock || !planeb_clock) { 1877                    sr_clock =
> planea_clock ? planea_clock : planeb_clock; 1878
> line_time_us = (sr_hdisplay * 1000) / sr_clock;
> 1879                    sr_entries = (((latency_ns / line_time_us) +
> 1) * pixel_size * 1880
> sr_hdisplay) / 1000; 1881                    sr_entries =
> roundup(sr_entries / wm_params->cacheline_size, 1);
> 1882                    if (sr_entries < wm_params->fifo_size)
> 1883                            srwm = wm_params->fifo_size -
> sr_entries; 1884            }
> 
> 
> which according to git it seems to be code from this commit:
> 
> commit 7662c8bd6545c12ac7b2b39e4554c3ba34789c50
> Author: Shaohua Li <shaohua.li@intel.com>
> 
>     drm/i915: add FIFO watermark support

Yep, my bug.  Should be fixed in Eric's drm-intel-next branch:
http://git.kernel.org/?p=linux/kernel/git/anholt/drm-intel.git;a=shortlog;h=drm-intel-next

-- 
Jesse Barnes, Intel Open Source Technology Center
