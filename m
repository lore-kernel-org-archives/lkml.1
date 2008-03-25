Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbYCYTZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbYCYTZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 15:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757120AbYCYTZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 15:25:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:44764 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243AbYCYTZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 15:25:34 -0400
Date: Tue, 25 Mar 2008 12:25:15 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Lord <lkml@rtr.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jens Axboe <axboe@kernel.dk>,
       Jeff Garzik <jgarzik@pobox.com>, Tejun Heo <htejun@gmail.com>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: What to do about the 2TB limit on HDIO_GETGEO ?
Message-ID: <20080325192515.GA24234@suse.de>
References: <47E875AD.1000901@rtr.ca> <47E87942.2020409@rtr.ca> <47E88A13.70808@zytor.com> <47E90019.3050006@rtr.ca> <47E90458.7030801@zytor.com> <47E9383F.3050908@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E9383F.3050908@rtr.ca>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2008 at 01:37:03PM -0400, Mark Lord wrote:
> H. Peter Anvin wrote:
>> Mark Lord wrote:
>>>
>>> Yeah, that would be just as good, really.  Maybe even better.
>>>
>>> Mark Lord wrote (later on):
>>>> Instead, software has to search everything inside /sys/block/
>>>> looking for a "dev" file whose contents match,
>>>> rather than just trying to access something like this:
>>>>
>>>>   /sys/block/8:1/start
>>>> or
>>>>   /sys/block/majors/8/minors/1/start
>>>>
>>>> Or any one of a number of similar ways to arrange it. 
>>> ..
>> It shouldn't be under /sys/block... there are enough many things that scan 
>> /sys/block and assume any directory underneath it has the current format.
> ..
>
> So long as we only add things, and not remove them, then any software
> that scans /sys/block/ shouldn't care, really.
>
> But yes, it could go elsewhere, too.
> Perhaps a /sys/dev/ directory, populated with symbolic links
> (or hard links?) back to the /sys/block/ entries, something like this:
>
>   /sys/dev/block/8:0 -> ../../../block/sda
>   /sys/dev/block/8:1 -> ../../../block/sda/sda1
>   /sys/dev/block/8:2 -> ../../../block/sda/sda2
>   ...
>
> That's just a suggestion, really.
> And what about character devices?
>
> Perhaps Greg will chime in.

I've been waiting to see if sanity will take hold of anyone here.

Come on people, adding symlinks for device major:minor numbers in sysfs
to save a few 10s of lines of userspace code?  Can things get sillier?

You can add a single udev rule to probably build these in a tree in /dev
if you really need such a thing...

And what's wrong with your new ioctl recomendation?

greg k-h
