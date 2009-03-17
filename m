Return-Path: <linux-kernel-owner+w=401wt.eu-S1758646AbZCQBSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646AbZCQBSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 21:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZCQBSq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 21:18:46 -0400
Received: from fwtops.0.225.230.202.in-addr.arpa ([202.230.225.126]:39510 "EHLO
	topsms.toshiba-tops.co.jp" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751082AbZCQBSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 21:18:45 -0400
Date: Tue, 17 Mar 2009 10:18:38 +0900 (JST)
Message-Id: <20090317.101838.104710820.nemoto@toshiba-tops.co.jp>
To: broonie@opensource.wolfsonmicro.com
Cc: tiwai@suse.de, mano@roarinelk.homelinux.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Only deregister AC97 dev if it's name was not
 "AC97"
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <20090316160137.GA24994@rakim.wolfsonmicro.main>
References: <20090316.232620.95066093.anemo@mba.ocn.ne.jp>
	<s5hbps1r10t.wl%tiwai@suse.de>
	<20090316160137.GA24994@rakim.wolfsonmicro.main>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 6.1 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 16:01:37 +0000, Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> > Hm, codec->ac97->dev.bus should be NULL unless it's registered,
> > so calling soc_ac97_dev_unregister() should be harmless...
> 
> Atsushi, are you using ac97.c as your codec driver?  Could you please
> post the actual backtrace you're seeing?

Yes.  I'm using ac97.c and here is the backtrace.  The first argument
of sysfs_get_dirent (dir_sd) was NULL.  The bottom
platform_device_unregister call is for "soc-audio" device.

[<801fac24>] sysfs_get_dirent+0x24/0xd0
[<801fcb60>] sysfs_remove_group+0x34/0x144
[<802cd3b0>] device_del+0x48/0x178
[<802cd4f4>] device_unregister+0x14/0x28
[<c01afa88>] snd_ac97_dev_disconnect+0x24/0x34 [snd_ac97_codec]
[<c00d1b4c>] snd_device_disconnect+0x48/0x9c [snd]
[<c00d1be0>] snd_device_disconnect_all+0x40/0x80 [snd]
[<c00ccc30>] snd_card_disconnect+0x25c/0x2e0 [snd]
[<c00ccce4>] snd_card_free+0x30/0xf0 [snd]
[<c014c68c>] snd_soc_free_pcms+0xcc/0x110 [snd_soc_core]
[<c01ce0ec>] ac97_soc_remove+0x2c/0x60 [snd_soc_ac97]
[<c014b8b8>] soc_remove+0x64/0x128 [snd_soc_core]
[<802cfad8>] __device_release_driver+0x80/0xb8
[<802cfc40>] device_release_driver+0x28/0x40
[<802cef34>] bus_remove_device+0xc0/0x100
[<802cd490>] device_del+0x128/0x178
[<802d13d4>] platform_device_del+0x2c/0x9c
[<802d1944>] platform_device_unregister+0x14/0x28

---
Atsushi Nemoto
