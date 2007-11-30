Return-Path: <linux-kernel-owner+w=401wt.eu-S1763135AbXK3Jb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763135AbXK3Jb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbXK3Jbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:31:47 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62566 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbXK3Jbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:31:45 -0500
Date: Fri, 30 Nov 2007 10:31:43 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: kobject_init rewrite
Message-ID: <20071130103143.52d2bd2b@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071129215455.GB5043@kroah.com>
References: <Pine.LNX.4.44L0.0711291047300.4516-100000@iolanthe.rowland.org>
	<1196352280.3118.11.camel@lov.site>
	<20071129172134.74849579@gondolin.boeblingen.de.ibm.com>
	<20071129215304.GA5043@kroah.com>
	<20071129215455.GB5043@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 13:54:55 -0800,
Greg KH <greg@kroah.com> wrote:

> One minor documentation update:
> 
> > /**
> >  * kobject_init - initialize a kobject structure
> >  * @kobj: pointer to the kobject to initialize
> >  * @ktype: pointer to the ktype for this kobject.
> >  * @fmt: the name of the kobject
> >  *
> >  * This function will properly initialize a kobject such that it can then
> >  * be passed to the kobject_add() call.
> >  *
> >  * If the function returns an error, the memory allocated by the kobject
> >  * can be safely freed, no other functions need to be called.
> 
> If the function does not return an error, the only way the kobject's
> memory can be properly freed is with a call to kobject_put().  kfree()
> should never be called on a kobject after this function has been called,
> execept from the ktype's release function.
> 
> >  */
> > int kobject_init(struct kobject *kobj, struct kobj_type *ktype, const char *fmt, ...)
> > {
> > 	va_list args;
> > 	int retval;
> > 
> > 	if (!kobj)
> > 		return -EINVAL;
> > 
> > 	if (!ktype)
> > 		return -EINVAL;
> > 
> > 	WARN_ON(atomic_read(&kobj->kref.refcount));
> > 	kref_init(&kobj->kref);
> > 	INIT_LIST_HEAD(&kobj->entry);
> > 	kobj->ktype = ktype;
> > 
> > 	va_start(args, fmt);
> > 	retval = kobject_set_name_vargs(kobj, fmt, args);
> > 	va_end(args);
> > 
> > 	return retval;
> > }
> > 

Yes, this looks fine.
