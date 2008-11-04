Return-Path: <linux-kernel-owner+w=401wt.eu-S1755457AbYKDT5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457AbYKDT5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:57:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752570AbYKDT5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:57:39 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:59835 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752163AbYKDT5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:57:38 -0500
Date: Tue, 4 Nov 2008 20:57:29 +0100
From: Pavel Machek <pavel@suse.cz>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: data corruption: revalidating a (removable) hdd/flash on
	re-insert
Message-ID: <20081104195728.GC5862@ucw.cz>
References: <490B2659.9010304@msgid.tls.msk.ru> <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac3eb2510810310910w603d90bai8c23b34fb517f21a@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2008-10-31 17:10:26, Kay Sievers wrote:
> On Fri, Oct 31, 2008 at 16:38, Michael Tokarev <mjt@tls.msk.ru> wrote:
> > To make a long story short: is there a way to force kernel
> > to re-validate a replaced usb-connected hard drive (or a
> > flash) *automatically*?
> >
> > Because right now, the kernel does not see that the drive
> > has been replaced, and uses *some* old cached values, which
> > results in random data corruption here and there, and other
> > similar odd things.
> 
> Maybe your card reader is broken. I can not reproduce this with any of
> the many readers I have. Usually a media change results in media
> revalidation with the next access to the device. You can easily
> reproduce that:
> 
> Insert the media, and force a validation:
>   $ touch /dev/sdb
> 
> Start logging of the kernel uevents to the console:
>   $ udevadm monitor --kernel &
> 
> Access the device:
>   $ touch /dev/sdb
> 
> Nothing should happen, as the reader/kernel knows it is still valid.
> 
> Now remove the media and insert it immediately again.
> 
> Access the device:
>   $ touch /dev/sdb
>   UEVENT[1225468868.803950] change
> /devices/pci0000:00/0000:00:1d.7/usb5/5-2/5-2:1.0/host8/target8:0:0/8:0:0:0
> (scsi)
> 
> and you see the reader told to kernel (scsi unit attention) to
> revalidate the device.
> 
> These events happen only when the device is accessed. That's why
> distros poll removable devices for media changes.
> 
> Every access to removable media is guarded by this revalidation check.
> If you don't see these events, you should not trust this reader, and
> at least never change the media while it is connected.

This is rather nasty data-corrupter. Could we at least blacklist
broken device, and force revalidation on each close or something like
that?


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
