Return-Path: <linux-kernel-owner+w=401wt.eu-S934037AbXK2WLv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934037AbXK2WLv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:11:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762088AbXK2WLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:11:38 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35949 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760151AbXK2WLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:11:37 -0500
Date: Thu, 29 Nov 2007 17:11:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
In-Reply-To: <20071129203900.GA27877@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711291708080.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Greg KH wrote:

> > > > kobject_put(foo) is needed since it gets you through kobject_cleanup()
> > > > where the name can be freed.
> > > 
> > > No, kobject_register() should have handled that for us, right?
> > 
> > kobject_register() doesn't do a kobject_put() if kobject_add() failed.
> 
> Crap.  If I can't get this code right in an example, the API is messed
> up.  Time to take Kay seriously and start to revamp the basic kobject
> api :)

The rule is simple enough.  After calling kobject_register() you should 
always use kobject_put() -- even if kobject_register() failed.

In fact, after calling kobject_init() you should use kobject_put().  
The first rule follows from this one, since kobject_register() calls 
kobject_init() internally.

Alan Stern


