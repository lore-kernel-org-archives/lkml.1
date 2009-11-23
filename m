Return-Path: <linux-kernel-owner+w=401wt.eu-S1756508AbZKWUGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756508AbZKWUGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 15:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753758AbZKWUGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 15:06:13 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:61964 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbZKWUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 15:06:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SiACzI5Y6QYGZjp2osVD+XSO7v8FeUYwC3A+mTHLW/2qSId1/hoMqmnyYBCxShn0A1
         4b2fgzFl7ZzfIZpO4Dino7kkgaaH35I7BsJt+yu/Tar/YZY7Qa8zpOzaFGo4H3eAifnP
         Na9iFwObFO7L2fhvORf3pcD4Y4ucTMgsIJHfM=
Date: Mon, 23 Nov 2009 15:06:05 -0500
From: tmhikaru@gmail.com
To: Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
       linux-ext4@vger.kernel.org
Subject: Re: Weird I/O errors with USB hard drive not remounting filesystem readonly
Message-ID: <20091123200605.GA19446@roll>
References: <20091123160914.GG15679@duck.suse.cz> <Pine.LNX.4.44L0.0911231319060.2958-100000@iolanthe.rowland.org> <20091123185449.GA11186@quack.suse.cz> <20091123195022.GA18510@roll>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091123195022.GA18510@roll>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 02:50:22PM -0500, tm@ wrote:
> On Mon, Nov 23, 2009 at 07:54:50PM +0100, Jan Kara wrote:
> > On Mon 23-11-09 13:20:26, Alan Stern wrote:
> > > On Mon, 23 Nov 2009, Jan Kara wrote:
> > > 
> > > > On Mon 23-11-09 10:06:03, Alan Stern wrote:
> > > > > On Mon, 23 Nov 2009, Jan Kara wrote:
> > > > > 
> > > > > >   Yeah, from what you write, it looks like USB enclosure is at fault (or it
> > > > > > could still be your USB controller but I doubt it).  It's still a bit
> > > > > > bothering that the error reported by the drive was not properly propagated
> > > > > > up to VFS. Either it's some block layer retry/ignore magic that I missed or
> > > > > > we ignore errors from block layer in some place.
> > > > > 
> > > > > Is there any interest in tracking this down?  It's not hard to find out
> > > > > what low-level errors are being reported and to generate them on demand
> > > > > with an emulated USB disk drive.
> > > >   Well, if you could provide me with the patch, I could try to track down
> > > > why the errors aren't propagated... It would be interesting because if it's
> > > > not some retry logic in block layer, it's a bug in VFS ;).
> > > 
> > > I can't provide a patch without first knowing what the errors are.  The 
> > > way to find out is to use usbmon.  See Documentation/usb/usbmon.txt for 
> > > instructions.
> >   Ah, OK. The problem manifests itself as an error in SATA communication
> > (which in fact somehow happens over USB, but I don't really know the
> > details of mass storage over USB) so debugging USB would become actual only
> > if we found out it's really some bug in an usb stack. But so far the most
> > probable is just an error somewhere between the USB controller in the
> > enclosure and the drive itself. BTW: Is the data transferred over USB
> > checksummed?
> > 
> > 									Honza
> 	Mind that this is an ide hard drive in a usb enclosure, not sata.
> The error reported is bizzare. I don't know if I'll be able to get the
> enclosure to cause the error on demand, but before I try supergluing it,
> I'll try to do whatever I need to do with usbmon so we can get the error
> that's actually happening so you can do whatever you need to do to track it
> down :)
> 
> Tim McGrath
Uhh, this could be a problem. CONFIG_USB_MON=y is set in my .config BUT,
although I followed the directions and debugfs is mounted,

root@roll:/home/tm# mount
/dev/root on / type ext4 (rw,relatime,barrier=1,data=ordered,data_err=abort)
proc on /proc type proc (rw)
sysfs on /sys type sysfs (rw)
usbfs on /proc/bus/usb type usbfs (rw)
none_debugs on /sys/kernel/debug type debugfs (rw)

I receive this message when I test if usbmon's directory exists:

root@roll:/home/tm# ls /sys/kernel/debug/usbmon
ls: cannot access /sys/kernel/debug/usbmon: No such file or directory

According to the kernel documentation usbmon should be loaded already. Help?

Timothy McGrath
