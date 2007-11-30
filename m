Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbXK3VUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbXK3VUN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 16:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752405AbXK3VTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 16:19:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51319 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752338AbXK3VTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 16:19:54 -0500
Date: Fri, 30 Nov 2007 16:19:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng and kobject_init_and_add
 functions
In-Reply-To: <20071130210420.GA6097@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0711301616300.2941-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Greg KH wrote:

> > My suggestion: Have kobject_init_ng() accept a ktype pointer but not a 
> > parent or name.  Instead, make kobject_add_ng() take the parent and 
> > name (possibly a kset also).  Then when kobject_init_and_add() 
> > encounters an error, it shouldn't do a _put() -- the caller can either 
> > do the _put() or just do a kfree().
> 
> Why not the parent for init()?  Isn't it always known at that time?
> I'll dig to be sure.

Specifying the parent during _add() is more logical, because a kobject
doesn't actually _do_ anything to the parent until it is registered in
the parent's directory.  Or to put it another way, an unregistered
kobject can't have a parent in any meaningful sense so there's no point
specifying the parent in the _init() call.

It's really just a matter of taste.

Alan Stern

