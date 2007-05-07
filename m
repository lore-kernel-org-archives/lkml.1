Return-Path: <linux-kernel-owner+w=401wt.eu-S965148AbXEGPcy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965148AbXEGPcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:32:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934311AbXEGPcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:32:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:50322 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934219AbXEGPcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:32:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,501,1170662400"; 
   d="scan'208";a="240307586"
Date: Mon, 7 May 2007 08:29:28 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org
Subject: Re: [patch 6/7] SCSI: save disk in scsi_device - resend
Message-Id: <20070507082928.17878961.kristen.c.accardi@intel.com>
In-Reply-To: <1178310648.3711.56.camel@mulgrave.il.steeleye.com>
References: <20070424074856.005152262@intel.com>
	<20070504111733.f507501d.kristen.c.accardi@intel.com>
	<1178310648.3711.56.camel@mulgrave.il.steeleye.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 May 2007 15:30:48 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Fri, 2007-05-04 at 11:17 -0700, Kristen Carlson Accardi wrote:
> > Give anyone who has access to scsi_device access to the genhd struct as well.
> > 
> > Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > Index: 2.6-git/drivers/scsi/sd.c
> > ===================================================================
> > --- 2.6-git.orig/drivers/scsi/sd.c
> > +++ 2.6-git/drivers/scsi/sd.c
> > @@ -1711,6 +1711,7 @@ static int sd_probe(struct device *dev)
> >  
> >  	dev_set_drvdata(dev, sdkp);
> >  	add_disk(gd);
> > +	sdp->disk = gd;
> >  
> >  	sdev_printk(KERN_NOTICE, sdp, "Attached scsi %sdisk %s\n",
> >  		    sdp->removable ? "removable " : "", gd->disk_name);
> > Index: 2.6-git/drivers/scsi/sr.c
> > ===================================================================
> > --- 2.6-git.orig/drivers/scsi/sr.c
> > +++ 2.6-git/drivers/scsi/sr.c
> > @@ -604,6 +604,7 @@ static int sr_probe(struct device *dev)
> >  	if (sdev->media_change_notify)
> >  		disk->flags |= GENHD_FL_MEDIA_CHANGE_NOTIFY;
> >  	add_disk(disk);
> > +	sdev->disk = disk;
> >  
> >  	sdev_printk(KERN_DEBUG, sdev,
> >  		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
> > Index: 2.6-git/include/scsi/scsi_device.h
> > ===================================================================
> > --- 2.6-git.orig/include/scsi/scsi_device.h
> > +++ 2.6-git/include/scsi/scsi_device.h
> > @@ -138,7 +138,7 @@ struct scsi_device {
> >  
> >  	struct device		sdev_gendev;
> >  	struct class_device	sdev_classdev;
> > -
> > +	struct gendisk 		*disk;
> >  	struct execute_work	ew; /* used to get process context on put */
> >  
> >  	enum scsi_device_state sdev_state;
> 
> If you're going to do this, you need to take on board removing the
> struct gendisk from all the ULD structures (since it's now become
> generic).
> 
> James
> 

Ok - I can send that as a separate patch series, or I can include it
in this one.  Which is preferred?
