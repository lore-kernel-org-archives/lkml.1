Return-Path: <linux-kernel-owner+w=401wt.eu-S965482AbXCASV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965482AbXCASV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:21:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965484AbXCASV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:21:29 -0500
Received: from an-out-0708.google.com ([209.85.132.246]:17402 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965481AbXCASV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:21:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gripfsplLFk4jaxqJQsHmvWQL5mzegnUsG+/coon8MlEZeVwAXd1g2zhRERJE5JGyQMziKpe5FM+vXQPfIYcg4Svn7XYPxge1PjSZte7nIkeyummgkLZCndtMSYeTmUsVtvqOhBRnX+gBLrD5mIB4otiJi8CYn2E37Ui7eXJ9c8=
Message-ID: <8bd0f97a0703011021s3d74b129yaa59ce65142115e0@mail.gmail.com>
Date: Thu, 1 Mar 2007 13:21:27 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH -mm 3/5] Blackfin: on-chip ethernet MAC controller driver
Cc: bryan.wu@analog.com, "Andrew Morton" <akpm@linux-foundation.org>,
       jgarzik@pobox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <45E6F6D6.5000804@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1172722514.5264.77.camel@roc-desktop>
	 <45E6F6D6.5000804@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/1/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> Wu, Bryan wrote:
> > +config BFIN_MAC
> > +     tristate "Blackfin 536/537 on-chip mac support"
> > +     depends on NET_ETHERNET && (BF537 || BF536) && (!BF537_PORT_H)
> > +     select CRC32
> > +     select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
> > +     help
> > +       This is the driver for blackfin on-chip mac device. Say Y if you want it
> > +       compiled into the kernel. This driver is also available as a module
> > +       ( = code which can be inserted in and removed from the running kernel
> > +       whenever you want). The module will be called bfin_mac.
> > +
> > +config BFIN_MAC_USE_L1
> > +     bool "Use L1 memory for rx/tx packets"
> > +     depends on BFIN_MAC && BF537
> > +     default y
> > +     help
> > +       To get maximum network performace, you should use L1 memory as rx/tx buffers.
> > +       Say N here if you want to reserve L1 memory for other uses.
> > +
> > +config BFIN_TX_DESC_NUM
> > +     int "Number of transmit buffer packets"
> > +     depends on BFIN_MAC
> > +     range 6 10 if BFIN_MAC_USE_L1
> > +     range 10 100
> > +     default "10"
> > +     help
> > +       Set the number of buffer packets used in driver.
> > +
> > +config BFIN_RX_DESC_NUM
> > +     int "Number of receive buffer packets"
> > +     depends on BFIN_MAC
> > +     range 20 100 if BFIN_MAC_USE_L1
> > +     range 20 800
> > +     default "20"
> > +     help
> > +       Set the number of buffer packets used in driver
> >
> The regular practice is to put these in a device include file, and not
> make them kernel configurable.

we're working on moving some of this stuff into the board files rather
than Kconfig

> Why would you want to make it tuneable at compile time?

because it was easier to implement and deploy the first time around ;)
-mike
