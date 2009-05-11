Return-Path: <linux-kernel-owner+w=401wt.eu-S1756310AbZEKMFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbZEKMFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753053AbZEKMFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:05:05 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:37465 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZEKMFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=IfKPaomvvQKWTpvExpG1MywZCl/J0eTLYQBL3s3cmyVS1zRvl+p8AScUoDewGRtbnN
         PJmvoXtxZe1ylx3KeDeUZFJc9GL27gM98t3WBP4jy0woyStQl9ix6gQ2koKxOfUhbScG
         NbWiZyghYKcj9n1194GrHdjFR9GX9h0z1K4i8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: bp@kernel.org
Subject: Re: [PATCH 03/14] ide-atapi: switch to rq->resid_len
Date: Mon, 11 May 2009 13:22:59 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <200905102332.33022.bzolnier@gmail.com> <20090511072349.GA21045@liondog.tnic>
In-Reply-To: <20090511072349.GA21045@liondog.tnic>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905111322.59728.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 May 2009 09:23:49 Borislav Petkov wrote:
> On Sun, May 10, 2009 at 11:32:32PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > On Saturday 09 May 2009 09:45:23 Borislav Petkov wrote:
> > > Now that we have rq->resid_len, use it to account partial completion
> > > amount during the lifetime of an rq, decrementing it on each successful
> > > transfer. As a result, get rid of now unused pc->xferred.
> > > 
> > > While at it, remove noisy debug call in ide_prep_sense.
> > > 
> > > Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> > > ---
> > >  drivers/ide/ide-atapi.c |   17 ++++++++---------
> > >  drivers/ide/ide-tape.c  |   11 ++++-------
> > >  include/linux/ide.h     |    2 --
> > >  3 files changed, 12 insertions(+), 18 deletions(-)
> > 
> > WARNING: line over 80 characters
> > #118: FILE: drivers/ide/ide-tape.c:370:
> > +               int blocks = (blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
> 
> No worries, I haven't forgotten the checkpatch thing but the line is
> 81 chars and I just didn't want to split it because of _one_ char. The
> benefit of readability of having it on one line should be more important
> than one stupid static rule. I think we should relax it if enforcing it
> worsens readability...
> 
>                int blocks = (blk_rq_bytes(rq) - rq->resid_len) /
> 			     tape->blk_size;
> 
> Now this looks awful, IMHO. I'd much rather not listen to checkpatch
> here.

Please think outside of checkpatch.pl box, since 'blocks' shouldn't be 'int'
in the first place:

		unsigned int blocks =
			(blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
