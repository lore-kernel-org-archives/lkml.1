Return-Path: <linux-kernel-owner+w=401wt.eu-S1755670AbYBEEr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670AbYBEEr2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 23:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753203AbYBEErU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 23:47:20 -0500
Received: from fk-out-0910.google.com ([209.85.128.188]:19928 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYBEErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 23:47:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=EiS4WuWeeB8iZadya09cKg0diLRbq34NKjSI7QfuyELrALgtPDB00GHIj7z6ZEwQftK/oP2cLLIgnJ3OypsJTPw2c4GVsQ98fluVbHpnJzLQBA8twUQVjHOUwVYZFs2jhTnbTujLy83ytSFxuhoC/gQ7KS7OFBNJPV9G7PgKtO0=
Date: Tue, 5 Feb 2008 05:47:07 +0100
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 07/22] ide-tape: struct idetape_tape_t: shorten member
	names v2
Message-ID: <20080205044707.GA29807@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <1202132440-26648-8-git-send-email-petkovbb@gmail.com> <200802050223.21176.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200802050223.21176.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 05, 2008 at 02:23:21AM +0100, Bartlomiej Zolnierkiewicz wrote:
> On Monday 04 February 2008, Borislav Petkov wrote:
> > Shorten some member names not too aggressively since this driver might be gone
> > anyway soon.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-tape.c |  210 ++++++++++++++++++++++++++----------------------
> >  1 files changed, 113 insertions(+), 97 deletions(-)
> > 
> > diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> > index 126e8a9..0b5ccce 100644
> > --- a/drivers/ide/ide-tape.c
> > +++ b/drivers/ide/ide-tape.c
> 
> [...]
> 
> > @@ -1583,7 +1579,8 @@ static void idetape_create_read_cmd(idetape_tape_t *tape, idetape_pc_t *pc, unsi
> >  	pc->bh = bh;
> >  	atomic_set(&bh->b_count, 0);
> >  	pc->buffer = NULL;
> > -	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
> > +	pc->buffer_size		= length * tape->blk_size;
> > +	pc->request_transfer	= length * tape->blk_size;
> >  	if (pc->request_transfer == tape->stage_size)
> >  		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
> >  }
> > @@ -1621,7 +1618,8 @@ static void idetape_create_write_cmd(idetape_tape_t *tape, idetape_pc_t *pc, uns
> >  	pc->b_data = bh->b_data;
> >  	pc->b_count = atomic_read(&bh->b_count);
> >  	pc->buffer = NULL;
> > -	pc->request_transfer = pc->buffer_size = length * tape->tape_block_size;
> > +	pc->request_transfer	= length * tape->blk_size;
> > +	pc->buffer_size		= length * tape->blk_size;
> >  	if (pc->request_transfer == tape->stage_size)
> >  		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
> >  }
> 
> for some reason gcc doesn't seem to optimize the new code as well as
> the old one (=> driver size goes up instead of staying unchanged)
> 
> interdiff between original patch and merged version:
> 
> diff -u b/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> --- b/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -324,7 +324,7 @@
>  	/* Current character device data transfer direction */
>  	u8 chrdev_dir;
>  
> -	/* tape block size, usu. 512 or 1024 bytes */
> +	/* tape block size, usually 512 or 1024 bytes */
>  	unsigned short blk_size;
>  	int user_bs_factor;
>  
> @@ -1580,8 +1580,8 @@
>  	pc->bh = bh;
>  	atomic_set(&bh->b_count, 0);
>  	pc->buffer = NULL;
> -	pc->buffer_size		= length * tape->blk_size;
> -	pc->request_transfer	= length * tape->blk_size;
> +	pc->buffer_size = length * tape->blk_size;
> +	pc->request_transfer = pc->buffer_size;
>  	if (pc->request_transfer == tape->stage_size)
>  		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
>  }
> @@ -1619,8 +1619,8 @@
>  	pc->b_data = bh->b_data;
>  	pc->b_count = atomic_read(&bh->b_count);
>  	pc->buffer = NULL;
> -	pc->request_transfer	= length * tape->blk_size;
> -	pc->buffer_size		= length * tape->blk_size;
> +	pc->buffer_size = length * tape->blk_size;
> +	pc->request_transfer = pc->buffer_size;
>  	if (pc->request_transfer == tape->stage_size)
>  		set_bit(PC_DMA_RECOMMENDED, &pc->flags);
>  }

Yeah, i did that only because checkpatch.pl complained that multiple assignments
should be avoided. Now it looks kinda dumb that way besides improving readability
so converting it to the best form w.r.t generating smaller binary would be a reason
good enough to ignore checkpatch.pl in that case.

-- 
Regards/Gruﬂ,
    Boris.
