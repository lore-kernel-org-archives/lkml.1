Return-Path: <linux-kernel-owner+w=401wt.eu-S1758205AbYEOIB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205AbYEOIB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 04:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754944AbYEOIBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 04:01:45 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49674
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753184AbYEOIBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 04:01:44 -0400
Date: Thu, 15 May 2008 01:01:39 -0700 (PDT)
Message-Id: <20080515.010139.219194657.davem@davemloft.net>
To: cornelia.huck@de.ibm.com
Cc: shemminger@vyatta.com, greg@kroah.com, fubar@us.ibm.com,
       netdev@vger.kernel.org, bonding-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] sysfs: remove error messages for -EEXIST case
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080515095246.3b6a0d1d@gondolin.boeblingen.de.ibm.com>
References: <20080514181257.74fbb5aa@extreme>
	<20080514181603.411e834f@extreme>
	<20080515095246.3b6a0d1d@gondolin.boeblingen.de.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cornelia Huck <cornelia.huck@de.ibm.com>
Date: Thu, 15 May 2008 09:52:46 +0200

> >  int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
> >  {
> > -	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name)) {
> > -		printk(KERN_WARNING "sysfs: duplicate filename '%s' "
> > -		       "can not be created\n", sd->s_name);
> > -		WARN_ON(1);
> > +	if (sysfs_find_dirent(acxt->parent_sd, sd->s_name))
> >  		return -EEXIST;
> > -	}
> > 
> >  	sd->s_parent = sysfs_get(acxt->parent_sd);
> 
> ...but this will cause many useful warnings to disappear.
> 
> What to do here?

Make a __sysfs_add_one() that doesn't warn.   Make
sysfs_add_one() be a wrapper around __sysfs_add_one()
that warns.

Change networking to call __sysfs_add_one().

Repeat and rinse up the call chain, as needed.

