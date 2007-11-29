Return-Path: <linux-kernel-owner+w=401wt.eu-S932953AbXK2Tw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbXK2Tw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932214AbXK2TwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:52:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.177]:63358 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852AbXK2TwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:52:00 -0500
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before
	kobject_init
From: Kay Sievers <kay.sievers@vrfy.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
In-Reply-To: <Pine.LNX.4.44L0.0711291358200.4712-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0711291358200.4712-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Thu, 29 Nov 2007 20:51:23 +0100
Message-Id: <1196365883.7903.11.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/VIsnDTF0rnTLj4RPCXHOK86XeGhHopwfmP4y
 eHgJP2CdWP9+xjoGefGNhtd+nTzCRRETHUHbZcIv3dWjgCbExN
 uwUoS5W4XlEauB/XMqbFnXuNNheOm+S
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-11-29 at 14:05 -0500, Alan Stern wrote:
> On Thu, 29 Nov 2007, Kay Sievers wrote:
> 
> > Your error scenario confirmed my initial concern about suggesting
> > kobject_put() to clean up an initialized kobject.
> > 
> > We should probably make kobject_cleanup() free only the resources taken
> > by kobject_init(), and use kobject_cleanup() instead of kobject_put()?
> 
> My conclusion is different.  We should make kobject_init() not consume
> any resources at all; just initialize various fields.  That way it
> would be okay to call either kfree() or kobject_put() on an initialized
> kobject.  And then when something like device_register() fails, the
> caller would know the proper thing to do would be to call the put()  
> routine, always.
> 
> Of course, once the name has been assigned, only kobject_put() should
> be used.

Now we just move the exactly the same problem from _init() to
_set_name(). To free the name of an unregistered we would need to call
_put() which free()'s the whole object again. :) 

> There's another good reason for not assigning the name in
> kobject_init(): Code that uses kobjects (like the driver core) doesn't
> set the name until later.

That can be done at any stage, I guess. We will rip out the name in the
struct device anyway.

Kay

