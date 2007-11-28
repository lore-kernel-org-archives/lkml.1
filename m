Return-Path: <linux-kernel-owner+w=401wt.eu-S1758487AbXK1Tgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758487AbXK1Tgg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 14:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbXK1Tg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 14:36:28 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37112 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754188AbXK1Tg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 14:36:27 -0500
Date: Wed, 28 Nov 2007 14:36:26 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
In-Reply-To: <1196278120.3242.115.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711281432290.5566-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007, Kay Sievers wrote:

> > Actually the current code doesn't seem to check whether kobj->ktype is
> > NULL or to use the value of kobj->kset->kobj.ktype.  Is this an oversight?
> 
> We just require the ktype.

No -- we should but we don't.  Look at the code for kobject_init() and
kobject_add() in Greg's tree and you'll see.  Neither of them checks
that kobj->ktype is set.

> > If there is no containing kset, the parent remains NULL.  What happens
> > then?  Does the kobject show up in the sysfs top-level directory?
> 
> "If the kobject belonging to a kset has no parent kobject set, it will
> be added to the kset's directory. Not all members of a kset do
> necessarily live in the kset directory. If an explicit parent kobject is
> assigned before the kobject is added, the kobject is registered with the
> kset, but added below the parent kobject."

Yes, but what if neither kobj->parent nor kobj->kset is set?

Alan Stern

