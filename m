Return-Path: <linux-kernel-owner+w=401wt.eu-S932442AbYD1Jay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbYD1Jay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 05:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760882AbYD1Jap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 05:30:45 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:52362 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYD1Jao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 05:30:44 -0400
Date: Mon, 28 Apr 2008 12:30:13 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Subject: Re: Build failure (with insane config)
Message-ID: <20080428093012.GE16379@cs181133002.pp.htv.fi>
References: <adahcdm3b63.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adahcdm3b63.fsf@cisco.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 08:34:12PM -0700, Roland Dreier wrote:
> For x86-64, arch/x86/lib/Makefile has:
> 
>         lib-y += csum-partial_64.o csum-copy_64.o csum-wrappers_64.o
> 
> so in particular ip_compute_csum() (from csum-partial_64.c) gets put in
> libs, so even though it is exported, it gets thrown away at link time if
> there are no non-modular users.
> 
> However, if someone has an insane config with CONFIG_NET=n and
> CONFIG_VIDEO_BT848=m, then ip_compute_csum() gets discarded but the
> modular code in drivers/media/video/bt8xx/bttv-cards.c calls it and...
> 
>         ERROR: "ip_compute_csum" [drivers/media/video/bt8xx/bttv.ko] undefined!
> 
> I guess one fix is just to put at least csum-partial_64.c in obj-y
> instead; it does seem broken to have files with EXPORT_SYMBOL() be
> lib-y, since it is really an invitation for this problem.  Other ideas
> would be for bttv to depend on or select CONFIG_NET.
>...

This isn't the first time csum-partial_64.c is involved in such a kind 
of breakage (and we constantly have this kind of bugs with various 
exports from lib-y), and EXPORT_SYMBOL's in lib-y are simply wrong and 
always bugs waiting to happen.

Axing lib-y is somewhere low priority on my TODO list.

>  - R.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

