Return-Path: <linux-kernel-owner+w=401wt.eu-S1753322AbZCQN6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322AbZCQN6x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 09:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCQN6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 09:58:44 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42913 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752119AbZCQN6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 09:58:43 -0400
Date: Tue, 17 Mar 2009 13:58:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Cc: tiwai@suse.de, mano@roarinelk.homelinux.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: Only deregister AC97 dev if it's name was not
	"AC97"
Message-ID: <20090317135840.GA23150@rakim.wolfsonmicro.main>
References: <20090316.232620.95066093.anemo@mba.ocn.ne.jp> <s5hbps1r10t.wl%tiwai@suse.de> <20090316160137.GA24994@rakim.wolfsonmicro.main> <20090317.101838.104710820.nemoto@toshiba-tops.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317.101838.104710820.nemoto@toshiba-tops.co.jp>
X-Cookie: HAIR TONICS, please!!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 10:18:38AM +0900, Atsushi Nemoto wrote:

> Yes.  I'm using ac97.c and here is the backtrace.  The first argument
> of sysfs_get_dirent (dir_sd) was NULL.  The bottom
> platform_device_unregister call is for "soc-audio" device.

OK, I've confirmed the problem and applied your patch - thanks.  The
issue is that the standard AC97 support doesn't play too nicely with
ASoC so we need to jump through a couple of hoops to fit in with what
it's doing.
