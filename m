Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZBRUnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZBRUnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZBRUmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:42:53 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:52277 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbZBRUmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:42:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=HzfUST8K5ljSMtLVKsK8jIf6j5a/o7rhTDA2/s2QKedm+HU+HNF4Qbs1HqammOLP9f
         ZqCh5+S/SfgBDMN+9AemDLqtnjPqoY0GFIXtW24e8Vobdp1ISuL35Nd0htxL0MkSYXJR
         VyFl8LaS133UmC4fCT40bB5kd73Q3/m0gHkAc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH] ide-cd: document capacity hack
Date: Wed, 18 Feb 2009 21:38:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-next-20090218; KDE/4.2.0; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <200902182018.52195.bzolnier@gmail.com> <499C62FF.1090805@ru.mvista.com>
In-Reply-To: <499C62FF.1090805@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902182138.15501.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 February 2009, Sergei Shtylyov wrote:
> Hello.
> 
> Bartlomiej Zolnierkiewicz wrote:
> 
> > Just copy the comment from drivers/scsi/sr.c::sr_done()
> > (from which the capacity hack has been originated).
> 
> > Cc: Borislav Petkov <petkovbb@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
> 
> > Index: b/drivers/ide/ide-cd.c
> > ===================================================================
> > --- a/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -189,6 +189,14 @@ static void cdrom_analyze_sense_data(ide
> >  			bio_sectors = max(bio_sectors(failed_command->bio), 4U);
> >  			sector &= ~(bio_sectors - 1);
> >  
> > +			/*
> > +			 * The SCSI specification allows for the value
> > +			 * returned by READ CAPACITY to be up to 75 2K
> > +			 * sectors past the last readable block.
> 
>     Oh horror... :-)
> 
> > +			 * Therefore, if we hit a medium error within the
> > +			 * last 75 2K sectors, we decrease the saved size
> > +			 * value.
> > +			 */
> >  			if (sector < get_capacity(info->disk) &&
> >  			    drive->probed_capacity - sector < 4 * 75)
> >  				set_capacity(info->disk, sector);
> 
>     Would be nice if the CHS capacity workround was finally documented too? ;-)

Send patches.  I have my hands full of work...
