Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbXK2FxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbXK2FxJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 00:53:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbXK2Fwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 00:52:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34113 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbXK2Fwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 00:52:54 -0500
Date: Wed, 28 Nov 2007 21:46:56 -0800
From: Greg KH <greg@kroah.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071129054656.GA26327@kroah.com>
References: <20071127230252.GB10038@kroah.com> <2532.1196221814@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2532.1196221814@lwn.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 08:50:14PM -0700, Jonathan Corbet wrote:
> Greg KH <greg@kroah.com> wrote:
> 
> > Jonathan, I used your old lwn.net article about kobjects as the basis
> > for this document, I hope you don't mind
> 
> Certainly I have no objections, I'm glad it was useful.

Thanks, it was a great framework to work with.

> > It is rare (even unknown) for kernel code to create a standalone kobject;
> > with one major exception explained below.
> 
> You don't keep this promise - bet you thought we wouldn't notice...
> Actually I guess you do, in the "creating simple kobjects" section.
> When you get to that point, you should mention that this is a situation
> where standalone kobjects make sense.

Sorry, yes, that is where I tried to explain it.  I'll flush it out some
more.

> Given that there are quite a few standalone kobjects created by this
> patch set (kernel_kobj, security_kobj, s390_kobj, etc.), the "(even
> unknown)" should probably come out.

Ok.

> > So, for example, UIO code has a structure that defines the memory region
> > associated with a uio device:
> 
> *The* UIO code, presumably.

fixed.

> > the given type. So, for example, a pointer to a struct kobject embedded
> > within a struct cdev called "kp" could be converted to a pointer to the
> > containing structure with:
> 
> That should be "struct uio_mem", I think.

fixed.

> > one.  Calling kobject_init() is not sufficient, however. Kobject users
> > must, at a minimum, set the name of the kobject; this is the name that will
> > be used in sysfs entries.
> 
> Is setting the name mandatory now, or are there still places where
> kobjects (which do not appear in sysfs) do have - and do not need - a
> name?

Any kobject that is registered needs to have a name.  If someone tries
to call kobject_register() or kobject_add() without a name set they will
find out that it is not allowed :)

And yes, there are a few places in the kernel with kobjects that are
never registered.  I'm working on trying to get rid of them...

> > Because kobjects are dynamic, they must not be declared statically or on
> > the stack, but instead, always from the heap.  Future versions of the
> 
> "always be allocated from the heap"?

thanks.

> > "empty" release function, you will be mocked merciously by the kobject
> > maintainer if you attempt this.
> 
> So just how should severely should we mock kobject maintainers who can't
> spell "mercilessly"?  :)

Heh, turns out that a lot of people sent me this privately :)

> >  - A kset can provide a set of default attributes that all kobjects that
> >    belong to it automatically inherit and have created whenever a kobject
> >    is registered belonging to the kset.
> 
> Can we try that one again?
> 
>  - A kset can provide a set of default attributes for all kobjects which
>    belong to it.

No, it's the ktype that does this, I'll go fix that up...

> > There is currently
> > no other way to add a kobject to a kset without directly messing with the
> > list pointers.
> 
> Presumably the latter way is not recommended; I would either say so or
> not mention this possibility at all.

Ah, yes, now removed.

Thanks for the review, I really appreciate it.

greg k-h
