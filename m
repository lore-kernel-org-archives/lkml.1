Return-Path: <linux-kernel-owner+w=401wt.eu-S1756500AbYAYRwl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbYAYRwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 12:52:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYAYRwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 12:52:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:58921 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYAYRwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 12:52:34 -0500
Date: Fri, 25 Jan 2008 09:51:06 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 044/196] kset: add kset_create_and_add function
Message-ID: <20080125175106.GC4242@suse.de>
References: <20080125071127.GA4860@kroah.com> <1201245134-4876-44-git-send-email-gregkh@suse.de> <a8e1da0801250109u69e75a5p9cd5815451a8a196@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0801250109u69e75a5p9cd5815451a8a196@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2008 at 05:09:41PM +0800, Dave Young wrote:
> On Jan 25, 2008 3:09 PM, Greg Kroah-Hartman <gregkh@suse.de> wrote:
> > +/**
> > + * kset_create_and_add - create a struct kset dynamically and add it to sysfs
> > + *
> > + * @name: the name for the kset
> > + * @uevent_ops: a struct kset_uevent_ops for the kset
> > + * @parent_kobj: the parent kobject of this kset, if any.
> > + *
> > + * This function creates a kset structure dynamically and registers it
> > + * with sysfs.  When you are finished with this structure, call
> > + * kset_unregister() and the structure will be dynamically freed when it
> > + * is no longer being used.
> > + *
> > + * If the kset was not able to be created, NULL will be returned.
> > + */
> > +struct kset *kset_create_and_add(const char *name,
> > +                                struct kset_uevent_ops *uevent_ops,
> > +                                struct kobject *parent_kobj)
> > +{
> > +       struct kset *kset;
> > +       int error;
> > +
> > +       kset = kset_create(name, uevent_ops, parent_kobj);
> > +       if (!kset)
> > +               return NULL;
> > +       error = kset_register(kset);
> > +       if (error) {
> > +               kfree(kset);
> 
> How about : kobject_put(&kset->kobj);

At this point in the object's lifetime, it is the same exact thing.

So both are correct :)

thanks,

greg k-h
