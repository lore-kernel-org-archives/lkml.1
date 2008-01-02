Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbYABA6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYABA6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbYABA6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:58:12 -0500
Received: from hs-out-0708.google.com ([64.233.178.240]:64727 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756184AbYABA6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:58:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZMJhrbDiXerXgf0bMBj3PMbAb+fr1UnxGmV37An8QpwumsIv8kSzMrRa5flOdicr3Bqkqp2BbPS77U42nmg9aVC4nRZJ1LhWsetPkkF2qBQRbxjRxWU1K3qKwplyovJW/WAcGYrjsyU2jhm6RoT6xq6HYgSK0/Aqd+PD7AsbMQY=
Message-ID: <a8e1da0801011658u24d7d399kb187c23300353682@mail.gmail.com>
Date: Wed, 2 Jan 2008 08:58:10 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Alan Stern" <stern@rowland.harvard.edu>
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Cc: "Greg KH" <gregkh@suse.de>, "Peter Zijlstra" <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0712291652540.26261-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0712282307p3723857ex534d787f128db112@mail.gmail.com>
	 <Pine.LNX.4.44L0.0712291652540.26261-100000@netrider.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 30, 2007 6:01 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>
> On Sat, 29 Dec 2007, Dave Young wrote:
>
> > On Dec 29, 2007 1:06 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> > >
> > > On Dec 29, 2007 12:42 PM, Greg KH <gregkh@suse.de> wrote:
> > > > On Sat, Dec 29, 2007 at 10:36:49AM +0800, Dave Young wrote:
> > > > > >
> > > > > The full boot dmesg with lockdep output is out, there's one warnings in it :
> > > >
> > > > Please fix that warning before the next repost of these patches (along
> > > > with fixing the problem of them not being able to be applied and
> > > > successfully built at every point in the series...)
> > > >
> > >
> > > Ok, thanks, I will fix them and repost.
> > >
> >
> > Hi,
> > After digging the code, I feel hard to fix the lockdep warning due to
> > some misterious relationship with usb.
> >
> > Could someone help on this? thanks.
> > Add usb-devel list as cc
>
> The problem isn't specific to USB.  And you will not be able to fix it
> unless you make drastic changes to the lockdep checker.
>
> lockdep warns whenever a task acquires a mutex while holding another
> mutex of the same kind (that is, the same member in another structure
> of the same type).  But there are lots of places where the kernel needs
> to acquire dev->sem for one device while already holding
> dev->parent->sem.  There's no way to remove these, which means there's
> no way to prevent lockdep from issuing a warning.
>
> Around a month ago I had a discussion with Peter Zijlstra about the
> problems in converting the device semaphores to mutexes; you may be
> able to find it in the LKML archives.  Doing the conversion while
> keeping lockdep happy is a very hard problem and we were not able to
> solve it.
>

It's unfortunate to know this, I will search and read your thread.

> It's possible that you may be able to convert the semaphores in struct
> class or other structures.  But you won't succeed with struct device.
>
> Alan Stern
>
>
