Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZEOUjm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZEOUjm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 16:39:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZEOUj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 16:39:28 -0400
Received: from vena.lwn.net ([206.168.112.25]:47079 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbZEOUj1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 16:39:27 -0400
Date: Fri, 15 May 2009 14:39:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Subject: Re: [PATCH v2 4/7] [PATCH 4/8] can: Driver for the SJA1000 CAN
 controller
Message-ID: <20090515143927.7ba06f10@bike.lwn.net>
In-Reply-To: <4A0BDE79.4060606@grandegger.com>
References: <20090512092757.048938233@denx.de>
	<20090512092757.756749047@denx.de>
	<20090513155205.4bf06c25@bike.lwn.net>
	<4A0BDE79.4060606@grandegger.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 11:03:53 +0200
Wolfgang Grandegger <wg@grandegger.com> wrote:

> > So you're still using the "put the higher-level structure at the top so we
> > can treat it like either kind of pointer" trick.  I'd still recommend
> > against that.  Far better to do something like:
> > 
> > 	struct can_priv *canpriv = netdev_priv(dev);
> > 	struct sja_1000_priv *priv = container_of(canpriv, struct sja_1000_priv, can);
> > 
> > Of course, you can put that dance into a helper function.  
> 
> There is no way to initialize the value returned by netdev_priv() as it
> does not point to a member of struct net_device. I already commented here:
> 
>   http://marc.info/?l=linux-netdev&m=124120212106891&w=2
> 
> Have I missed something?

I'm confused.  It points to the struct can_priv that you registered at
the beginning.  Since that structure is contained within struct
sja1000_priv, you can use container_of(), as described above, to get
it.

I would probably just write something like:

static inline struct sja1000_priv *to_sja1000_priv(struct net_device *dev)
{
	return container_of(netdev_priv(dev), struct sja1000_priv, can);
}

So have *I* missed something?

jon
