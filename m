Return-Path: <linux-kernel-owner+w=401wt.eu-S1764294AbXLTWHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764294AbXLTWHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbXLTWHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:07:38 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:49109 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754766AbXLTWHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:07:37 -0500
Date: Thu, 20 Dec 2007 14:06:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>
Subject: Re: [RFC] kobject/kset/ktype documentation and example code updated
Message-Id: <20071220140659.71f6cce6.randy.dunlap@oracle.com>
In-Reply-To: <20071220212700.GB5808@kroah.com>
References: <20071220003031.GA15129@kroah.com>
	<20071219223206.ada18362.randy.dunlap@oracle.com>
	<20071220212700.GB5808@kroah.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Dec 2007 13:27:00 -0800 Greg KH wrote:

> On Wed, Dec 19, 2007 at 10:32:06PM -0800, Randy Dunlap wrote:
> > On Wed, 19 Dec 2007 16:30:31 -0800 Greg KH wrote:
> > 
> > ...
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

OK.

> > > Embedding kobjects
> > > 
> > > So, for example, the UIO code has a structure that defines the memory
> > > region associated with a uio device:
> > > 
> > > struct uio_mem {
> > > 	struct kobject kobj;
> > > 	unsigned long addr;
> > > 	unsigned long size;
> > > 	int memtype;
> > > 	void __iomem *internal_addr;
> > > };
> > > 
> > > If you have a struct uio_mem structure, finding its embedded kobject is
> > > just a matter of using the kobj structure.  Code that works with kobjects
> > > will often have the opposite problem, however: given a struct kobject
> > > pointer, what is the pointer to the containing structure?  You must avoid
> > > tricks (such as assuming that the kobject is at the beginning of the
> > > structure) and, instead, use the container_of() macro, found in
> > > <linux/kernel.h>:
> > > 
> > > 	container_of(pointer, type, member)
> > > 
> > > where pointer is the pointer to the embedded kobject, type is the type of
> > > the containing structure, and member is the name of the structure field to
> > > which pointer points.  The return value from container_of() is a pointer to
> > > the given type. So, for example, a pointer to a struct kobject embedded
> > 
> > This is (still) confusing to me.  Is it:
> >                                    a pointer "kp" to a ...
> > or is struct uio_mem the "kp"?
> 
> How about:
> 	 So, for example, a pointer "kp" to a struct kobject
> 	 embedded within a struct uio_mem could be converted to a
> 	 pointer to the containing uio_mem structure with:

ack.

> > >     int kobject_uevent(struct kobject *kobj, enum kobject_action action);
> > > 
> > > Use the KOBJ_ADD action for when the kobject is first added to the kernel.
> > > This should be done only after any attributes or children of the kobject
> > > have been initialized properly, as userspace will instantly start to look
> > 
> > 		s/will/may/
> 
> No, it's usually a "will", as udev is damm fast these days :)

But that's the point.  It assumes that udev is being used.  :(


> > > Both types of attributes used here, with a kobject that has been created
> > > with the kobject_create_and_add() can be of type kobj_attribute, no special
> > > custom attribute is needed to be created.
> > 
> > ^ multi-run-on sentences....
> 
> Is this better:
> 	Both types of attributes used here, with a kobject that has been
> 	created with the kobject_create_and_add(), can be of type
> 	kobj_attribute, so no special custom attribute is needed to be
> 	created.
> 
> If not, any suggestions?

I'm lost in the twisty maze.  I suppose that will do until someone
can make it better.  ;)


Who is your spell checker?

---
~Randy
