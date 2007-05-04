Return-Path: <linux-kernel-owner+w=401wt.eu-S932500AbXEDIaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932500AbXEDIaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXEDIaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:30:22 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59636 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500AbXEDI37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:29:59 -0400
X-Originating-Ip: 72.143.66.196
Date: Fri, 4 May 2007 04:29:37 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] SCSI: Remove redundant GFP_KERNEL type flag in kmalloc().
In-Reply-To: <20070504011535.ff7181fb.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0705040426460.22990@localhost.localdomain>
References: <Pine.LNX.4.64.0704300434460.3703@localhost.localdomain>
 <20070504011535.ff7181fb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 May 2007, Andrew Morton wrote:

>
> Please be careful to add the appropriate cc's.
>
> On Mon, 30 Apr 2007 04:37:22 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
>
> >
> > Remove the apparently redundant GFP_KERNEL type flag in the call to
> > kmalloc().
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> > diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
> > index a988d5a..765ded0 100644
> > --- a/drivers/scsi/aic7xxx_old.c
> > +++ b/drivers/scsi/aic7xxx_old.c
> > @@ -6581,7 +6581,7 @@ aic7xxx_slave_alloc(struct scsi_device *SDptr)
> >    struct aic7xxx_host *p = (struct aic7xxx_host *)SDptr->host->hostdata;
> >    struct aic_dev_data *aic_dev;
> >
> > -  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
> > +  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC);
>
> No, this converts the allocation from a robust one which can sleep into a
> flakey one which cannot.

... snip ...

at this point, i'd be happier to leave the appropriate patches in the
hands of those who have a better handle on this.  as i posted earlier,
there's only two examples of this in the entire tree:

drivers/scsi/aic7xxx_old.c:  aic_dev = kmalloc(sizeof(struct aic_dev_data), GFP_ATOMIC | GFP_KERNEL);
drivers/message/i2o/device.c:   resblk = kmalloc(buflen + 8, GFP_KERNEL | GFP_ATOMIC);

it's all yours.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
