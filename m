Return-Path: <linux-kernel-owner+w=401wt.eu-S1764861AbYEOT6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764861AbYEOT6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 15:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758559AbYEOTz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 15:55:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42330 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762666AbYEOTz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 15:55:57 -0400
Date: Thu, 15 May 2008 15:55:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Bill Nottingham <notting@redhat.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Problems with suspend and USB storage
In-Reply-To: <200805152140.43292.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0805151552140.3307-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Rafael J. Wysocki wrote:

> On Thursday, 15 of May 2008, Bill Nottingham wrote:
> > 
> > I've been testing suspend/hibernate with various USB devices under
> > 2.6.25.2. Test box is a Thinkpad T60 (uhci, ehci).
> > The results are somewhat dismal.
> > 
> > Using USB as a hibernate device:
> > - A directly connected USB stick works OK as a hibernate device
> > - A directly connected USB hard drive works OK as a hibernate device
> > - A USB stick connected via an ExpressCard reader does not - it appears
> >   to just not be there when the hibernate code attemps to write
> >   the data.
> > 
> > On resume (from either hibernate or suspend from RAM):
> > - Any 'in use' USB storage, whether it be as swap (a hibernate device),
> >   or a mounted filesystem, immediately generates errors on resume. It
> >   appears the filesystem and/or swap tasks are woken up before the
> >   actual USB device - it enumerates the disks after the errors have
> >   already been thrown.
> > - As a consequence, the USB devices shift their device names
> > - Using USB_PERSIST has no effect on this problem
> > - This appears to happen for all USB connection types (hard drive,
> >   stick, via ExpressCard reader.)
> > 
> > Is there any way to get sane behavior out of suspend/resume with
> > USB storage?
> 
> Well, the problem is that USB storage devices are disconnected during suspend
> and hibernation and connected once again during resume.  Then, however, we
> are not able to tell whether the device in the slot is the same that was in
> there before the system was put into the sleep state.
> 
> I'm not sure if there's any workaround available in the current mainline.

You can try applying one of the gregkh-04-usb-* patches at

http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/

They include changes to the way hub-resume handling works, as well as 
more debugging output.  Be sure to enable CONFIG_USB_DEBUG and post the 
relevant dmesg log.

Alan Stern

