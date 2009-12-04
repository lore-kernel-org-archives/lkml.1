Return-Path: <linux-kernel-owner+w=401wt.eu-S932594AbZLDXue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932594AbZLDXue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:50:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbZLDXu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:50:29 -0500
Received: from netrider.rowland.org ([192.131.102.5]:59703 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932472AbZLDXu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:50:29 -0500
Date: Fri, 4 Dec 2009 18:50:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, Greg KH <gregkh@suse.de>,
       <stable@kernel.org>, Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
In-Reply-To: <200912041423.10632.dmitry.torokhov@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0912041844450.5593-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Dmitry Torokhov wrote:

> > Maybe reference counting is inelegant; it depends on your point of
> > view.  Can you think of a more elegant way to make sure that a pointer
> > isn't stale?
> 
> Yes, just say "no" to device_create() and friends.

device_create() wasn't used in the case Oliver is discussing.

>  Embed device structure in
> yours,

You can't do that when the device structure wasn't created by your 
driver.

>  be mindful of lifetime rules and only use "your" device (i.e device
> bound to your driver).

What do you mean by "use"?  In Oliver's case he wasn't using the
device, he was using the device structure.  (Maybe that's what you
meant.)  And he wanted to use it at a time when it wasn't bound to his
driver, because userspace still had an open file reference to it.  
There isn't really any way around this.

> This way, as long as your refcount your instance you
> can rest assured the device structure is there as well.

I rather think that a simple device_get() and device_put() is easier 
than trying to follow a bunch of rules, especially in cases where they 
don't apply!  :-)

Alan Stern

