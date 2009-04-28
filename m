Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZD1SXv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZD1SXv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:23:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZD1SXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:23:40 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:37177 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbZD1SXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:23:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=iOdCIH81jvXBvjiMiLe6oZnd9YY1LsqUSpyROReRwAlpL1c/gCGdj7wXOw7LHdZCdB
         GXDyYiJKuVsNqh6lTg3G1A8/lZu2dr6HfBLHZGqquhk+DORaO5ikw2QZxfoivsPxljk3
         CTDSRp0RU50XfxfLxT2NZOyxEqj472yBdOzRI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 2/3] mg_disk: fix CONFIG_LBD=y warning
Date: Tue, 28 Apr 2009 20:28:11 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Mark Lord <liml@rtr.ca>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
       linux-kernel@vger.kernel.org, donari75@gmail.com,
       linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
References: <1240890740-3462-1-git-send-email-tj@kernel.org> <200904281728.58209.bzolnier@gmail.com> <49F74672.2090407@garzik.org>
In-Reply-To: <49F74672.2090407@garzik.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904282028.12047.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009 20:09:54 Jeff Garzik wrote:
> Bartlomiej Zolnierkiewicz wrote:
> > On Tuesday 28 April 2009 17:19:34 Mark Lord wrote:
> >> Tejun Heo wrote:
> >>> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>>
> >>> drivers/block/mg_disk.c: In function ‘mg_dump_status’:
> >>> drivers/block/mg_disk.c:265: warning: format ‘%ld’ expects type ‘long int’, but
> >>> argument 2 has type ‘sector_t’
> >>>
> >>> [ Impact: kill build warning ]
> >>>
> >>> Cc: unsik Kim <donari75@gmail.com>
> >>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> >>> Signed-off-by: Tejun Heo <tj@kernel.org>
> >>> ---
> >>>  drivers/block/mg_disk.c |    2 +-
> >>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
> >>> index d3e72ad..f389835 100644
> >>> --- a/drivers/block/mg_disk.c
> >>> +++ b/drivers/block/mg_disk.c
> >>> @@ -79,7 +79,7 @@ static void mg_dump_status(const char *msg, unsigned int stat,
> >>>  			if (host->breq) {
> >>>  				req = elv_next_request(host->breq);
> >>>  				if (req)
> >>> -					printk(", sector=%ld", req->sector);
> >>> +					printk(", sector=%u", (u32)req->sector);
> >> ..
> >>
> >> Eh?  Shouldn't that be fixed the other way around, like this:
> >>
> >>   +					printk(", sector=%llu", (u64)req->sector);
> >>
> >> This way, it will still give correct data when sector_t is a u64.
> > 
> > shouldn't matter, req->sector is never > u32 for mg_disk
> 
> It never matters... until the code gets copied elsewhere.  IMO wrong 
> code should never be kept -- "impossible to hit" just means it is low 
> priority :)

Well, if you feel strongly about it feel free to replace my patch with
your improved version.  You may also fix hd.c (from which the above code
has been copied) while at it.
