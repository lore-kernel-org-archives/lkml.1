Return-Path: <linux-kernel-owner+w=401wt.eu-S1759310AbYBEBQ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310AbYBEBQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:16:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbYBEBPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:15:24 -0500
Received: from nf-out-0910.google.com ([64.233.182.190]:51886 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458AbYBEBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=a+KT7vfYH+Jcj/I6WOXS+9K7S0V16Ltv4FGnkciy7LS8HrcTnbEn3kVzwoS25Fb9mmXqW33zJhHKqHRpdD1mVqDZ3si6aQ4ztlNVlfgM0jMJwElaSdb+5aHC1QJifOhvzFKE/MOPvqRhOhSB/PYQM377ZoWh9QSYhn206DQzfbY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 02/22] ide-tape: remove struct idetape_read_position_result_t
Date: Tue, 5 Feb 2008 02:23:17 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <1202132440-26648-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202132440-26648-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802050223.18087.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008, Borislav Petkov wrote:
> There should be no functional changes resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> ---
>  drivers/ide/ide-tape.c |   49 +++++++++++++++++------------------------------
>  1 files changed, 18 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 442d71c..c8c57ab 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c

[...]

>  	if (!tape->pc->error) {
> -		result = (idetape_read_position_result_t *) tape->pc->buffer;
> -		debug_log(DBG_SENSE, "BOP - %s\n", result->bop ? "Yes" : "No");
> -		debug_log(DBG_SENSE, "EOP - %s\n", result->eop ? "Yes" : "No");
> +		debug_log(DBG_SENSE, "BOP - %s\n",
> +				!!(readpos[0] & 0x80) ? "Yes" : "No");
> +		debug_log(DBG_SENSE, "EOP - %s\n",
> +				!!(readpos[0] & 0x40) ? "Yes" : "No");
> +
> +		if (!!(readpos[0] & 0x4)) {
> +			printk(KERN_INFO "ide-tape: Block location is unknown"
> +					"to the tape\n");

I removed needless "!!" while merging the patch.
