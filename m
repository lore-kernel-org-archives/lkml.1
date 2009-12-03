Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZLCMqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZLCMqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 07:46:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZLCMqH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 07:46:07 -0500
Received: from mail-ew0-f214.google.com ([209.85.219.214]:37785 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbZLCMqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 07:46:02 -0500
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Dec 2009 07:46:01 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=ftRIv/ba0U6Cvgr3VEHy3T5cAp/De+wom6zg6IdGVRTrcs0k6175ZEYHZbazZyC0XU
         LL3nzoh2ef3bZV4Dnfe5UY8PgxuDlBMs9vfCjfha8sX76cbIqbbL4AtN0438rEGueVab
         ETIdp5Fmigs57zw2o5JS0IP06NEsGFukNKlxw=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 86/86] libata: add private driver field to struct ata_device
Date: Thu, 3 Dec 2009 13:37:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20091125170218.5446.13513.sendpatchset@localhost> <20091125171248.5446.22482.sendpatchset@localhost> <4B177118.5020501@garzik.org>
In-Reply-To: <4B177118.5020501@garzik.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912031337.41440.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 December 2009 09:04:40 am Jeff Garzik wrote:
> On 11/25/2009 12:12 PM, Bartlomiej Zolnierkiewicz wrote:
> > From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> > Subject: [PATCH] libata: add private driver field to struct ata_device
> >
> > This brings struct ata_device in-line with struct ata_{port,host}.
> >
> > Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> > ---
> >   include/linux/libata.h |    1 +
> >   1 file changed, 1 insertion(+)
> >
> > Index: b/include/linux/libata.h
> > ===================================================================
> > --- a/include/linux/libata.h
> > +++ b/include/linux/libata.h
> > @@ -585,6 +585,7 @@ struct ata_device {
> >   	unsigned int		horkage;	/* List of broken features */
> >   	unsigned long		flags;		/* ATA_DFLAG_xxx */
> >   	struct scsi_device	*sdev;		/* attached SCSI device */
> > +	void			*private_data;
> >   #ifdef CONFIG_ATA_ACPI
> >   	acpi_handle		acpi_handle;
> >   	union acpi_object	*gtf_cache;
> 
> I'm fine with this, and would like to merge this sooner rather than later.
> 
> However, BIG FAT WARNING:  you must take special care to be sure you 
> don't leak as devices appear and disappear, etc.  IOW, watch your object 
> lifetimes carefully.  Object lifetime was the reason this was not added 
> until now.

It should be fine for now as the only user is pata_ep93xx and it gets it
right.  Though it would definitely be nice to see the underlying issue
(which is the lack of dynamic allocation for struct ata_device objects)
fixed one day in libata.

--
Bartlomiej Zolnierkiewicz
