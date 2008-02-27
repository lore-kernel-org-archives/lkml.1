Return-Path: <linux-kernel-owner+w=401wt.eu-S1759037AbYB0Wr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbYB0Wr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:47:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbYB0WrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:47:13 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:46054 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbYB0WrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:47:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=t3hblQ9VgiwBCsaVgxb+iWaGF38y2p3V61bDa9+GBrJohlCjkJIyODYtsh+j+W1tQn6hPKZL8shKPhEvpQfq/KtNzYvQrLnSx6TXnkWWBz2iTCDpaS/KQjfAJ0f8808U0PBhV8kOQqr5oNGVwbhbWhUDdaI99pql+dCfpTyH64Q=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: petkovbb@gmail.com
Subject: Re: [PATCH 4/5] ide-cd: shorten lines longer than 80 columns
Date: Thu, 28 Feb 2008 00:01:43 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1204136449-9490-1-git-send-email-petkovbb@gmail.com> <200802272218.50537.bzolnier@gmail.com> <20080227221532.GB9545@gollum.tnic>
In-Reply-To: <20080227221532.GB9545@gollum.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802280001.43316.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 February 2008, Borislav Petkov wrote:
> On Wed, Feb 27, 2008 at 10:18:50PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > On Wednesday 27 February 2008, Borislav Petkov wrote:
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > 
> > interdiff for the merged version
> > 

[...]

> > diff -u b/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> > --- b/drivers/ide/ide-cd.c
> > +++ b/drivers/ide/ide-cd.c
> > @@ -510,7 +510,7 @@
> >  	default:
> >  		if (!(rq->cmd_flags & REQ_QUIET))
> >  			printk(KERN_INFO "ide-cd: cmd 0x%x timed out\n",
> > -				rq->cmd[0]);
> > +					 rq->cmd[0]);
> 
> why do you push the rq->cmd[0] thingy back here. Shouldn't it be aligned
> with the opening brace as the zillion others so far?

IDE is quite consistent with the above style but maybe it is just me being
used to it.  I could revert this change if you feel strong about it...

> > @@ -819,8 +819,8 @@
> >  static void restore_request(struct request *rq)
> >  {
> >  	if (rq->buffer != bio_data(rq->bio)) {
> > -		sector_t n = (rq->buffer - (char *) bio_data(rq->bio)) /
> > -				SECTOR_SIZE;
> > +		sector_t n =
> > +			(rq->buffer - (char *)bio_data(rq->bio)) / SECTOR_SIZE;
> 
> i must say, lines like this one always look ugly, no matter the formatting
> tricks.

For this case there is a simple solution: fix ide-cd to use hwif->sg_table
instead of having it to walk rq->bio's and the whole function will vanish. ;-)

[ IOW We are putting way too much time into these coding style fixes and as
  the old code is replaced with the new one the coding style improves itself. ]

Thanks,
Bart
