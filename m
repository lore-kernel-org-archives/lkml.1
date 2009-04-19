Return-Path: <linux-kernel-owner+w=401wt.eu-S1757421AbZDSESj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421AbZDSESj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 00:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbZDSES3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 00:18:29 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750777AbZDSES2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 00:18:28 -0400
Date: Sat, 18 Apr 2009 21:18:20 -0700 (PDT)
Message-Id: <20090418.211820.197285479.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: khc@pm.waw.pl, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] 2.6.30-rc broke ixp4xx_eth, firmware breakage?
From: David Miller <davem@davemloft.net>
In-Reply-To: <200904182153.n3ILrP6j027453@pilspetsen.it.uu.se>
References: <200904182153.n3ILrP6j027453@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Sat, 18 Apr 2009 23:53:25 +0200 (MEST)

> The ixp4xx_eth driver for my IXP420 XScale box (Synology DS101)
> worked fine in kernel 2.6.29. Now trying to boot 2.6.30-rc2 I'm
> greeted with the following failure during init:
> 
> Bringing up interface eth0:  RTNETLINK answers: No such file or directory
> Failed to bring up eth0.
> [FAILED]
> 
> There's a fairly long (at least 10 seconds) delay between the 'Bringing up'
> message and the RTNETLINK error.
> 
> A diff between the 2.6.29 and 2.6.30-rc2 boot logs indicates that
> the firmware doesn't get loaded:

Please make sure CONFIG_FIRMWARE_IN_KERNEL is set in your
configuration if this driver is being built statically
into your kernel.

Otherwise, if modular, make sure the firmware files get installed into
the correct location and are available in the filesystem when the
driver loads.
