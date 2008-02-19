Return-Path: <linux-kernel-owner+w=401wt.eu-S1762870AbYBSXK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762870AbYBSXK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 18:10:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbYBSXKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 18:10:16 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:56445 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721AbYBSXKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 18:10:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=omz+rmGFoOKPS/lCRDgYSuHPiykwYIEEoB/DM13af2hsqFRvdQf4tGPkKzxoktlKDNy0fugphiizVEXb1bk0XaBxPdhjVoAJkZpvK4Celpd/6b/olDSOwW5bK5uQ4k49bCdXXWxXNDDAqDWxdoBh7x+UKXhXArs+A8tlgWLmV88=
Message-ID: <86802c440802191510m7afc200eg979ebd4a1cf4a41f@mail.gmail.com>
Date: Tue, 19 Feb 2008 15:10:12 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 6/8] net: use numa_node in net_devcice->dev instead of parent
Cc: mingo@elte.hu, greg@kroah.com, akpm@linux-foundation.org, jeff@garzik.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080219.145512.142721224.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080219112146.GC7204@elte.hu>
	 <20080219.034110.191579889.davem@davemloft.net>
	 <200802191142.48891.yinghai.lu@sun.com>
	 <20080219.145512.142721224.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 19, 2008 2:55 PM, David Miller <davem@davemloft.net> wrote:
> From: Yinghai Lu <Yinghai.Lu@Sun.COM>
> Date: Tue, 19 Feb 2008 11:42:48 -0800
>
> > On Tuesday 19 February 2008 03:41:10 am David Miller wrote:
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Date: Tue, 19 Feb 2008 12:21:46 +0100
> > >
> > > >
> > > > * Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> > > >
> > > > >  struct sk_buff *__netdev_alloc_skb(struct net_device *dev,
> > > > >                 unsigned int length, gfp_t gfp_mask)
> > > > >  {
> > > > > -       int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
> > > > > +       int node = dev_to_node(&dev->dev);
> > > >
> > > > i think this is a fix for the networking folks. (Dave Cc:-ed)
> > >
> > > It keeps getting NAK's because it's wrong.
> > >
> > > The author of the patch hasn't convinced folks why this is really
> > > necessary, and using the net_device embedded device struct is
> > > definitely wrong here.  It doesn't contain the NUMA node information,
> > > the physical device does, and that is what the parent it.
> >
> > can you check the 5/8?
> > that will make sure every struct device get numa_node get assigned.
>
> Why do we need to bother with that if the parent will have the
> necessary information for us here?

less code?

or some kind of usb or other bus interface. may have several level...

YH
