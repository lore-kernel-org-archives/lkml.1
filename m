Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbXK2Jj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbXK2Jj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 04:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754955AbXK2JjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 04:39:17 -0500
Received: from mtagate1.de.ibm.com ([195.212.29.150]:64514 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXK2JjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 04:39:16 -0500
Date: Thu, 29 Nov 2007 10:39:07 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
Message-ID: <20071129103907.0b404071@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20071129061139.GI26327@kroah.com>
References: <20071127230252.GB10038@kroah.com>
	<20071127230406.GD10038@kroah.com>
	<20071128173532.00bc72af@gondolin.boeblingen.de.ibm.com>
	<20071129061139.GI26327@kroah.com>
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

On Wed, 28 Nov 2007 22:11:39 -0800,
Greg KH <greg@kroah.com> wrote:

> > > 	foo->kobj.kset = example_kset;
> > > 	foo->kobj.ktype = &foo_ktype;
> > > 
> > > 	/*
> > > 	 * Register the kobject with the kernel, all the default files will
> > > 	 * be created here and the uevent will be sent out.  If we were to
> > > 	 * call kobject_init() and then kobject_add() we would be
> > > 	 * responsible for sending out the initial KOBJ_ADD uevent.
> > > 	 */
> > > 	retval = kobject_register(&foo->kobj);
> > > 	if (retval) {
> > > 		kfree(foo);
> > 
> > kobject_put(foo) is needed since it gets you through kobject_cleanup()
> > where the name can be freed.
> 
> No, kobject_register() should have handled that for us, right?

kobject_register() doesn't do a kobject_put() if kobject_add() failed.
