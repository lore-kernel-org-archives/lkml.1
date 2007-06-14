Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbXFNIQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbXFNIQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 04:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXFNIPw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 04:15:52 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:39478 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbXFNIPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 04:15:51 -0400
Subject: Re: [RFC/PATCH] Documentation of kernel messages
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Greg KH <gregkh@suse.de>
Cc: holzheu <holzheu@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com, akpm@osdl.org, mtk-manpages@gmx.net,
       heiko.carstens@de.ibm.com
In-Reply-To: <20070613183200.GA16588@suse.de>
References: <1181747217.29512.9.camel@localhost.localdomain>
	 <20070613175147.GB14355@suse.de>
	 <1181758680.26375.25.camel@localhost.localdomain>
	 <20070613183200.GA16588@suse.de>
Content-Type: text/plain
Organization: IBM Corporation
Date: Thu, 14 Jun 2007 10:17:03 +0200
Message-Id: <1181809023.5446.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-13 at 11:32 -0700, Greg KH wrote:
> > > So, why not use what we already have and work off of it?
> > 
> > dev_printk() and friends are great, since they already define
> something
> > like KMSG_COMPONENT: The driver name.
> 
> They provide way more than that, they also provide the explicit device
> that is being discussed, as well as other things depending on the
> device.

dev_printk() and friends provide additional information for a printk
that is related to a device. Not every printk is about a device, so I
think Michaels proposal is orthorgonal to dev_printk. We definitly
should have a dev_printk variant that uses the kmsg documentation tag
AND we should have a normal printk variant as well that uses the kmsg
tagging.

> So if you are going to do this, please use the already-in-place macros
> to hook into, don't try to get the driver authors to pick up something
> new and different, as it's going to be _very_ difficult, trust me...

There is no doubt that it will be difficult to get a larger part of the
developers use the kmsg scheme (e.g. see the reaction of Dave M.). We do
not have the illusion that we can replace every single message in the
kernel, nor do we think that it would make sense to do so. What we would
do for s390 is to check each message in drivers/s390 and think hard if
the message should be 1) removed, 2) replaced with a {dev_}printk_kmsg
or 3) left as it is. Fortunatly for us there are not too many drivers
for s390 ..

-- 
blue skies,
  Martin.

"Reality continues to ruin my life." - Calvin.


