Return-Path: <linux-kernel-owner+w=401wt.eu-S1759382AbXLTW54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759382AbXLTW54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764569AbXLTW5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:57:45 -0500
Received: from netrider.rowland.org ([192.131.102.5]:4855 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1764537AbXLTW5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:57:44 -0500
Date: Thu, 20 Dec 2007 17:57:42 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
In-Reply-To: <20071220212700.GB5808@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0712201741570.29911-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007, Greg KH wrote:

> > >  - A ktype is the type of object that embeds a kobject. Every structure
> > >    that embeds a kobject needs a corresponding ktype.  The ktype controls
> > >    what happens when a kobject is no longer referenced and the kobject's
> > >    default representation in sysfs.
> > 
> > I can't quite parse the last sentence above.  Is it:
> > 
> > The ktype controls (a) what happens ...
> > and (b) the kobject's default representation in sysfs.
> > 
> > ?
> 
> How about:
> 	- A ktype is the type of object that embeds a kobject.  Every
> 	  structure that embeds a kobject needs a corresponding ktype.
> 	  The ktype controls what happens to the kobject when it is
> 	  created and destroyed.

I still don't like it.  How about being a little more explicit:

	A ktype controls certain operations for structures with 
	embedded kobjects.  For example, if struct foo contains an 
	embedded kobject member then there should be a foo_ktype object 
	with pointers to the methods for struct foo's.  These methods
	control what happens when the kobject embedded in a struct foo
	is added or destroyed.  Every time a new struct foo is created, 
	&foo_ktype would be passed as the ktype argument in the 
	kobject_init() call for the structure's embedded kobject.  
	Each type of structure (not just foo!) with an embedded kobject 
	needs to have its own corresponding ktype object.

Alan Stern

