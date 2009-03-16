Return-Path: <linux-kernel-owner+w=401wt.eu-S1755273AbZCPQBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbZCPQBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 12:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784AbZCPQBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 12:01:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54973 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752267AbZCPQBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 12:01:40 -0400
Date: Mon, 16 Mar 2009 16:01:37 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Only deregister AC97 dev if it's name was not
	"AC97"
Message-ID: <20090316160137.GA24994@rakim.wolfsonmicro.main>
References: <20090316.232620.95066093.anemo@mba.ocn.ne.jp> <s5hbps1r10t.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hbps1r10t.wl%tiwai@suse.de>
X-Cookie: Prices higher in Alaska and Hawaii.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 16, 2009 at 03:32:50PM +0100, Takashi Iwai wrote:

> Hm, codec->ac97->dev.bus should be NULL unless it's registered,
> so calling soc_ac97_dev_unregister() should be harmless...

Atsushi, are you using ac97.c as your codec driver?  Could you please
post the actual backtrace you're seeing?

> Maybe I miss something?

There's some fun and games here due to ac97.c which provides the ability
to use the standard ALSA AC97 functionality as a codec driver (that's
why there's the check on init) - I suspect there may be a double free.
