Return-Path: <linux-kernel-owner+w=401wt.eu-S1751314AbXLXPbQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbXLXPbQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 10:31:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXLXPa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 10:30:58 -0500
Received: from mgw1.diku.dk ([130.225.96.91]:39607 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752605AbXLXPa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 10:30:56 -0500
Date: Mon, 24 Dec 2007 16:30:51 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?= 
	<yoshfuji@linux-ipv6.org>
Cc: rolandd@cisco.com, mshefty@ichips.intel.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 15/38] drivers/infiniband: Use time_before, time_before_eq,
 etc.
In-Reply-To: <20071225.002900.00703855.yoshfuji@linux-ipv6.org>
Message-ID: <Pine.LNX.4.64.0712241630030.23999@ask.diku.dk>
References: <Pine.LNX.4.64.0712241528140.23999@ask.diku.dk>
 <20071225.002900.00703855.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-812127195-1198510251=:23999"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-812127195-1198510251=:23999
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 25 Dec 2007, YOSHIFUJI Hideaki / µÈÆ£±ÑÌÀ wrote:

> In article <Pine.LNX.4.64.0712241528140.23999@ask.diku.dk> (at Mon, 24 Dec 2007 15:28:42 +0100 (CET)), Julia Lawall <julia@diku.dk> says:
> 
> > diff -r -u -p a/drivers/infiniband/hw/ipath/ipath_mad.c b/drivers/infiniband/hw/ipath/ipath_mad.c
> > --- a/drivers/infiniband/hw/ipath/ipath_mad.c	2007-10-22 11:25:09.000000000 +0200
> > +++ b/drivers/infiniband/hw/ipath/ipath_mad.c	2007-12-23 20:35:37.000000000 +0100
> > @@ -1334,7 +1334,8 @@ static int process_subn(struct ib_device
> >  	}
> >  
> >  	/* Is the mkey in the process of expiring? */
> > -	if (dev->mkey_lease_timeout && jiffies >= dev->mkey_lease_timeout) {
> > +	if (dev->mkey_lease_timeout &&
> > +	    time_before_eq(jiffies, dev->mkey_lease_timeout)) {
> >  		/* Clear timeout and mkey protection field. */
> >  		dev->mkey_lease_timeout = 0;
> >  		dev->mkeyprot = 0;
> 
> time_after_eq()

I see that there are quite a lot of problems like this.  I will have to 
start over...

julia

---511516320-812127195-1198510251=:23999--
