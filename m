Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbXFOX1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbXFOX1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 19:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbXFOX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 19:26:53 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:63885 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbXFOX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 19:26:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=puRAc8GBfnnr0o0RCZ2wv8pM04tT7Lxz6++D5Ld6pPYQE0C+LZhJYIlqLejFSYJMjHlzvr7hhP/tqjaELT2SdeCPVoDw1aZBYM0O8FXyRIfmF62562nnNVS8/zGXNYu/qpd3B3LnjcQ3cMzr6z3KN8CBdiOiLlHdudK6VV3xVbI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Masatake YAMATO <jet@gyve.org>
Subject: Re: [PATCH] never called printk statement in ide-taskfile.c::wait_drive_not_busy
Date: Sat, 16 Jun 2007 00:45:36 +0200
User-Agent: KMail/1.9.6
Cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
References: <20070605.112124.28713903.jet@gyve.org> <4665988A.5060902@redhat.com> <20070606.023558.230059723.jet@gyve.org>
In-Reply-To: <20070606.023558.230059723.jet@gyve.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706160045.36638.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Tuesday 05 June 2007, Masatake YAMATO wrote:
> > On 06/04/2007 10:21 PM, Masatake YAMATO wrote:
> > > diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
> > > index 30175c7..5e05311 100644
> > > --- a/drivers/ide/ide-taskfile.c
> > > +++ b/drivers/ide/ide-taskfile.c
> > > @@ -249,7 +249,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
> > >  	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
> > >  		udelay(10);
> > >  
> > > -	if (!retries)
> > > +	if (retries < 0)
> > 
> > 	if (stat & BUSY_STAT)
> > 
> > >  		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
> > >  
> 
> Oh, yes.
> Giving `retries' both roles: loop counter and condition flag for logging
> may not good.
> 
> 
>     for (retries = 0; retries < 100; retries++)
>     {
> 	    if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT)
> 	       break;
> 
> 	    udelay(10);
>     }
> 
> 
>     if (stat & BUSY_STAT)
> 	    printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);

Please re-submit this fix in the form of a patch so I can merge it.

Thanks,
Bart
