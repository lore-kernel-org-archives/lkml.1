Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbXLDKB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbXLDKB6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 05:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbXLDKBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 05:01:50 -0500
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:34779 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXLDKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 05:01:49 -0500
Date: Tue, 4 Dec 2007 11:01:12 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Kay Sievers <kay.sievers@vrfy.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] kobject: add kobject_init_ng, kobject_add_ng, and
 kobject_init_and_add functions
Message-ID: <20071204110112.14488ece@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071203190626.GB21776@kroah.com>
References: <20071201010123.GC4745@kroah.com>
	<Pine.LNX.4.44L0.0711302211450.4181-100000@netrider.rowland.org>
	<20071203130003.06afbf61@gondolin.boeblingen.de.ibm.com>
	<20071203190626.GB21776@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Dec 2007 11:06:26 -0800,
Greg KH <greg@kroah.com> wrote:

> On Mon, Dec 03, 2007 at 01:00:03PM +0100, Cornelia Huck wrote:
> > On Fri, 30 Nov 2007 22:29:39 -0500 (EST),
> > Alan Stern <stern@rowland.harvard.edu> wrote:
> > 
> > > On Fri, 30 Nov 2007, Greg KH wrote:
> > > 
> > > > +/**
> > > > + * kobject_add_ng - the main kobject add function
> > > > + * @kobj: the kobject to add
> > > > + * @parent: pointer to the parent of the kobject.
> > > > + *
> > > > + * The kobject name is set and added to the kobject hierarchy in this
> > > > + * function.
> > > > + *
> > > > + * If @parent is set, then the parent of the @kobj will be set to it.
> > > > + * If @parent is NULL, then the parent of the @kobj will be set to the
> > > > + * kobject associted with the kset assigned to this kobject.  If no kset
> > > > + * is assigned to the kobject, then the kobject will be located in the
> > > > + * root of the sysfs tree.
> > > > + *
> > > > + * If this function returns an error, kobject_put() must be called to
> > > > + * properly clean up the memory associated with the object.
> > > > + *
> > > > + * If the function is successful, the only way to properly clean up the
> > > > + * memory is with a call to kobject_del().
> > > 
> > > In which case kobject_put() isn't needed?
> > 
> > kobject_del() should only undo what kobject_add() did. So kobject_put()
> > will still be needed to clean up the memory. Perhaps the wording should
> > be:
> > 
> > If the function is successful, the only way to properly clean up the
> > kobject is to call kobject_del() for removing the kobject from the
> > hierarchy and to subsequently call kobject_put() to clean up the memory.
> 
> But that's not what the code does today in the kobject_del() function.

Hm, if I'm not completely confused, kobject_del() just gives up the
extra reference obtained by kobject_add(). That leaves the initial
reference we got via kobject_init(_ng)(). If we want to clean up the
memory, we need to give up that reference as well.
