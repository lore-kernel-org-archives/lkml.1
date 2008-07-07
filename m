Return-Path: <linux-kernel-owner+w=401wt.eu-S1759960AbYGGWFa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759960AbYGGWFa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:05:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758928AbYGGWFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:05:01 -0400
Received: from mail.vyatta.com ([216.93.170.194]:49585 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759361AbYGGWFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:05:00 -0400
X-Spam-Flag: NO
X-Spam-Score: -2.142
Date: Mon, 7 Jul 2008 15:04:54 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: notting@redhat.com, netdev@vger.kernel.org,
       bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [Bridge] [RFC PATCH 0/2] Allow full bridge configuration via
 sysfs
Message-ID: <20080707150454.2a02a217@extreme>
In-Reply-To: <20080707.145259.103902820.davem@davemloft.net>
References: <20080707205342.GA19710@nostromo.devel.redhat.com>
	<4872838B.1060603@trash.net>
	<20080707213420.GA20089@nostromo.devel.redhat.com>
	<20080707.145259.103902820.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Jul 2008 14:52:59 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: Bill Nottingham <notting@redhat.com>
> Date: Mon, 7 Jul 2008 17:34:20 -0400
> 
> > I could look at wireless network configuration, but I doubt that's going to
> > help your argument.
> 
> Just like any system with age, we have a lot of legacy to
> convert over.  But it will happen.
> 
> > That being said, how is moving from adding a bonding slave from:
> >   echo "+eth0" >  /sys/class/net/bond0/bonding/slaves to:
> > to:
> >   http://www.linuxfoundation.org/en/Net:Generic_Netlink_HOWTO
> > 
> > a worthwhile improvement for the admin? Let's see, a kernel-userspace
> > protocol with magic message formats. Hey, we reinvented ioctl!
> > 
> > Why, if netlink is the standard (and it's been around for a long
> > damn time), was sysfs configuration for bonding added in 2005? Why
> > was bridge configuration added in 2005, and *extended* in 2006 and
> > 2007? Why were the user-space tools such as brctl ported from ioctl
> > to sysfs?
> 
> Because often a lot of shit slips in when someone who understands
> the ramifications is too busy or on vacation.
> 
> We do want everything to be netlink based.
> 
> Why?
> 
> Because it means that you can run one monitoring tool to listen
> for netlink events and report them to the user for diagnosis.
> 
> It means that network configuration events can be sent over
> the wire and used remotely at some point.
> 
> The latter can never happen as long as we keep adding ad-hoc
> config stuff.

There are always historical reasons. In this case it was because I knew
more about sysfs than netlink, and there was no netlink interface for managing
interfaces back in 2005.  Sysfs is okay for simple stuff (set forward-delay to 10seconds),
but it falls down when anything interesting and transactional happens. Think of
sysfs as more an extension of per-device sysctl's or module parameters, rather
than a good configuration interface.
