Return-Path: <linux-kernel-owner+w=401wt.eu-S1763386AbZD1R0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763386AbZD1R0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 13:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbZD1R0K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 13:26:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:54279 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759590AbZD1R0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 13:26:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=wJ9f2js87fMcvsoH6q0ONqjHuDBRI+T1JAa3NoQk/mKgixf13O+4s73OdFx51AP6Ki
         xSQx4GkVl9EsEuR7nZ0DFvUyUys6VJf6Q40j+oGoS6sN09X3+RvKdPo4gJMnUMvfV8r1
         M/h8w+2gD9mvcsUY1KUCK+HNZkTpfRT1xH6gk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH 2/3] mg_disk: fix CONFIG_LBD=y warning
Date: Tue, 28 Apr 2009 17:28:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.29-next-20090403; KDE/4.2.2; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
       donari75@gmail.com, linux-ide@vger.kernel.org, alan@lxorguk.ukuu.org.uk
References: <1240890740-3462-1-git-send-email-tj@kernel.org> <1240890740-3462-3-git-send-email-tj@kernel.org> <49F71E86.7040300@rtr.ca>
In-Reply-To: <49F71E86.7040300@rtr.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904281728.58209.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 April 2009 17:19:34 Mark Lord wrote:
> Tejun Heo wrote:
> > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > 
> > drivers/block/mg_disk.c: In function ‘mg_dump_status’:
> > drivers/block/mg_disk.c:265: warning: format ‘%ld’ expects type ‘long int’, but
> > argument 2 has type ‘sector_t’
> > 
> > [ Impact: kill build warning ]
> > 
> > Cc: unsik Kim <donari75@gmail.com>
> > Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > ---
> >  drivers/block/mg_disk.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
> > index d3e72ad..f389835 100644
> > --- a/drivers/block/mg_disk.c
> > +++ b/drivers/block/mg_disk.c
> > @@ -79,7 +79,7 @@ static void mg_dump_status(const char *msg, unsigned int stat,
> >  			if (host->breq) {
> >  				req = elv_next_request(host->breq);
> >  				if (req)
> > -					printk(", sector=%ld", req->sector);
> > +					printk(", sector=%u", (u32)req->sector);
> ..
> 
> Eh?  Shouldn't that be fixed the other way around, like this:
> 
>   +					printk(", sector=%llu", (u64)req->sector);
> 
> This way, it will still give correct data when sector_t is a u64.

shouldn't matter, req->sector is never > u32 for mg_disk
