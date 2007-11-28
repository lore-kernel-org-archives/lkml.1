Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbXK1Dun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbXK1Dun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 22:50:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753883AbXK1DuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 22:50:21 -0500
Received: from vena.lwn.net ([206.168.112.25]:45931 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467AbXK1DuP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 22:50:15 -0500
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Stern <stern@rowland.harvard.edu>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Tue, 27 Nov 2007 15:02:52 PST."
             <20071127230252.GB10038@kroah.com> 
Date: Tue, 27 Nov 2007 20:50:14 -0700
Message-ID: <2532.1196221814@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> wrote:

> Jonathan, I used your old lwn.net article about kobjects as the basis
> for this document, I hope you don't mind

Certainly I have no objections, I'm glad it was useful.

A few little things...

> It is rare (even unknown) for kernel code to create a standalone kobject;
> with one major exception explained below.

You don't keep this promise - bet you thought we wouldn't notice...
Actually I guess you do, in the "creating simple kobjects" section.
When you get to that point, you should mention that this is a situation
where standalone kobjects make sense.

Given that there are quite a few standalone kobjects created by this
patch set (kernel_kobj, security_kobj, s390_kobj, etc.), the "(even
unknown)" should probably come out.

> So, for example, UIO code has a structure that defines the memory region
> associated with a uio device:

*The* UIO code, presumably.

> the given type. So, for example, a pointer to a struct kobject embedded
> within a struct cdev called "kp" could be converted to a pointer to the
> containing structure with:

That should be "struct uio_mem", I think.

> one.  Calling kobject_init() is not sufficient, however. Kobject users
> must, at a minimum, set the name of the kobject; this is the name that will
> be used in sysfs entries.

Is setting the name mandatory now, or are there still places where
kobjects (which do not appear in sysfs) do have - and do not need - a
name?

> Because kobjects are dynamic, they must not be declared statically or on
> the stack, but instead, always from the heap.  Future versions of the

"always be allocated from the heap"?

> "empty" release function, you will be mocked merciously by the kobject
> maintainer if you attempt this.

So just how should severely should we mock kobject maintainers who can't
spell "mercilessly"?  :)

>  - A kset can provide a set of default attributes that all kobjects that
>    belong to it automatically inherit and have created whenever a kobject
>    is registered belonging to the kset.

Can we try that one again?

 - A kset can provide a set of default attributes for all kobjects which
   belong to it.

> There is currently
> no other way to add a kobject to a kset without directly messing with the
> list pointers.

Presumably the latter way is not recommended; I would either say so or
not mention this possibility at all.

jon
