Return-Path: <linux-kernel-owner+w=401wt.eu-S1757291AbZEPT3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757291AbZEPT3m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 15:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbZEPT3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 15:29:33 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:5738 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbZEPT3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 15:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=mdKSILULrOm7chlJKXTZSvRYl60Baf0cit78teA9r3Rp/uKKNab9Oj+NX7Rj+M+iAa
         2/2YodA5vTSvn1pHyvjJJITXbnRjJ6p2VdJF4n6nzNdqCT1uLg4VZYAGkncuB2nUN7IM
         cvE3FUEXo70qFVzlypCkJMtvps13o0SBgkA5I=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [git pull] IDE fixes
Date: Sat, 16 May 2009 21:33:45 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905162116.23690.bzolnier@gmail.com> <20090516192219.GA6202@liondog.tnic>
In-Reply-To: <20090516192219.GA6202@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905162133.46010.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 16 May 2009 21:22:19 Borislav Petkov wrote:
> Hi,
> 
> On Sat, May 16, 2009 at 09:16:23PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > 
> > ide-tape oops fix, icside regression fix and new piix cable quirk
> > 
> > Linus, please pull from 'for-linus' branch of:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/bart/ide-2.6.git for-linus
> > 
> > to receive the following updates:
> > 
> >  drivers/ide/icside.c   |    2 +-
> >  drivers/ide/ide-tape.c |    6 ------
> >  drivers/ide/piix.c     |    1 +
> >  3 files changed, 2 insertions(+), 7 deletions(-)
> > 
> > 
> > Alan Cox (1):
> >       piix: The Sony TZ90 needs the cable type hardcoding
> > 
> > Sergei Shtylyov (1):
> >       icside: register second channel of version 6 PCB
> > 
> > Tejun Heo (1):
> >       ide-tape: remove back-to-back REQUEST_SENSE detection
> 
> I assume it is too late to add another ide-tape debug build fix I told
> you about earlier today:

No its too early -- this patch doesn't even apply to Linus' tree.

[ It applies on top of all 2.6.31 block+ide changes... ]

> --
> From: Mark de Wever <koraq@xs4all.nl>
> Date: Sat, 16 May 2009 18:17:30 +0200
> Subject: [PATCH] ide-tape: fix debug call
> 
> This error only occurs when IDETAPE_DEBUG_LOG is enabled.
> 
> Signed-off-by: Mark de Wever <koraq@xs4all.nl>
> ---
>  drivers/ide/ide-tape.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 9ca2665..521a5f5 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -592,7 +592,7 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
>  	struct ide_cmd cmd;
>  	u8 stat;
>  
> -	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n"
> +	debug_log(DBG_SENSE, "sector: %llu, nr_sectors: %u\n",
>  		  (unsigned long long)blk_rq_pos(rq), blk_rq_sectors(rq));
>  
>  	if (!(blk_special_request(rq) || blk_sense_request(rq))) {
> -- 
> 1.6.3
> 
> If so, you could still queue it for 30-rc7 if there would be one...
> 
> Thanks.
