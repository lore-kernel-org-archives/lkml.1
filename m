Return-Path: <linux-kernel-owner+w=401wt.eu-S1763514AbXK2UqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763514AbXK2UqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761354AbXK2UqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:46:13 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36120 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760151AbXK2UqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:46:12 -0500
Date: Thu, 29 Nov 2007 12:39:00 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
Message-ID: <20071129203900.GA27877@kroah.com>
References: <20071127230252.GB10038@kroah.com> <20071127230406.GD10038@kroah.com> <20071128173532.00bc72af@gondolin.boeblingen.de.ibm.com> <20071129061139.GI26327@kroah.com> <20071129103907.0b404071@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129103907.0b404071@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 10:39:07AM +0100, Cornelia Huck wrote:
> On Wed, 28 Nov 2007 22:11:39 -0800,
> Greg KH <greg@kroah.com> wrote:
> 
> > > > 	foo->kobj.kset = example_kset;
> > > > 	foo->kobj.ktype = &foo_ktype;
> > > > 
> > > > 	/*
> > > > 	 * Register the kobject with the kernel, all the default files will
> > > > 	 * be created here and the uevent will be sent out.  If we were to
> > > > 	 * call kobject_init() and then kobject_add() we would be
> > > > 	 * responsible for sending out the initial KOBJ_ADD uevent.
> > > > 	 */
> > > > 	retval = kobject_register(&foo->kobj);
> > > > 	if (retval) {
> > > > 		kfree(foo);
> > > 
> > > kobject_put(foo) is needed since it gets you through kobject_cleanup()
> > > where the name can be freed.
> > 
> > No, kobject_register() should have handled that for us, right?
> 
> kobject_register() doesn't do a kobject_put() if kobject_add() failed.

Crap.  If I can't get this code right in an example, the API is messed
up.  Time to take Kay seriously and start to revamp the basic kobject
api :)

thanks,

greg k-h
