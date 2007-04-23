Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXDWHNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXDWHNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 03:13:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXDWHNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 03:13:18 -0400
Received: from cdma-61-61.msk.skylink.ru ([83.217.61.61]:59572 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753624AbXDWHMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 03:12:54 -0400
X-Greylist: delayed 3431 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2007 03:12:52 EDT
Date: Mon, 23 Apr 2007 10:14:27 +0400
From: Vitaly Bordug <vitb@kernel.crashing.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linuxppc-dev@ozlabs.org, linux-pcmcia@lists.infradead.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] PCMCIA support for 8xx using platform devices
Message-ID: <20070423101427.3a1d4983@localhost.localdomain>
In-Reply-To: <200704222349.42368.arnd@arndb.de>
References: <20070422232658.5f427fd3@localhost.localdomain>
	<200704222349.42368.arnd@arndb.de>
X-Mailer: Claws Mail 2.8.1cvs91 (GTK+ 2.10.9; i686-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007 23:49:41 +0200
Arnd Bergmann wrote:

> On Sunday 22 April 2007, Vitaly Bordug wrote:
> > This utilizes PCMCIA on mpc885ads and mpc866ads from arch/powerpc.
> > In the new approach, direct IMMR accesses from within drivers/ were
> > totally eliminated, that requires hardware_enable,
> > hardware_disable, voltage_set board-specific functions to be moved
> > over to BSP code section (arch/powerpc/platforms/8xx in 885 case).
> > There is just no way to have both arch/ppc and arch/powerpc
> > approaches to work simultaneously because of that.  
> 
> Maybe I'm missing a key issue here, but what's the point of adding
> more platform_devices for stuff that is already in the device tree?
> Shouldn't this be made an of_platform_driver instead so you can
> use the existing of_device directly?
> 
Was thinking of it but platform_device is better for migration purposes. Hence,
assuming somebody would want to have pcmcia working not bothering to add whole arch/powerpc support,
it can be accomplished quickly. OTOH, further change from pd to of_device is not hard as well. So far, most ppc stuff (if not all) still existing both in ppc/ and powerpc/ paths, and to keep consistency platform_devices are used here and there. So, with pd approach arch/ppc/ boards are encouraged to get source device/driver bus ready, hereby simplifying transition to of_device later.

With current bootwrapper activities it may happen sooner, but there are many places in kernel nobody want to move for almost zero value..



-- 
Sincerely, Vitaly

