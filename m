Return-Path: <linux-kernel-owner+w=401wt.eu-S1759084AbZCPPAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759084AbZCPPAf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 11:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755395AbZCPPA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 11:00:26 -0400
Received: from mba.ocn.ne.jp ([122.1.235.107]:59850 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbZCPPAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:00:25 -0400
Date: Tue, 17 Mar 2009 00:00:23 +0900 (JST)
Message-Id: <20090317.000023.07457265.anemo@mba.ocn.ne.jp>
To: tiwai@suse.de
Cc: broonie@opensource.wolfsonmicro.com, mano@roarinelk.homelinux.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Only deregister AC97 dev if it's name was not
 "AC97"
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
In-Reply-To: <s5hbps1r10t.wl%tiwai@suse.de>
References: <20090316.232620.95066093.anemo@mba.ocn.ne.jp>
	<s5hbps1r10t.wl%tiwai@suse.de>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Mar 2009 15:32:50 +0100, Takashi Iwai <tiwai@suse.de> wrote:
> > The commit 14fa43f53ff3a9c3d8b9662574b7369812a31a97 ("ASoC: Only
> > register AC97 bus if it's not done already") added a condition for
> > calling of soc_ac97_dev_register() but not added for calling of
> > soc_ac97_dev_unregister().  This patch adds same condition for
> > soc_ac97_dev_unregister().  Without this fix, kernel crashes when
> > unloading an asoc driver.
> 
> Hm, codec->ac97->dev.bus should be NULL unless it's registered,
> so calling soc_ac97_dev_unregister() should be harmless...
> 
> Maybe I miss something?

Well, ac97_codec.c:snd_ac97_dev_register() was called on loading my
asoc driver.  I thought it was called from somewhere during
ac97_soc_probe(), but not sure...

The crash happened in sysfs_remove_group() and
snd_ac97_dev_disconnect() was on callstack.

---
Atsushi Nemoto
