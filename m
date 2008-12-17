Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1751810AbYLQT7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbYLQT7X (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 14:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbYLQT6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 14:58:48 -0500
Received: from kroah.org ([198.145.64.141]:35613 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751275AbYLQT6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 14:58:46 -0500
Date: Wed, 17 Dec 2008 11:53:29 -0800
From: Greg KH <greg@kroah.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [BUG] cdev_put() race condition
Message-ID: <20081217195329.GB25211@kroah.com>
References: <200812082156.26522.hverkuil@xs4all.nl> <20081217181645.GA26161@kroah.com> <200812172030.32535.hverkuil@xs4all.nl> <200812172039.03436.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812172039.03436.hverkuil@xs4all.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 08:39:03PM +0100, Hans Verkuil wrote:
> On Wednesday 17 December 2008 20:30:32 Hans Verkuil wrote:
> >
> > This solves this particular problem. But this will certainly break v4l as
> > it is right now, since the spin_lock means that the kref's release cannot
> > do any sleeps, which is possible in v4l. If we want to allow that in
> > cdev, then the spinlock has to be replaced by a mutex. But I have the
> > strong feeling that that's not going to happen :-)
> 
> Note that if we ever allow drivers to hook in their own release callback, 
> then we certainly should switch to a mutex in the cdev struct, rather than 
> a global mutex. It obviously makes life more complicated for cdev, but much 
> easier for drivers.

I don't see it being easier for drivers, you should provide this kind of
infrastructure within your framework already.

Actually, we already do provide this kind of framework, what's wrong
with using "struct device" for this, like the rest of the kernel does?
That is the device you need to be doing the reference counting and
release code for, it is exactly what it is there for.

So why is V4L different than the rest of the kernel in that it wishes to
do things differently?

confused,

greg k-h
