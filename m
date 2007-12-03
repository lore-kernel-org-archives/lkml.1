Return-Path: <linux-kernel-owner+w=401wt.eu-S1751947AbXLCUzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751947AbXLCUzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 15:55:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbXLCUzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 15:55:05 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48520 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750979AbXLCUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 15:55:04 -0500
Date: Mon, 3 Dec 2007 15:55:01 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng, kobject_add_ng, and
 kobject_init_and_add functions
In-Reply-To: <20071203190523.GA21776@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0712031552030.3115-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007, Greg KH wrote:

> > Did you want to add an extra kobject_put() to the end of kobject_del()?  
> > Or did you want to define a new kobject_destroy() that combines calls 
> > to kobject_del() and kobject_put()?
> 
> No, let's keep what we have there on the cleanup path for now.  I have
> enough work to clean up the initializion part of the api for now :)

> +/**
> + * kobject_add_ng - the main kobject add function
> + * @kobj: the kobject to add
> + * @parent: pointer to the parent of the kobject.
> + * @fmt: format to name the kobject with.
> + *
> + * The kobject name is set and added to the kobject hierarchy in this
> + * function.
> + *
> + * If @parent is set, then the parent of the @kobj will be set to it.
> + * If @parent is NULL, then the parent of the @kobj will be set to the
> + * kobject associted with the kset assigned to this kobject.  If no kset
> + * is assigned to the kobject, then the kobject will be located in the
> + * root of the sysfs tree.
> + *
> + * If this function returns an error, kobject_put() must be called to
> + * properly clean up the memory associated with the object.
> + *
> + * If the function is successful, the only way to properly clean up the
> + * memory is with a call to kobject_del(), in which case, a call to
> + * kobject_put() is not necessary (kobject_del() does the final
> + * kobject_put() to call the release function in the ktype's release
> + * pointer.)

This comment is inconsistent with your decision above not to add an 
extra kobject_put() into kobject_del().  (Unless such a line was added 
while I wasn't looking...)

Alan Stern

