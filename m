Return-Path: <linux-kernel-owner+w=401wt.eu-S965055AbXDAUu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965055AbXDAUu0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 16:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965044AbXDAUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 16:50:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50548 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095AbXDAUuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 16:50:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
Date: Sun, 1 Apr 2007 22:53:37 +0200
User-Agent: KMail/1.9.5
Cc: Alan Stern <stern@rowland.harvard.edu>, David Zeuthen <davidz@redhat.com>,
       Maxim <maximlevitsky@gmail.com>, Pete Zaitcev <zaitcev@redhat.com>,
       gregkh@suse.de, Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
References: <20070401175020.GE11146@elf.ucw.cz> <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org> <20070401183437.GH11146@elf.ucw.cz>
In-Reply-To: <20070401183437.GH11146@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704012253.38931.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday, 1 April 2007 20:34, Pavel Machek wrote:
> Hi!
> 
> > > Problem is that suspending _with_ removable mass storage devices
> > > attached just will not work. User will unplug them, then complain
> > > about corruption. Advanced user will unplug them, work with them
> > > somewhere else, replug them, then loose filesystem.
> > > 
> > > Feel free to send patch to teach filesystems to handle this.
> > 
> > Actually what's needed is a Persistent Logical Volume Manager.  With it,
> > you could even mount a filesystem on a USB device, unplug the device, plug
> > it back into a different port, and still be able to use the filesystem.
> > 
> > But you're still likely to run into trouble if you unplug a storage
> > device, move it to another system and write on it, then plug it back into
> > the original system.  The PLVM would somehow have to recognize that the
> > data had been changed.  I don't know a foolproof way of doing that.
> 
> Such detection should be possible when done at filesystem level.
> 
> I.e. ext3 would notice that someone replayed the journal.
> 
> Or we could create ext5 where each r/w mount would update mount
> time... actually we probably already have last mount time in ext3,
> so...

I'm thinking we'll need to introduce something like freezing notifiers, ie.
the ability to register a notifier by an interested subsystem that will be
called right after user space processes have been frozen and right before
we start to thaw them (that may allow us to handle the microcode issue in
a clean way, for example).

Now if a filesystem registers a freezing notifier, it may be unmounted during
the suspend and remounted during the resume in more or less transparent
way.  I think an additional mount flag would be needed for filesystem that
should install such notifiers, like "removable".

Greetings,
Rafael
