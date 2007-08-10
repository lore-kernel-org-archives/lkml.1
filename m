Return-Path: <linux-kernel-owner+w=401wt.eu-S939069AbXHJQjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939069AbXHJQjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936336AbXHJQjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:39:31 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:41633 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933529AbXHJQja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:39:30 -0400
Subject: Re: [SCSI] aic94xx: new driver
From: James Bottomley <James.Bottomley@SteelEye.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1186761988.7615.10.camel@shinybook.infradead.org>
References: <200609240400.k8O403OJ024220@hera.kernel.org>
	 <1186758562.7615.6.camel@shinybook.infradead.org>
	 <1186761166.3335.6.camel@localhost.localdomain>
	 <1186761988.7615.10.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 09:39:24 -0700
Message-Id: <1186763964.3335.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-11 at 00:06 +0800, David Woodhouse wrote:
> On Fri, 2007-08-10 at 08:52 -0700, James Bottomley wrote:
> > On Fri, 2007-08-10 at 23:09 +0800, David Woodhouse wrote:
> > > On Sun, 2006-09-24 at 04:00 +0000, Linux Kernel Mailing List wrote:
> > > > --- a/include/scsi/scsi.h
> > > > +++ b/include/scsi/scsi.h
> > > > @@ -429,4 +429,10 @@ #define SCSI_IOCTL_GET_BUS_NUMBER  0x5386
> > > >  /* Used to obtain the PCI location of a device */
> > > >  #define SCSI_IOCTL_GET_PCI             0x5387
> > > >  
> > > > +/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
> > > > +static inline u32 scsi_to_u32(u8 *ptr)
> > > > +{
> > > > +       return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
> > > > +}
> > > > +
> > > >  #endif /* _SCSI_SCSI_H */ 
> > > 
> > > Please explain why it's necessary to export this to userspace.
> > 
> > Er it's not ... but then it's not necessary to export this entire file,
> > either.
> 
> That's an acceptable answer, I suppose, given that glibc ships its own
> copy of the file in question.
> 
> But it does contain ioctl definitions, and if we ever added any new
> ioctls presumably they'd be added there too? It does seem to be the kind
> of thing we _do_ want to export from the kernel, surely?

Oh .. I thought we'd already got around that one by duplicating the
ioctls?  Those five are all deprecated, but if that's what you want
exporting, we could separate them into a new file.

> > From the SCSI point of view, the function definitely belongs in that
> > file because it's an accessor to facilitate the processing of commands
> > and their replies, which is what that file contains ... in fact it
> > contains a lot of the internal mechanics of the SCSI layer that the user
> > shouldn't necessarily be seeing.
> 
> All the more reason for us to export it for ourselves and exert some
> editorial control, perhaps?

Even if I'd known it was exported, I'm still not sure I'd have noticed
why or what the issues are.

James


