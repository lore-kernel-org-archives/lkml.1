Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbZEOTFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbZEOTFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 15:05:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZEOTEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 15:04:54 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2167 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZEOTEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 15:04:53 -0400
Subject: Re: [PATCH 09/11] drivers/scsi: Convert #ifdef DEBUG
 printk(KERN_DEBUG to pr_debug(
From: Joe Perches <joe@perches.com>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <1242413806.22585.2.camel@mulgrave.int.hansenpartnership.com>
References: <cover.1242407227.git.joe@perches.com>
	 <d6d5dc09d259cc1da0fef2b1e9c6b7588cccf0b4.1242407227.git.joe@perches.com>
	 <1242413806.22585.2.camel@mulgrave.int.hansenpartnership.com>
Content-Type: text/plain
Date: Fri, 15 May 2009 12:04:52 -0700
Message-Id: <1242414292.3373.6.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-15 at 18:56 +0000, James Bottomley wrote:
> On Fri, 2009-05-15 at 10:59 -0700, Joe Perches wrote:
> > diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
> > index 8059494..29d5118 100644
> > --- a/drivers/scsi/aha1542.c
> > +++ b/drivers/scsi/aha1542.c
> > @@ -509,9 +509,7 @@ static void aha1542_intr_handle(struct Scsi_Host *shost)
> >  		if (mbistatus == 3)
> >  			continue;	/* Aborted command not found */
> >  
> > -#ifdef DEBUG
> > -		printk(KERN_DEBUG "...done %d %d\n", mbo, mbi);
> > -#endif
> > +		pr_debug("...done %d %d\n", mbo, mbi);
> 
> This one looks dangerous ... that's a per trigger printk from interrupt
> context.  That's a lot of stuff to bung in the log buffer for a normal
> operating case (which is pretty interrupt heavy).  What does this do to
> system responsiveness?

The normal operating case is not to define DEBUG.

Hmm, if CONFIG_DYNAMIC_DEBUG is enabled, it is a functional change.
Maybe the changes should be to pr_devel?

