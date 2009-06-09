Return-Path: <linux-kernel-owner+w=401wt.eu-S1758792AbZFIH5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792AbZFIH5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZFIH5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:57:09 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:52821 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752295AbZFIH5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:57:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=cLxwe+TKeflokOSfT17G5l+yC9VuANiMvh3GkqJcgJiOQyA8UR2y2ijgwkLWQmFm5S
         Nr01ITiRk++lHRGuQWBbI1Icqbw9c4LTQS5SPpKV0LF5wydsU7i60EiRvMBiUvexdJ4u
         kRbRvCDjNo3aQLy9fg7fwPuiVhF2pgJEoCsGI=
Date: Tue, 9 Jun 2009 09:57:06 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Mark de Wever <koraq@xs4all.nl>
Subject: Re: linux-next: manual merge of the block tree with the ide tree
Message-ID: <20090609075706.GA6878@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Jens Axboe <jens.axboe@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Borislav Petkov <petkovbb@googlemail.com>,
	Mark de Wever <koraq@xs4all.nl>
References: <20090609163405.69795630.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090609163405.69795630.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 09, 2009 at 04:34:05PM +1000, Stephen Rothwell wrote:
> Hi Jens,
> 
> Today's linux-next merge of the block tree got a conflict in
> drivers/ide/ide-tape.c between various commits from the ide tree and
> various commits from the block tree.
> 
> I fixed it up as best I could (see below).

Yep, looks good. Thanks.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc drivers/ide/ide-tape.c
> index 51ea59e,683ff37..0000000
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@@ -610,8 -617,8 +628,8 @@@ static ide_startstop_t idetape_do_reque
>   	struct ide_cmd cmd;
>   	u8 stat;
>   
> - 	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %lu\n",
> - 		  (unsigned long long)rq->sector, rq->nr_sectors);
>  -	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n"
> ++	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n",
> + 		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
>   
>   	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
>   		/* We do not support buffer cache originated requests. */



-- 
Regards/Gruss,
    Boris.
