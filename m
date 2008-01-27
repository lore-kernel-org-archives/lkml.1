Return-Path: <linux-kernel-owner+w=401wt.eu-S1755021AbYA0Tdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbYA0Tdf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754755AbYA0TcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:9274 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236AbYA0TcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=hyTWzItNx+CXB2i9CzSUFdlfG/ds/YpxRC5AqqhS8+fL/jgeqQozCLRvIZ4F0nLMgHLOMZGbAbak3o63DR3LoOqDpLrYYKzPsllyLO8bujlCFnven6axBRZSUT/Cq649dk9Qq6t11qGTSYVVXX0V2NoSSGJ41ytvC4DFe8zsqjI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 4/32] ide-tape: remove struct idetape_mode_parameter_header_t
Date: Sun, 27 Jan 2008 16:25:07 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1201423312-2460-1-git-send-email-bbpetkov@yahoo.de> <1201423312-2460-5-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1201423312-2460-5-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801271625.08005.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

applied with some changes

> ---
>  drivers/ide/ide-tape.c |   40 +++++++++++++++-------------------------
>  1 files changed, 15 insertions(+), 25 deletions(-)

[...]

> @@ -3977,7 +3968,8 @@ static void idetape_get_mode_sense_results (ide_drive_t *drive)
>  	printk(KERN_INFO "ide-tape: Supports 32768 bytes block size / Restricted byte count for PIO transfers - %s\n",capabilities->blk32768 ? "Yes":"No");
>  	printk(KERN_INFO "ide-tape: Maximum supported speed in KBps - %d\n",capabilities->max_speed);
>  	printk(KERN_INFO "ide-tape: Continuous transfer limits in blocks - %d\n",capabilities->ctl);
> -	printk(KERN_INFO "ide-tape: Current speed in KBps - %d\n",capabilities->speed);	
> +	printk(KERN_INFO "ide-tape: Current speed in KBps - %d\n",
> +			capabilities->speed);
>  	printk(KERN_INFO "ide-tape: Buffer size - %d\n",capabilities->buffer_size*512);
>  #endif /* IDETAPE_DEBUG_INFO */
>  }

this code goes away in patch #5 so I dropped this chunk

[...]

> @@ -4003,10 +3994,9 @@ static void idetape_get_blocksize_from_block_descriptor(ide_drive_t *drive)
>  		}
>  		return;
>  	}
> -	header = (idetape_mode_parameter_header_t *) pc.buffer;
> -	block_descrp = (idetape_parameter_block_descriptor_t *) (pc.buffer + sizeof(idetape_mode_parameter_header_t));
> +	block_descrp = (idetape_parameter_block_descriptor_t *) pc.buffer + 4;

these brackets _are_ needed

[ block_descrp is of 'idetape_parameter_block_descriptor_t *' type so without
  brackets +4 would mean + 4 * sizeof(idetape_parameter_block_descriptor_t) ]
