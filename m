Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbYGUQPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbYGUQPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 12:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYGUQO7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 12:14:59 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:54652 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917AbYGUQO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:14:58 -0400
Date: Mon, 21 Jul 2008 11:13:07 -0500
From: Scott Wood <scottwood@freescale.com>
To: Dave Jones <davej@redhat.com>, Kumar Gala <galak@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/ep8248e: Fix compile problem if !CONFIG_FS_ENET
Message-ID: <20080721161307.GC13185@loki.buserror.net>
References: <Pine.LNX.4.64.0807160838520.14127@blarg.am.freescale.net> <20080716214722.GA6251@ld0162-tx32.am.freescale.net> <20080716215745.GA17093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080716215745.GA17093@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 05:57:45PM -0400, Dave Jones wrote:
> On Wed, Jul 16, 2008 at 04:47:23PM -0500, Scott Wood wrote:
>  > On Wed, Jul 16, 2008 at 08:39:12AM -0500, Kumar Gala wrote:
>  > > If we don't enable FS_ENET we get build issues:
>  > > 
>  > > arch/powerpc/platforms/built-in.o: In function `ep8248e_mdio_probe':
>  > > arch/powerpc/platforms/82xx/ep8248e.c:129: undefined reference to `alloc_mdio_bitbang'
>  > > arch/powerpc/platforms/82xx/ep8248e.c:143: undefined reference to `mdiobus_register'
>  > 
>  > How is this possible?  CONFIG_EP8248E selects CONFIG_MDIO_BITBANG.
> 
> If CONFIG_PHYLIB=m however, that doesn't make any difference, because
> vmlinuz is trying to use a symbol which now lives in a module.

Yuck.  If FOO selects BAR, and FOO is 'y', then BAR should be 'y', not 'm'.
If BAR depends on other symbols that are 'm', they should be changed to 'y'.

-Scott
