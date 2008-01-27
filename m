Return-Path: <linux-kernel-owner+w=401wt.eu-S1759856AbYA0TgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759856AbYA0TgF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756857AbYA0Tcf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:8690 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496AbYA0Tc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=vgkZg719rBNi9jOPELQVBxNh9FxrDmfBrz0WEHXHHz6yaXQYcfSf9FO8UoauCahfl7mix4ax86BKlVZ3vVsXYtheQ1137qbwVRlz/qjpwkionkcs9847TjL40lVnH7joxGdMLUTjI30yhFyxQZD0D8dGke2QcHyYThkKKWNubD0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 10/32] ide-tape: remove struct idetape_read_position_result_t
Date: Sun, 27 Jan 2008 20:43:12 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-5-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-5-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801272043.12270.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> There should be no functional changes resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |   49 +++++++++++++++++------------------------------
>  1 files changed, 18 insertions(+), 31 deletions(-)

[...]
  
> -static ide_startstop_t idetape_read_position_callback (ide_drive_t *drive)
> +static ide_startstop_t idetape_read_position_callback(ide_drive_t *drive)
>  {
>  	idetape_tape_t *tape = drive->driver_data;
> -	idetape_read_position_result_t *result;
> +	u8 *readpos = tape->pc->buffer;
>  
>  	debug_log(DBG_PROCS, "Enter %s\n", __func__);
>  
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

all "!!" above are unnecessary

Otherwise is fine but depends on patch #7 so I couldn't merge it
(please move this patch near the beginning of the series).

Thanks,
Bart
