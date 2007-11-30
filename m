Return-Path: <linux-kernel-owner+w=401wt.eu-S934762AbXK3Ovm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934762AbXK3Ovm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 09:51:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXK3Ov3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 09:51:29 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36980 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751325AbXK3Ov2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 09:51:28 -0500
Date: Fri, 30 Nov 2007 09:51:27 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Young <hidave.darkstar@gmail.com>
cc: Greg KH <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
In-Reply-To: <a8e1da0711292107q4e2e0282o2d37798dc529288c@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0711300949070.3833-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Nov 2007, Dave Young wrote:

> > The rule is simple enough.  After calling kobject_register() you should
> > always use kobject_put() -- even if kobject_register() failed.
> >
> > In fact, after calling kobject_init() you should use kobject_put().
> > The first rule follows from this one, since kobject_register() calls
> > kobject_init() internally.
> >
> Hi,
> The behavior is not very clear here, the root problem is that :
> 
> 1. Should we call kobject_put so cleanup work can be done by refcount
> touch zero or call kfree every time after kobject_register failed?

Call kobject_put so that the cleanup work will be done when the 
refcount goes to 0.  Don't call kfree.

> 2. If kobject_put calling is true, should this be done in
> kobject_register error handling codes or by hand after
> kobject_register failed?

It should be done by hand after kobject_register fails.  Otherwise 
kobject_register would end up dropping a reference that it never 
acquired.

Alan Stern

