Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbXLDP2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbXLDP2g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:28:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbXLDP21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:28:27 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:46162 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753206AbXLDP2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:28:25 -0500
Date: Tue, 4 Dec 2007 10:28:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Cornelia Huck <cornelia.huck@de.ibm.com>
cc: Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng, kobject_add_ng, and
 kobject_init_and_add functions
In-Reply-To: <20071204110112.14488ece@gondolin.boeblingen.de.ibm.com>
Message-ID: <Pine.LNX.4.44L0.0712041023400.4321-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007, Cornelia Huck wrote:

> > > > > + * If the function is successful, the only way to properly clean up the
> > > > > + * memory is with a call to kobject_del().
> > > > 
> > > > In which case kobject_put() isn't needed?
> > > 
> > > kobject_del() should only undo what kobject_add() did. So kobject_put()
> > > will still be needed to clean up the memory. Perhaps the wording should
> > > be:
> > > 
> > > If the function is successful, the only way to properly clean up the
> > > kobject is to call kobject_del() for removing the kobject from the
> > > hierarchy and to subsequently call kobject_put() to clean up the memory.
> > 
> > But that's not what the code does today in the kobject_del() function.
> 
> Hm, if I'm not completely confused, kobject_del() just gives up the
> extra reference obtained by kobject_add(). That leaves the initial
> reference we got via kobject_init(_ng)(). If we want to clean up the
> memory, we need to give up that reference as well.

That's right.  Furthermore there are other parts of the kernel that 
expect to do the kobject_del() and the final kobject_put() separately.  
For example, the driver core does kobject_del() as part of device_del() 
and then it does the final kobject_put() as part of put_device().

Alan Stern

