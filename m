Return-Path: <linux-kernel-owner+w=401wt.eu-S1763671AbXK2RRr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763671AbXK2RRr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:17:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932070AbXK2RRg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:17:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:62532 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763522AbXK2RRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:17:35 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291202570.4712-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711291202570.4712-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 18:17:47 +0100
Message-Id: <1196356667.3118.16.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18cRGxN3HUgloJ72lWeF6HIjoKXfpyTwu6+B6l
 IBbllwWJuWFgqI5wIGUsI9wKw0xW2djCGndG2hmwWR7lBQv5WA
 AFHefB+A4Bn95ZugjW0PXMerT1nMYsM
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 12:06 -0500, Alan Stern wrote:
> On Thu, 29 Nov 2007, Kay Sievers wrote:
> 
> > > In fact, if we were designing the kobject API from scratch, I'd suggest 
> > > making the ktype value an argument to kobject_init() so that it 
> > > _couldn't_ be omitted.
> > 
> > Sounds fine, maybe we should also pass the name along, so it will be
> > obvious what happens here:
> >   int kobject_init(struct kobject *kobj, struct kobj_type *type, const char *fmt, ...)
> 
> I don't know...  Normally *_init() routines can't fail, but this could.  
> Then things like device_register() would run into trouble: The caller 
> wouldn't know whether a failure occurred before or after the 
> kobject_init() call, so it wouldn't know what sort of cleanup action 
> was needed: kfree() or device_put().

But wouldn't device_register() do the kobject cleanup for you when it
fails? Why would a caller of device_register() care about the state of
the kobject?

> > Oh, if you want to rewind on error and have an initialized but still
> > unregistered kobject, and just want to free the allocated name by
> > calling kobject_cleanup() or kobject_put() you might not expect, that
> > your whole object that embeds the kobject will be gone. Just something
> > we need to document ...
> 
> When that sort of thing happens, the unwinding should be done by the   
> code responsible for whole object.  For example, if device_add() fails
> then the caller should go on to call device_put() rather than
> kfree(dev).
> 
> That's how you would expect things to work in most cases.  There aren't
> many bare kobjects in the kernel.
> 
> I agree that documenting this behavior would be good.

Ok, fine. Hope we will collect all that information in the end. :)

Kay

