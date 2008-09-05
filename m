Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYIEF1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYIEF1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 01:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYIEF1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 01:27:30 -0400
Received: from relais.videotron.ca ([24.201.245.36]:58797 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYIEF13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 01:27:29 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 05 Sep 2008 01:27:23 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dmitry Torokhov <dtor@insightbb.com>, lkml <linux-kernel@vger.kernel.org>,
       akpm <akpm@osdl.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] ucb1400_ts depends SND_AC97_BUS
In-reply-to: <20080904214444.0dccf859.randy.dunlap@oracle.com>
Message-id: <alpine.LFD.1.10.0809050125500.23787@xanadu.home>
References: <20061209003635.e778ff76.randy.dunlap@oracle.com>
 <200612092150.02940.dtor@insightbb.com>
 <20061209185737.1768315d.randy.dunlap@oracle.com>
 <200612092205.19358.dtor@insightbb.com>
 <Pine.LNX.4.64.0612092212410.2630@xanadu.home>
 <20061209210945.5abe2d89.randy.dunlap@oracle.com>
 <Pine.LNX.4.64.0612102244140.2630@xanadu.home>
 <20080904195744.f367cd2d.randy.dunlap@oracle.com>
 <alpine.LFD.1.10.0809050028590.23787@xanadu.home>
 <20080904214444.0dccf859.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008, Randy Dunlap wrote:

> On Fri, 05 Sep 2008 00:37:17 -0400 (EDT) Nicolas Pitre wrote:
> 
> > On Thu, 4 Sep 2008, Randy Dunlap wrote:
> > 
> > > On Sun, 10 Dec 2006 22:55:25 -0500 (EST) Nicolas Pitre wrote:
> > > 
> > > > On Sat, 9 Dec 2006, Randy Dunlap wrote:
> > > > 
> > > > > On Sat, 09 Dec 2006 22:17:55 -0500 (EST) Nicolas Pitre wrote:
> > > > > 
> > > > > > Please consider what SND_CONFIG_AC97_BUS corresponds to.  It is 
> > > > > > sound/pci/ac97/ac97_bus.c and if you look into this file you'll see that 
> > > > > > it is perfectly buildable even if sound is entirely configured out, just 
> > > > > > like some lib code would be.
> > > > > 
> > > > > OK.  Should it (CONFIG_SND_AC97_BUS -> sound/pci/ac97/ac97_bus.c)
> > > > > be buildable when sound is disabled?
> > > > 
> > > > Yes.
> > > > 
> > > > > If so, where should it be moved to (since afaik, make won't even
> > > > > descend into sound/ if SOUND=n; I don't see that changing
> > > > > any time soon).
> > > > 
> > > > What about this patch?
> > > 
> > > Can we get this patch or some patch into the input tree for linux-next?
> > 
> > This patch is commit e1036502e5263851259d147771226161e5ccc85a and 
> > appeared in mainline almost 2 years ago.
> 
> Ack.  Sorry about that.  Wrong ucb thread.
> 
> ucb1400_core still has build errors in linux-next
> since it uses ac97_bus_type even when CONFIG_SOUND=n.

What about this?

diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
index 6e1e8c6..22cf319 100644
--- a/drivers/input/touchscreen/Kconfig
+++ b/drivers/input/touchscreen/Kconfig
@@ -219,7 +219,6 @@ config TOUCHSCREEN_ATMEL_TSADCC
 
 config TOUCHSCREEN_UCB1400
 	tristate "Philips UCB1400 touchscreen"
-	select AC97_BUS
 	depends on UCB1400_CORE
 	help
 	  This enables support for the Philips UCB1400 touchscreen interface.
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 5dba165..70355d3 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -52,6 +52,7 @@ config HTC_PASIC3
 
 config UCB1400_CORE
 	tristate "Philips UCB1400 Core driver"
+	select AC97_BUS
 	help
 	  This enables support for the Philips UCB1400 core functions.
 	  The UCB1400 is an AC97 audio codec.


Nicolas
