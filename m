Return-Path: <linux-kernel-owner+w=401wt.eu-S1764846AbXFERvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764846AbXFERvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 13:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755272AbXFERvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 13:51:13 -0400
Received: from mfo10.iij4u.or.jp ([210.138.174.80]:49826 "EHLO
	mfo10.iij4u.or.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754216AbXFERvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 13:51:12 -0400
X-Greylist: delayed 381 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2007 13:51:12 EDT
Date: Wed, 06 Jun 2007 02:35:58 +0900 (JST)
Message-Id: <20070606.023558.230059723.jet@gyve.org>
To: cebbert@redhat.com
Cc: B.Zolnierkiewicz@elka.pw.edu.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] never called printk statement in
 ide-taskfile.c::wait_drive_not_busy
From: Masatake YAMATO <jet@gyve.org>
In-Reply-To: <4665988A.5060902@redhat.com>
References: <20070605.112124.28713903.jet@gyve.org>
	<4665988A.5060902@redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.0.98 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/04/2007 10:21 PM, Masatake YAMATO wrote:
> > diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
> > index 30175c7..5e05311 100644
> > --- a/drivers/ide/ide-taskfile.c
> > +++ b/drivers/ide/ide-taskfile.c
> > @@ -249,7 +249,7 @@ static u8 wait_drive_not_busy(ide_drive_t *drive)
> >  	while (((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT) && retries--)
> >  		udelay(10);
> >  
> > -	if (!retries)
> > +	if (retries < 0)
> 
> 	if (stat & BUSY_STAT)
> 
> >  		printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);
> >  

Oh, yes.
Giving `retries' both roles: loop counter and condition flag for logging
may not good.


    for (retries = 0; retries < 100; retries++)
    {
	    if ((stat = hwif->INB(IDE_STATUS_REG)) & BUSY_STAT)
	       break;

	    udelay(10);
    }


    if (stat & BUSY_STAT)
	    printk(KERN_ERR "%s: drive still BUSY!\n", drive->name);

Masatake YAMATO
