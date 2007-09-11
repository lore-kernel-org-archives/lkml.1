Return-Path: <linux-kernel-owner+w=401wt.eu-S1753365AbXIKPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbXIKPLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 11:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbXIKPLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 11:11:11 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43307 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752635AbXIKPLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 11:11:10 -0400
Date: Tue, 11 Sep 2007 11:11:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Pete Zaitcev <zaitcev@redhat.com>, <linux-usb-devel@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>
Subject: Re: Oops in make_class_name in 2.6.22.1 on Fedora
In-Reply-To: <20070911061226.GB27404@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0709111106140.3852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007, Greg KH wrote:

> On Mon, Sep 10, 2007 at 08:26:47PM -0700, Pete Zaitcev wrote:
> > Hi, Greg (and others):
> > 
> > I do not seem to be able to find an answer, sorry.
> > Do you happen to remember if this was fixed after 2.6.22.1:
> > 
> > localhost kernel: EIP is at make_class_name+0x27/0x7a
> > localhost kernel:  [<c05586f1>] class_device_del+0x97/0x119
> > localhost kernel:  [<c055877b>] class_device_unregister+0x8/0x10
> > localhost kernel:  [<e08735f4>] __scsi_remove_device+0x1d/0x60 [scsi_mod]
> > localhost kernel:  [<e08711ae>] scsi_forget_host+0x2d/0x4a [scsi_mod]
> > localhost kernel:  [<e086c49c>] scsi_remove_host+0x65/0xd5 [scsi_mod]
> > localhost kernel:  [<e0e76775>] storage_disconnect+0xe/0x16 [usb_storage]
> > localhost kernel:  [<c056f8b8>] usb_unbind_interface+0x44/0x85
> > localhost kernel:  [<c0557df7>] __device_release_driver+0x6e/0x8b
> > 
> > Obviously a known bug but all I see is users reporting it. In my case
> > it's this:
> >  https://bugzilla.redhat.com/show_bug.cgi?id=253424
> > I saw Alan giving it a try here:
> >  http://lkml.org/lkml/2007/7/12/259
> 
> I think this was a scsi problem that has been fixed, but don't really
> remember the exact commit.

Yes.  There are some bugs in the SCSI async-scanning code, and there is
a patch to fix them:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=a93a091df8232fad60867d41fbc3be855a0b78f2

It is scheduled for 2.6.24.  For now, people can work around the bug by 
disabling CONFIG_SCSI_SCAN_ASYNC.

> Alan, any ideas?
> 
> It would probably be good to get this into the next -stable if we can
> figure out which patch did fix it.

I have urged both James Bottomley and Andrew Morton to apply that patch 
as soon as possible.  Neither of them paid any attention.

Alan Stern

