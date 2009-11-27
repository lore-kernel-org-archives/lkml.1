Return-Path: <linux-kernel-owner+w=401wt.eu-S1751007AbZK0RGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751007AbZK0RGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 12:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750883AbZK0RGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 12:06:39 -0500
Received: from soto.provo.novell.com ([137.65.250.214]:44032 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZK0RGj convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-pmullaney@novell.com;5:1>);
	Fri, 27 Nov 2009 12:06:39 -0500
Message-Id: <4B0FA4AD020000C70007B9AE@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 27 Nov 2009 10:06:37 -0700
From: "Patrick Mullaney" <pmullaney@novell.com>
To: <arnd@arndb.de>
Cc: <bridge@lists.linux-foundation.org>,
       <alacrityvm-devel@lists.sourceforge.net>, <kaber@trash.net>,
       <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] netdevice: provide common routine for macvlan
	 and vlan operstate management
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks. I'll post an updated patch.

On Fri, 2009-11-27 at 14:09 +0100, Arnd Bergmann wrote:
> On Friday 13 November 2009, Patrick Mullaney wrote:
> > @@ -551,7 +532,7 @@ static int macvlan_newlink(struct net_device *dev,
> >                 return err;
> >  
> >         list_add_tail(&vlan->list, &port->vlans);
> > -       macvlan_transfer_operstate(dev);
> > +       netif_stacked_transfer_operstate(dev, lowerdev);
> >         return 0;
> >  }
> >  
> > @@ -591,7 +572,8 @@ static int macvlan_device_event(struct notifier_block *unused,
> >         switch (event) {
> >         case NETDEV_CHANGE:
> >                 list_for_each_entry(vlan, &port->vlans, list)
> > -                       macvlan_transfer_operstate(vlan->dev);
> > +                       netif_stacked_transfer_operstate(vlan->dev,
> > +                                                        vlan->lowerdev);
> >                 break;
> >         case NETDEV_FEAT_CHANGE:
> >                 list_for_each_entry(vlan, &port->vlans, list) {
> 
> These have the arguments reversed, lowerdev should come first.
> 
> 	Arnd <><

