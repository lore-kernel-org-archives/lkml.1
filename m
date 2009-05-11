Return-Path: <linux-kernel-owner+w=401wt.eu-S1753875AbZEKHYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbZEKHYL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752329AbZEKHXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:23:55 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61727 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbZEKHXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:23:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :references:mime-version:content-type:content-disposition
         :in-reply-to:user-agent;
        b=UarPNOUcvm7T1skkIFG6yAdXvOxamNo7X6/f9Mud+3Evw3vMo7CV+DKhOtaL3mgpeI
         9WlC5kY1pen0oyCZ2V3wi/pEleI8dmETMaTsjrsVmm1tmj2CbmsvVQsBl47LAv5ulkZ8
         a8PkaH+xE63eBPJ7QPagpON9V8EI3nr/6qde4=
Date: Mon, 11 May 2009 09:23:49 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/14] ide-atapi: switch to rq->resid_len
Message-ID: <20090511072349.GA21045@liondog.tnic>
Reply-To: bp@kernel.org
Mail-Followup-To: bp@kernel.org,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Borislav Petkov <petkovbb@googlemail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-4-git-send-email-petkovbb@gmail.com> <200905102332.33022.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200905102332.33022.bzolnier@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 10, 2009 at 11:32:32PM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Saturday 09 May 2009 09:45:23 Borislav Petkov wrote:
> > Now that we have rq->resid_len, use it to account partial completion
> > amount during the lifetime of an rq, decrementing it on each successful
> > transfer. As a result, get rid of now unused pc->xferred.
> > 
> > While at it, remove noisy debug call in ide_prep_sense.
> > 
> > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > ---
> >  drivers/ide/ide-atapi.c |   17 ++++++++---------
> >  drivers/ide/ide-tape.c  |   11 ++++-------
> >  include/linux/ide.h     |    2 --
> >  3 files changed, 12 insertions(+), 18 deletions(-)
> 
> WARNING: line over 80 characters
> #118: FILE: drivers/ide/ide-tape.c:370:
> +               int blocks = (blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;

No worries, I haven't forgotten the checkpatch thing but the line is
81 chars and I just didn't want to split it because of _one_ char. The
benefit of readability of having it on one line should be more important
than one stupid static rule. I think we should relax it if enforcing it
worsens readability...

               int blocks = (blk_rq_bytes(rq) - rq->resid_len) /
			     tape->blk_size;

Now this looks awful, IMHO. I'd much rather not listen to checkpatch
here.

-- 
Regards/Gruss,
    Boris.
