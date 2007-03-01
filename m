Return-Path: <linux-kernel-owner+w=401wt.eu-S965488AbXCASeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965488AbXCASeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:34:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965485AbXCASeh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:34:37 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:19512 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965488AbXCASeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:34:37 -0500
X-IronPort-AV: i="4.14,237,1170651600"; 
   d="scan'208"; a="29534745:sNHT25470361"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH -mm 3/5] Blackfin: on-chip ethernet MAC controller driver
Date: Thu, 1 Mar 2007 13:35:26 -0500
User-Agent: KMail/1.9.5
Cc: bryan.wu@analog.com, "Andrew Morton" <akpm@linux-foundation.org>,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <1172722514.5264.77.camel@roc-desktop> <45E6F6D6.5000804@linux-foundation.org>
In-Reply-To: <45E6F6D6.5000804@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703011335.26560.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 01 Mar 2007 18:34:34.0707 (UTC) FILETIME=[427DBA30:01C75C30]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 1 Mar 2007 10:52, Stephen Hemminger pondered:
> Wu, Bryan wrote:
> > Hi folks,
> >
> > Here is the blackfin on-chip ethernet MAC controller driver for Linux.
> >
> > Index: linux-2.6/drivers/net/Kconfig
> > ===================================================================
> > --- linux-2.6.orig/drivers/net/Kconfig	2007-03-01 11:39:14.000000000
> > +0800 +++ linux-2.6/drivers/net/Kconfig	2007-03-01 11:39:19.000000000
> > +0800 @@ -836,6 +836,50 @@
> >  	  module, say M here and read <file:Documentation/modules.txt> as well
> >  	  as <file:Documentation/networking/net-modules.txt>.
> >
> > +config BFIN_MAC
> > +	tristate "Blackfin 536/537 on-chip mac support"
> > +	depends on NET_ETHERNET && (BF537 || BF536) && (!BF537_PORT_H)
> > +	select CRC32
> > +	select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
> > +	help
> > +	  This is the driver for blackfin on-chip mac device. Say Y if you want
> > it +	  compiled into the kernel. This driver is also available as a
> > module +	  ( = code which can be inserted in and removed from the running
> > kernel +	  whenever you want). The module will be called bfin_mac.
> > +
> > +config BFIN_MAC_USE_L1
> > +	bool "Use L1 memory for rx/tx packets"
> > +	depends on BFIN_MAC && BF537
> > +	default y
> > +	help
> > +	  To get maximum network performace, you should use L1 memory as rx/tx
> > buffers. +	  Say N here if you want to reserve L1 memory for other uses.
> > +
> > +config BFIN_TX_DESC_NUM
> > +	int "Number of transmit buffer packets"
> > +	depends on BFIN_MAC
> > +	range 6 10 if BFIN_MAC_USE_L1
> > +	range 10 100
> > +	default "10"
> > +	help
> > +	  Set the number of buffer packets used in driver.
> > +
> > +config BFIN_RX_DESC_NUM
> > +	int "Number of receive buffer packets"
> > +	depends on BFIN_MAC
> > +	range 20 100 if BFIN_MAC_USE_L1
> > +	range 20 800
> > +	default "20"
> > +	help
> > +	  Set the number of buffer packets used in driver
>
> The regular practice is to put these in a device include file, and not
> make them kernel configurable.
> Why would you want to make it tuneable at compile time?

It is to attempt to make it easier for our end users to configure&use.

Most people who use it, want to make some tweaks to the configuration based on 
their embedded platform. Rather than forcing everyone to make changes to a .c 
or .h file, we let them manage it in the .config (which is platforms specific 
anyway).

-Robin
