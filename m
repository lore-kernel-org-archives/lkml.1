Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0BAO0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 09:26:13 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:47312 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697Ab0BAO0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 09:26:12 -0500
Date: Mon, 1 Feb 2010 23:26:05 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux@arm.linux.org.uk,
       eric.y.miao@gmail.com, tony@atomide.com, linux-kernel@vger.kernel.org,
       khilman@deeprootsystems.com, ben-linux@fluff.org,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/06] ARM: SuperH Mobile ARM, sh7367 and G3EVM support
Message-ID: <20100201142605.GB13428@linux-sh.org>
References: <20100128124028.8982.16123.sendpatchset@rxone.opensource.se> <20100128124038.8982.82995.sendpatchset@rxone.opensource.se> <20100201141057.GB1340@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100201141057.GB1340@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 01, 2010 at 03:10:57PM +0100, Pavel Machek wrote:
> > This patch contains the SuperH Mobile ARM base support together
> > with sh7367 CPU and G3EVM board support. Only timer, serial
> > console and NOR flash are supported at this point. Patches for
> > the interrupt controller, pinmux support, clock framework and
> > runtime pm will be submitted as feature patches on top of this.
> ...
> >  arch/arm/mach-shmobile/Makefile.boot              |    9 
> >  arch/arm/mach-shmobile/board-g3evm.c              |  127 +++++++++++
> 
> I guess I'm confused. I thought superh was architecture, like arm
> is.....?
> 
SH-Mobile (G series, in this case) is a line of SH/ARM multi-cores. They
contain both SH and ARM MPUs and are built up almost entirely on SH IP
blocks. There are some SH-Mobiles that are SH-only, and those are taken
care of in arch/sh/ as normal. Most of the shared code sits in drivers/sh
and so forth, requiring fairly little glue on the ARM architecture side.
As support for these CPUs is extended, we'll likely see more of arch/sh/
being generalized. There's likely not going to be enough that is directly
reusable between the two to warrant a split out architecture directory of
its own, but we'll see how it goes.

It's forseeable that we will also see support for the same CPU in
arch/sh/ aimed at the SH MPU, and that we can have linux running on both
the SH and the ARM at the same time sharing the same peripheral domain.
However, all of these things are out of scope for this patch set, which
is just getting the groundwork established for the ARM MPU.

> I superh actually manufacturer? And can we get shorter name than
> mach-shmobile? mach-shm?

shmobile is what the line is called, and matches the naming scheme we
already have in-tree today. Changing that around would only lead to more
confusion. It's also not really any longer than many of the other mach
types, so I don't really see the point.
