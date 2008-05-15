Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbYEOKBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbYEOKBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 06:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEOKBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 06:01:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52889
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752318AbYEOKA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 06:00:59 -0400
Date: Thu, 15 May 2008 03:00:54 -0700 (PDT)
Message-Id: <20080515.030054.247673168.davem@davemloft.net>
To: cornelia.huck@de.ibm.com
Cc: shemminger@vyatta.com, greg@kroah.com, fubar@us.ibm.com,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: remove error messages for -EEXIST case
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080515113131.2cea2bce@gondolin.boeblingen.de.ibm.com>
References: <20080515095246.3b6a0d1d@gondolin.boeblingen.de.ibm.com>
	<20080515.010139.219194657.davem@davemloft.net>
	<20080515113131.2cea2bce@gondolin.boeblingen.de.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Thu, 15 May 2008 11:31:31 +0200

> On Thu, 15 May 2008 01:01:39 -0700 (PDT),
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Cornelia Huck <cornelia.huck@de.ibm.com>
> > Date: Thu, 15 May 2008 09:52:46 +0200
> > 
> > > >  int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> > > >  {
> > > > -	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
> > > > -		printk(KERN_WARNING "sysfs: duplicate filename '%s' "
> > > > -		       "can not be created\n", sd->s_name);
> > > > -		WARN_ON(1);
> > > > +	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
> > > >  		return -EEXIST;
> > > > -	}
> > > > 
> > > >  	sd->s_parent = sysfs_get(acxt->parent_sd);
> > > 
> > > ...but this will cause many useful warnings to disappear.
> > > 
> > > What to do here?
> > 
> > Make a __sysfs_add_one() that doesn't warn.   Make
> > sysfs_add_one() be a wrapper around __sysfs_add_one()
> > that warns.
> > 
> > Change networking to call __sysfs_add_one().
> 
> Like this (not even compile tested)?

No, the idea is that the __sysfs_add_one() wouldn't need a parameter
at all.  sysfs_add_one() just needs to check for -EEXIST from
__sysfs_add_one() to decide whether to warn or not.

