Return-Path: <linux-kernel-owner+w=401wt.eu-S1758608AbXK1Tq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608AbXK1Tq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:46:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755970AbXK1Tqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:46:51 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53431 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbXK1Tqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:46:50 -0500
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0711281432290.5566-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711281432290.5566-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Wed, 28 Nov 2007 20:46:12 +0100
Message-Id: <1196279172.3242.119.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/K4XnuLKUpNANnXyEelTBRQsALMLbRSfSm+DB
 nQWkxnsTNZMZhlvOEYqFdPkZWrXyzW/OVMeBWt7cFxekgdf5Y4
 d+7GD8kCsiDV1rEGyiSJO/aPMh2mG7M
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-11-28 at 14:36 -0500, Alan Stern wrote:
> On Wed, 28 Nov 2007, Kay Sievers wrote:
> 
> > > Actually the current code doesn't seem to check whether kobj->ktype is
> > > NULL or to use the value of kobj->kset->kobj.ktype.  Is this an oversight?
> > 
> > We just require the ktype.
> 
> No -- we should but we don't.  Look at the code for kobject_init() and
> kobject_add() in Greg's tree and you'll see.  Neither of them checks
> that kobj->ktype is set.

Yeah, it was another "magic" that was built into the core, the code even
tried to find sysfs_ops for completely untyped kobjects. That is gone
now, and we should just require a ktype, I think.

> > > If there is no containing kset, the parent remains NULL.  What happens
> > > then?  Does the kobject show up in the sysfs top-level directory?
> > 
> > "If the kobject belonging to a kset has no parent kobject set, it will
> > be added to the kset's directory. Not all members of a kset do
> > necessarily live in the kset directory. If an explicit parent kobject is
> > assigned before the kobject is added, the kobject is registered with the
> > kset, but added below the parent kobject."
> 
> Yes, but what if neither kobj->parent nor kobj->kset is set?

It will show up in the root of sysfs, yes.

Kay

