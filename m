Return-Path: <linux-kernel-owner+w=401wt.eu-S1755183AbZG2QUG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183AbZG2QUG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 12:20:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754237AbZG2QUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 12:20:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752999AbZG2QUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 12:20:04 -0400
Date: Wed, 29 Jul 2009 09:16:43 -0700
From: Greg KH <gregkh@suse.de>
To: Jakob Gruber <jakob.gruber@kabelnet.at>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Missing device IDs in rt2870
Message-ID: <20090729161643.GA6313@suse.de>
References: <20090728230117.8fca2314.jakob.gruber@kabelnet.at>
 <20090728211216.GA12363@suse.de>
 <20090729171107.155719b5.jakob.gruber@kabelnet.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090729171107.155719b5.jakob.gruber@kabelnet.at>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 29, 2009 at 05:11:07PM +0200, Jakob Gruber wrote:
> On Tue, 28 Jul 2009 14:12:16 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Tue, Jul 28, 2009 at 11:01:17PM +0200, Jakob Gruber wrote:
> > > >From http://bugzilla.kernel.org/show_bug.cgi?id=13459#c3
> > > 
> > > In rt2870.h, there are 2 lists of USB devices. One is within 
> > > 
> > > #ifndef RT30xx
> > > #endif
> > > 
> > > and the other in 
> > > 
> > > #ifdef RT30xx
> > > #endif
> > 
> > That kind of implies that the 2870 driver should not support this
> > device, right?
> 
> I think there's been a misunderstanding - I wasn't saying that the
> device ID is included in one block but not in another. I wanted to
> point out that I wasn't sure whether to add the ID to both lists or
> just the first one.

Ah, ok.  It looks like you just need the first one.

> > > Since I'm not sure whether to add the devices to both lists or only the first,
> > > I'm posting a patch for both variations.
> > > 
> > > Patch 1, add devices only to first list:
> > 
> > Well, pick one :)
> > 
> > I'd prefer someone with one of these devices to test the patch and
> > verify that it works before blindly applying.  Fair enough?
> 
> I own the Belkin device in question (0x050D,0x815C), and it worked
> perfectly with kernel 2.6.29 after adding the device ID to rt2870.h.
> The patch is also included in the Archlinux kernel, see 
> http://projects.archlinux.org/?p=linux-2.6-ARCH.git;a=tree;f=patches;hb=HEAD
> 
> I haven't tested rt2870 in 2.6.30 thoroughly because of this bug
> (http://bugzilla.kernel.org/show_bug.cgi?id=13638), which forces me to
> use the driver from the Ralink website instead of the kernel module.
> However, I can confirm that - until running into the bug - the Belkin
> card also works in 2.6.30. 

Ah, that sucks.  I should revert that patch, if you do that, does the
device work properly for you?

> A patch for adding the Belkin device ID is attached. I removed the
> other 2 IDs from http://bugzilla.kernel.org/show_bug.cgi?id=13459
> since I do not own these devices and cannot verify them. The ID is
> only added to the "#ifndef RT30xx" block, same as the patch applied to
> the Archlinux kernel.

I'll take the other two ids, now that it makes more sense.

Care to respin with the 2 new ids, and add a "Signed-off-by:" to the
patch so I can properly apply it?

thanks,

greg k-h
