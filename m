Return-Path: <linux-kernel-owner+w=401wt.eu-S1753423AbYJ0Iev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753423AbYJ0Iev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 04:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYJ0Iem
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 04:34:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:54138 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752041AbYJ0Iel (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 04:34:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=K1otC1gzBGJ7LHJQzMDp5y7gJChdmXhbPLAG+LrVSCFdkj5AX62BDH1K9jV+HD5zgl
         e6vDbQ5B9PTiPdwRSqqLLEUCzCgKySsNcfF5F8YUgVLj4gl2P/4/vFM3Kwnn7qLFiZg2
         DXuRhbRRYVbos+wyVK/gBzIk4GT/eC7PifOsc=
Message-ID: <a8e1da0810270134i26753dd1v6e9a5d122136bbbf@mail.gmail.com>
Date: Mon, 27 Oct 2008 16:34:40 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [BUG] hang with ath5k
Cc: "Jiri Slaby" <jirislaby@gmail.com>, ath5k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org,
       "kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <200810250040.24324.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0810140142g633486br12c2799b2fa1670e@mail.gmail.com>
	 <48F6133D.1070508@gmail.com>
	 <a8e1da0810152334x6c596f88i1fd74548dc166f3a@mail.gmail.com>
	 <200810250040.24324.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 6:40 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, 16 of October 2008, Dave Young wrote:
>> On Wed, Oct 15, 2008 at 11:58 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> > On 10/14/2008 10:42 AM, Dave Young wrote:
>> >> 1) run wpa_supplicant
>> >> 2) ctrl + C
>> >> 3) goto 1)
>> >
>> > It doesn't happen here. How many iterations in average you need to reproduce this?
>> >
>>
>> About 15 times for me,
>> BTW, wpa_gui running while testing
>
> Is this a regression from 2.6.26?
>
> Rafael
>

Test with 2.6.28-rc2,  run
wpa_supplicant -i wlan0 -c /etc/wpa_supplicant.conf,
kernel warning triggered:

[ 1648.091084] ------------[ cut here ]------------
[ 1648.091090] WARNING: at net/mac80211/rx.c:2201
__ieee80211_rx+0x1d0/0x5f0 [mac80211]()
[ 1648.091094] Modules linked in: rfcomm l2cap bluetooth container
fuse ath5k mac80211 led_class psmouse serio_raw sg cfg80211 e100 mii
intel_agp agpgart thermal button processor thermal_sys evdev
[ 1648.091127] Pid: 0, comm: swapper Not tainted 2.6.28-rc1-smp #15
[ 1648.091130] Call Trace:
[ 1648.091140]  [<c01318a9>] warn_on_slowpath+0x59/0x80
[ 1648.091148]  [<c01a15a6>] ? check_bytes_and_report+0x26/0xd0
[ 1648.091155]  [<c03f2b06>] ? __kfree_skb+0x36/0x90
[ 1648.091160]  [<c0157bff>] ? validate_chain+0xbf/0xea0
[ 1648.091165]  [<c03f2b06>] ? __kfree_skb+0x36/0x90
[ 1648.091170]  [<c0158c8a>] ? __lock_acquire+0x2aa/0x9a0
[ 1648.091187]  [<e01b7640>] __ieee80211_rx+0x1d0/0x5f0 [mac80211]
[ 1648.091199]  [<e017a001>] ? ath5k_hw_get_tsf64+0x51/0x90 [ath5k]
[ 1648.091205]  [<c0476e0e>] ? _spin_lock+0x5e/0x70
[ 1648.091215]  [<e01815f8>] ath5k_tasklet_rx+0x2f8/0x6b0 [ath5k]
[ 1648.091221]  [<c0158c8a>] ? __lock_acquire+0x2aa/0x9a0
[ 1648.091227]  [<c0137173>] tasklet_action+0x53/0xd0
[ 1648.091232]  [<c01368e7>] __do_softirq+0xa7/0x170
[ 1648.091237]  [<c0136a15>] do_softirq+0x65/0x70
[ 1648.091242]  [<c0136eb7>] irq_exit+0x77/0x90
[ 1648.091247]  [<c0106756>] do_IRQ+0x96/0xc0
[ 1648.091252]  [<c0104a0c>] common_interrupt+0x28/0x30
[ 1648.091258]  [<c015007b>] ? timer_list_show+0x14b/0xd70
[ 1648.091263]  [<c010b0a2>] ? default_idle+0x42/0x60
[ 1648.091267]  [<c010279e>] cpu_idle+0x6e/0xc0
[ 1648.091272]  [<c04646f3>] rest_init+0x53/0x60
[ 1648.091276] ---[ end trace c0bb2248162783d9 ]---
[ 3856.835188] ------------[ cut here ]------------

-- 
Regards
dave
