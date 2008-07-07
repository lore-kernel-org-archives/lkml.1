Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYGGVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYGGVxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 17:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbYGGVxB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 17:53:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53554
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755855AbYGGVxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 17:53:00 -0400
Date: Mon, 07 Jul 2008 14:52:59 -0700 (PDT)
Message-Id: <20080707.145259.103902820.davem@davemloft.net>
To: notting@redhat.com
Cc: kaber@trash.net, bridge@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] Allow full bridge configuration via sysfs
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080707213420.GA20089@nostromo.devel.redhat.com>
References: <20080707205342.GA19710@nostromo.devel.redhat.com>
	<4872838B.1060603@trash.net>
	<20080707213420.GA20089@nostromo.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bill Nottingham <notting@redhat.com>
Date: Mon, 7 Jul 2008 17:34:20 -0400

> I could look at wireless network configuration, but I doubt that's going to
> help your argument.

Just like any system with age, we have a lot of legacy to
convert over.  But it will happen.

> That being said, how is moving from adding a bonding slave from:
>   echo "+eth0" >  /sys/class/net/bond0/bonding/slaves to:
> to:
>   http://www.linuxfoundation.org/en/Net:Generic_Netlink_HOWTO
> 
> a worthwhile improvement for the admin? Let's see, a kernel-userspace
> protocol with magic message formats. Hey, we reinvented ioctl!
> 
> Why, if netlink is the standard (and it's been around for a long
> damn time), was sysfs configuration for bonding added in 2005? Why
> was bridge configuration added in 2005, and *extended* in 2006 and
> 2007? Why were the user-space tools such as brctl ported from ioctl
> to sysfs?

Because often a lot of shit slips in when someone who understands
the ramifications is too busy or on vacation.

We do want everything to be netlink based.

Why?

Because it means that you can run one monitoring tool to listen
for netlink events and report them to the user for diagnosis.

It means that network configuration events can be sent over
the wire and used remotely at some point.

The latter can never happen as long as we keep adding ad-hoc
config stuff.

