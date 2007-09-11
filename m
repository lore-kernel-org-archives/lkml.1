Return-Path: <linux-kernel-owner+w=401wt.eu-S933650AbXIKJSR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933650AbXIKJSR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 05:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762067AbXIKJSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 05:18:04 -0400
Received: from mtagate1.de.ibm.com ([195.212.29.150]:51150 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762110AbXIKJSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 05:18:00 -0400
Date: Tue, 11 Sep 2007 11:17:58 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Pete Zaitcev <zaitcev@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: Oops in make_class_name in 2.6.22.1 on Fedora
Message-ID: <20070911111758.662f58ae@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070911061226.GB27404@kroah.com>
References: <20070910202647.24094d57.zaitcev@redhat.com>
	<20070911061226.GB27404@kroah.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 23:12:26 -0700,
Greg KH <greg@kroah.com> wrote:

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

It may be something like "removing a device before it has been
completely initialized" (class_device_unregister() racing against
class_device_register()). (Perhaps you can see if that is the case by
turning on verbose driver core and kobject debugging messages.)
