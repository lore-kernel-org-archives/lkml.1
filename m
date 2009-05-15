Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbZEOVYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbZEOVYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 17:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754277AbZEOVYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 17:24:22 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:60331 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbZEOVYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 17:24:20 -0400
X-Auth-Info: Z/y0KunqwQmv3/4oLYOgDMoP0fB3s+CEnsf3BuA37pc=
Message-ID: <4A0DDD81.4040406@grandegger.com>
Date: Fri, 15 May 2009 23:24:17 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jonathan Corbet <corbet@lwn.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Subject: Re: [PATCH v2 4/7] [PATCH 4/8] can: Driver for the SJA1000 CAN controller
References: <20090512092757.048938233@denx.de>	<20090512092757.756749047@denx.de>	<20090513155205.4bf06c25@bike.lwn.net>	<4A0BDE79.4060606@grandegger.com> <20090515143927.7ba06f10@bike.lwn.net>
In-Reply-To: <20090515143927.7ba06f10@bike.lwn.net>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jonathan Corbet wrote:
> On Thu, 14 May 2009 11:03:53 +0200
> Wolfgang Grandegger <wg@grandegger.com> wrote:
> 
>>> So you're still using the "put the higher-level structure at the top so we
>>> can treat it like either kind of pointer" trick.  I'd still recommend
>>> against that.  Far better to do something like:
>>>
>>> 	struct can_priv *canpriv = netdev_priv(dev);
>>> 	struct sja_1000_priv *priv = container_of(canpriv, struct sja_1000_priv, can);
>>>
>>> Of course, you can put that dance into a helper function.  
>> There is no way to initialize the value returned by netdev_priv() as it
>> does not point to a member of struct net_device. I already commented here:
>>
>>   http://marc.info/?l=linux-netdev&m=124120212106891&w=2
>>
>> Have I missed something?
> 
> I'm confused.  It points to the struct can_priv that you registered at
> the beginning.  Since that structure is contained within struct
> sja1000_priv, you can use container_of(), as described above, to get
> it.
> 
> I would probably just write something like:
> 
> static inline struct sja1000_priv *to_sja1000_priv(struct net_device *dev)
> {
> 	return container_of(netdev_priv(dev), struct sja1000_priv, can);
> }
> 
> So have *I* missed something?

Furthermore, the higher layer needs to known the location of the member
"struct sja1000_priv can", e.g. by defining:

  dev->priv = &dev_specific_priv->can;

But "struct net_device" does not have a "priv" member. netdev_priv(dev)
always points to the beginning of the private data area. See:

   http://lxr.linux.no/linux+v2.6.29/include/linux/netdevice.h#L953

Wolfgang.



