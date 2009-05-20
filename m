Return-Path: <linux-kernel-owner+w=401wt.eu-S1756498AbZETVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498AbZETVcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZETVcC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 17:32:02 -0400
Received: from vena.lwn.net ([206.168.112.25]:47063 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZETVb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 17:31:58 -0400
Date: Wed, 20 May 2009 15:31:58 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Wolfgang Grandegger <wg@grandegger.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Hartkopp <oliver.hartkopp@volkswagen.de>
Subject: Re: [PATCH v2 4/7] [PATCH 4/8] can: Driver for the SJA1000 CAN
 controller
Message-ID: <20090520153158.57785c82@bike.lwn.net>
In-Reply-To: <4A0E63BF.9080503@grandegger.com>
References: <20090512092757.048938233@denx.de>
	<20090512092757.756749047@denx.de>
	<20090513155205.4bf06c25@bike.lwn.net>
	<4A0BDE79.4060606@grandegger.com>
	<20090515143927.7ba06f10@bike.lwn.net>
	<4A0DDD81.4040406@grandegger.com>
	<4A0E63BF.9080503@grandegger.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 May 2009 08:57:03 +0200
Wolfgang Grandegger <wg@grandegger.com> wrote:

> > But "struct net_device" does not have a "priv" member. netdev_priv(dev)
> > always points to the beginning of the private data area. See:
> > 
> >    http://lxr.linux.no/linux+v2.6.29/include/linux/netdevice.h#L953  
> 
> I could use container_of() as you suggested, of course, if the "struct
> can_priv" remains the first member of  "struct sja1000_priv". Would that
> already be an improvement?

Ah, OK, I'm a little slow, sorry.  I do get what the problem is here.

Using container_of() in that situation doesn't help a whole lot.  The
point is to get away from this assumption that struct can_priv is the
first element of the structure.

Perhaps what you have is as good as it gets for now, but please add a
comment to the structure noting that struct can_priv has to come first
and why.

Thanks,

jon
