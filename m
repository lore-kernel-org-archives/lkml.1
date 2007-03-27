Return-Path: <linux-kernel-owner+w=401wt.eu-S934135AbXC0SIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135AbXC0SIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934136AbXC0SIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:08:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934135AbXC0SIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:08:41 -0400
Date: Tue, 27 Mar 2007 11:05:24 -0700
From: Pete Zaitcev <zaitcev@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, gregkh@suse.de,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       zaitcev@redhat.com, davidz@redhat.com
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Message-Id: <20070327110524.975e7113.zaitcev@redhat.com>
In-Reply-To: <Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org>
References: <200703271824.46804.maximlevitsky@gmail.com>
	<Pine.LNX.4.44L0.0703271306230.2558-100000@iolanthe.rowland.org>
Organization: Red Hat, Inc.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.11; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 13:15:14 -0400 (EDT), Alan Stern <stern@rowland.harvard.edu> wrote:

> > Suspend to disk still causes "virtual replugging"  and I think that controller is reset and will unplug/replug devices anyway
> > Resolving this problem is very difficult. Maybe it possible to check on unplugging event that this caused by suspend  if the same device is
> > replugged then don't remove/reinstall driver, but this is very difficult to implement properly,
> > Maybe just refuse to suspend if some valuable device is connected (sorry if it is done this way already)
> 
> Long ago I posted a patch that would take care of all this.  Not just for
> UHCI, but for any USB controller.  Maybe I should dig it out, update it,
> and submit it.

Alan, BTW, look at this please:

https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=233697

> From David Zeuthen

> If I suspend my box, then on the resume path I see all my USB devices being
> removed and then added back. This is a problem with storage devices connected
> via USB.
.....
> The kernel not send an "remove" event if it's going to send an "add" right
> after. Instead it should enumerate the bus on resume and only send the events
> that represents how to get from the previous device tree to the current one.

> From Pete Zaitcev

> What does happen if a user suspends, unplugs a USB key, modifies its contents,
> plugs it back, and resumes? In such a case, there would be no change between
> the state of USB bus between the before-suspend state and after-resume state.

> From David Zeuthen

> In that case the user would see data corruption - just as if he mounts a piece
> of removable media in a USB card reader; yanks out the card and modifies it
> elsewhere, and then puts it back in.

> I my opinion we can't really defend ourselves against such users... We can of
> course add checks in the file system drivers in the resume hooks to validate the
> super block and mount read-only if something change. 

The GNOME hath spoken?

-- Pete
