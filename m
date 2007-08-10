Return-Path: <linux-kernel-owner+w=401wt.eu-S936092AbXHJPw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936092AbXHJPw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765418AbXHJPwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:52:49 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:48414 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765326AbXHJPws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:52:48 -0400
Subject: Re: [SCSI] aic94xx: new driver
From: James Bottomley <James.Bottomley@SteelEye.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1186758562.7615.6.camel@shinybook.infradead.org>
References: <200609240400.k8O403OJ024220@hera.kernel.org>
	 <1186758562.7615.6.camel@shinybook.infradead.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 08:52:46 -0700
Message-Id: <1186761166.3335.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-10 at 23:09 +0800, David Woodhouse wrote:
> On Sun, 2006-09-24 at 04:00 +0000, Linux Kernel Mailing List wrote:
> > --- a/include/scsi/scsi.h
> > +++ b/include/scsi/scsi.h
> > @@ -429,4 +429,10 @@ #define SCSI_IOCTL_GET_BUS_NUMBER  0x5386
> >  /* Used to obtain the PCI location of a device */
> >  #define SCSI_IOCTL_GET_PCI             0x5387
> >  
> > +/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
> > +static inline u32 scsi_to_u32(u8 *ptr)
> > +{
> > +       return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
> > +}
> > +
> >  #endif /* _SCSI_SCSI_H */ 
> 
> Please explain why it's necessary to export this to userspace.

Er it's not ... but then it's not necessary to export this entire file,
either.

> The files in /usr/include/scsi are actually shipped by glibc, and most
> distributions use glibc's version instead of the one from the kernel --
> so this additional userspace interface is automatically incompatible
> with most people's installations.
> 
> It would perhaps make sense to stop glibc providing these files, and let
> distributions use the version from the kernel -- but that's a separate
> issue. And still doesn't seem to justify the addition of the above
> function.

>From the SCSI point of view, the function definitely belongs in that
file because it's an accessor to facilitate the processing of commands
and their replies, which is what that file contains ... in fact it
contains a lot of the internal mechanics of the SCSI layer that the user
shouldn't necessarily be seeing.

James


