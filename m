Return-Path: <linux-kernel-owner+w=401wt.eu-S968472AbXEHWja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968472AbXEHWja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 18:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967171AbXEHWj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 18:39:26 -0400
Received: from 1wt.eu ([62.212.114.60]:2538 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967187AbXEHWjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 18:39:25 -0400
Date: Wed, 9 May 2007 00:39:22 +0200
From: Willy Tarreau <w@1wt.eu>
To: Zbigniew Baniewski <zb@ispid.com.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: "modularized" 2.4.34.4  ->  ide-core "unresolved symbols"
Message-ID: <20070508223922.GB31591@1wt.eu>
References: <20070505194922.GA13176@localhost.localdomain> <20070506043645.GF943@1wt.eu> <20070508202334.GA16185@localhost.localdomain> <20070508211646.GA3129@1wt.eu> <20070508221425.GA18244@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508221425.GA18244@localhost.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2007 at 12:14:25AM +0200, Zbigniew Baniewski wrote:
> On Tue, May 08, 2007 at 11:16:46PM +0200, Willy Tarreau wrote:
> 
> > depmod:         init_cmd640_vlb
> 
> There wasn't such message.

No, because it seems that your debian scripts hide it (or log it somewhere
else). But if you do "make modules_install" from the kernel tree (as I did),
you get it.

> I made another kernel (config below) - unfortunately, this time it gives up
> completely, saying:
> 
> -------------------------------
> ...ordinary boot messages, ending with "hda:... sectors... w/Cache..."
> /dev/ide/host0/bus0/target0/lun0:<1>Unable to handle kernel paging request at virtual address ffffff00
> printing eip:
> 
> ...several verses of sanscrit-like language...

This "sanscrit-like" language is an oops (in fact a kernel panic, but the
dump format is called an oops). It is what developers use to find bugs.

I see that you're using devfs. It is unfortunate for you that you're using
all the parts which are not reputed for their reliability :-/ I'm pretty
sure that initialization order matters here but you cannot interact much
with it, except by forcing some drivers to "=y".

Are you aware of any kernel version on which this config worked ? I'd
like to help you get the minimal working config, ie: the one with the
lower number of hard-linked drivers.

> <0>Kernel panic: Attempted to kill the idle task!
> In idle task - not syncing.
> --------------------------------
> 
> Moved the disk to quite different machine - with the same result. So, I'm
> afraid, it's not hardware-related problem.

Do not worry about the hardware here. The problem lies in the
initialization path of some sensible drivers. Did you enable DEVFS for a
particular reason, or just because you enabled almost everything ? If the
later, then you should retry with it disabled. It's absolutely not certain
that it will work, but it may.

If you're pretty certain that you need DEVFS, then for a test, please
set a max of IDE options to YES instead of MODULE. At least all the ones
you need to boot on this system.

As I said, it's a tricky area, and it's for this reason that distros
enable IDE to YES as well as some other entries I don't have in mind.

Regards,
Willy

