Return-Path: <linux-kernel-owner+w=401wt.eu-S1755628AbYEZRi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628AbYEZRi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 13:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbYEZRiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 13:38:50 -0400
Received: from styx.suse.cz ([82.119.242.94]:45546 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753717AbYEZRiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 13:38:50 -0400
Date: Mon, 26 May 2008 19:38:48 +0200
From: Jan Kara <jack@suse.cz>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>, Theodore Tso <tytso@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, Jan Kara <jack@suse.cz>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Top 10 bugs/warnings for the week of March 23rd, 2008
Message-ID: <20080526173848.GM32407@duck.suse.cz>
References: <4836EE8C.1010200@linux.intel.com> <20080526164858.GA24098@elte.hu> <20080526170147.GB9893@mit.edu> <200805261909.59032.oliver@neukum.org> <e2e108260805261028o204d4fc7l3f20ad3919cf778b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260805261028o204d4fc7l3f20ad3919cf778b@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 26-05-08 19:28:23, Bart Van Assche wrote:
> On Mon, May 26, 2008 at 7:09 PM, Oliver Neukum <oliver@neukum.org> wrote:
> > Am Montag 26 Mai 2008 19:01:48 schrieb Theodore Tso:
> >> If the USB stack folks would like to work on how to recognize that
> >> it's the same USB stick that had been previously pulled, so that it
> >> gets the same block device, and we can decide for how long we should
> >> keep dirty buffers around associated with a pulled USB stick, we can
> >> certainly have that conversation.  :-)
> >
> > Even if we could tell whether the device has remained the same, how
> > would we know the medium wasn't exchanged?
> 
> Looking at the filesystem UUID could help -- this is an ID that is
> present as data on the disk, and that is even independent of the bus
> type. See also /dev/disk/by-uuid.
  Yes, but as Oliver wrote if someone modified the filesystem in the mean
time, you won't notice it - UUID doesn't help here.

> For the journaling filesystems I am familiar with the default value
> for the commit parameter is 5 seconds. Would it be a good idea to
> leave the default to 5s for non-removable devices, and to change this
> default to 1s for removable devices ?
  I don't think it's a good idea:
1) You'd even more stress wear-leveling of USB flash drives - btw, given
their sizes it does not make much sence to use ext3 on your USB stick. I
still use VFAT/ext2 there.

2) You'd probably notice performance decrease because of more journaling
overhead.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
