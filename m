Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752042AbYLQUTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbYLQUTM (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 15:19:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYLQUSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 15:18:55 -0500
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1451 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbYLQUSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 15:18:54 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Greg KH <greg@kroah.com>
Subject: Re: [BUG] cdev_put() race condition
Date: Wed, 17 Dec 2008 21:18:29 +0100
User-Agent: KMail/1.9.9
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
References: <200812082156.26522.hverkuil@xs4all.nl> <200812172039.03436.hverkuil@xs4all.nl> <20081217195329.GB25211@kroah.com>
In-Reply-To: <20081217195329.GB25211@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812172118.29574.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 17 December 2008 20:53:29 Greg KH wrote:
> On Wed, Dec 17, 2008 at 08:39:03PM +0100, Hans Verkuil wrote:
> > On Wednesday 17 December 2008 20:30:32 Hans Verkuil wrote:
> > > This solves this particular problem. But this will certainly break
> > > v4l as it is right now, since the spin_lock means that the kref's
> > > release cannot do any sleeps, which is possible in v4l. If we want to
> > > allow that in cdev, then the spinlock has to be replaced by a mutex.
> > > But I have the strong feeling that that's not going to happen :-)
> >
> > Note that if we ever allow drivers to hook in their own release
> > callback, then we certainly should switch to a mutex in the cdev
> > struct, rather than a global mutex. It obviously makes life more
> > complicated for cdev, but much easier for drivers.
>
> I don't see it being easier for drivers, you should provide this kind of
> infrastructure within your framework already.
>
> Actually, we already do provide this kind of framework, what's wrong
> with using "struct device" for this, like the rest of the kernel does?
> That is the device you need to be doing the reference counting and
> release code for, it is exactly what it is there for.
>
> So why is V4L different than the rest of the kernel in that it wishes to
> do things differently?

Because it has almost no proper framework to speak of and what little there 
is has been pretty much unchanged since the very beginning.

I'm trying to develop a decent framework that should help support upcoming 
devices and generally make life easier for v4l driver developers.

And I've no idea why we don't just use the device's release() callback for 
this. I'm going to implement this right now :-)

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG
