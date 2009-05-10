Return-Path: <linux-kernel-owner+w=401wt.eu-S1756884AbZEJVgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884AbZEJVgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 17:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756684AbZEJVgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 17:36:06 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:44286 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbZEJVgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 17:36:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=DATwh5OEAGgtyuNPPbq2MphlBAX2SpBMZFvI3vuvgYZk8R60UlTQ64JAMaJgDaEYuU
         lmD50vcap1DwcNfN2SnzCjdmqUCo5sxL2QBBCD40k+c8xf9ahwn3ZjLufP5UI4dAoUaU
         c7OAcsPXvizjSOK/arCPgtpa2vdwoNhPJ55vE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 03/14] ide-atapi: switch to rq->resid_len
Date: Sun, 10 May 2009 23:32:32 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc3-00442-ga3668b0; KDE/4.2.2; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1241855134-4984-1-git-send-email-petkovbb@gmail.com> <1241855134-4984-4-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1241855134-4984-4-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905102332.33022.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 May 2009 09:45:23 Borislav Petkov wrote:
> Now that we have rq->resid_len, use it to account partial completion
> amount during the lifetime of an rq, decrementing it on each successful
> transfer. As a result, get rid of now unused pc->xferred.
> 
> While at it, remove noisy debug call in ide_prep_sense.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-atapi.c |   17 ++++++++---------
>  drivers/ide/ide-tape.c  |   11 ++++-------
>  include/linux/ide.h     |    2 --
>  3 files changed, 12 insertions(+), 18 deletions(-)

WARNING: line over 80 characters
#118: FILE: drivers/ide/ide-tape.c:370:
+               int blocks = (blk_rq_bytes(rq) - rq->resid_len) / tape->blk_size;
