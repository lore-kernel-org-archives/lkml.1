Return-Path: <linux-kernel-owner+w=401wt.eu-S1761721AbXK2GJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761721AbXK2GJ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 01:09:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758067AbXK2GJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 01:09:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:59875 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760019AbXK2GJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 01:09:08 -0500
Date: Wed, 28 Nov 2007 22:11:39 -0800
From: Greg KH <greg@kroah.com>
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
Message-ID: <20071129061139.GI26327@kroah.com>
References: <20071127230252.GB10038@kroah.com> <20071127230406.GD10038@kroah.com> <20071128173532.00bc72af@gondolin.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071128173532.00bc72af@gondolin.boeblingen.de.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2007 at 05:35:32PM +0100, Cornelia Huck wrote:
> On Tue, 27 Nov 2007 15:04:06 -0800,
> Greg KH <greg@kroah.com> wrote:
> 
> > static struct foo_obj *create_foo_obj(const char *name)
> > {
> > 	struct foo_obj *foo;
> > 	int retval;
> > 
> > 	/* allocate the memory for the whole object */
> > 	foo = kzalloc(sizeof(*foo), GFP_KERNEL);
> > 	if (!foo)
> > 		return NULL;
> > 
> > 	/* initialize the kobject portion of the object properly */
> > 	kobject_set_name(&foo->kobj, "%s", name);
> 
> Returncode not checked :)

good catch.  Hm, I don't think anyone checks that function :)

> > 	foo->kobj.kset = example_kset;
> > 	foo->kobj.ktype = &foo_ktype;
> > 
> > 	/*
> > 	 * Register the kobject with the kernel, all the default files will
> > 	 * be created here and the uevent will be sent out.  If we were to
> > 	 * call kobject_init() and then kobject_add() we would be
> > 	 * responsible for sending out the initial KOBJ_ADD uevent.
> > 	 */
> > 	retval = kobject_register(&foo->kobj);
> > 	if (retval) {
> > 		kfree(foo);
> 
> kobject_put(foo) is needed since it gets you through kobject_cleanup()
> where the name can be freed.

No, kobject_register() should have handled that for us, right?

thanks,

greg k-h
