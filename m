Return-Path: <linux-kernel-owner+w=401wt.eu-S1759200AbYBEBQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200AbYBEBQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 20:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbYBEBPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 20:15:21 -0500
Received: from mu-out-0910.google.com ([209.85.134.188]:16520 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbYBEBPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 20:15:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=lCcYFXI5vz5JWT+hvAVpdOyJ0dRbHHassSuiCgiiYw7/kNLzlg+5kYt21pnjho7gzejsJAZhUCNAV4T0LiK6WoIWTIt/BmpNzficaU4epuur71WqdV8GxI/XWzORyOvcwvMz8Zli2xy0CGaYoUOL/v1NApIG0hK539a9Ohma7QM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 14/22] ide-tape: cleanup and fix comments
Date: Tue, 5 Feb 2008 02:27:10 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com> <1202132440-26648-15-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1202132440-26648-15-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802050227.11033.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008, Borislav Petkov wrote:
> Also, remove redundant ones and cleanup whitespace.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

fixed few minor issues while merging the patch:

> ---
>  drivers/ide/ide-tape.c |  725 +++++++++++++++++++----------------------------
>  1 files changed, 293 insertions(+), 432 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 175d507..a80f8d9 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c

[...]

>  /*
> - *	DSC polling parameters.
> + * DSC polling parameters.
>   *
> - *	Polling for DSC (a single bit in the status register) is a very
> - *	important function in ide-tape. There are two cases in which we
> - *	poll for DSC:
> + * Polling for DSC (a single bit in the status register) is a very important
> + * function in ide-tape. There are two cases in which we poll for DSC:
>   *
> - *	1.	Before a read/write packet command, to ensure that we
> - *		can transfer data from/to the tape's data buffers, without
> - *		causing an actual media access. In case the tape is not
> - *		ready yet, we take out our request from the device
> - *		request queue, so that ide.c will service requests from
> - *		the other device on the same interface meanwhile.
>   *
> - *	2.	After the successful initialization of a "media access
> - *		packet command", which is a command which can take a long
> - *		time to complete (it can be several seconds or even an hour).
> + * 1. Before a read/write packet command, to ensure that we can transfer data
> + *    from/to the tape's data buffers, without causing an actual media access.
> + *    In case the tape is not ready yet, we take out our request from the device
> + *    request queue, so that ide.c could service requests from the other device
> + *    on the same interface in the meantime.
>   *
> - *		Again, we postpone our request in the middle to free the bus
> - *		for the other device. The polling frequency here should be
> - *		lower than the read/write frequency since those media access
> - *		commands are slow. We start from a "fast" frequency -
> - *		IDETAPE_DSC_MA_FAST (one second), and if we don't receive DSC
> - *		after IDETAPE_DSC_MA_THRESHOLD (5 minutes), we switch it to a
> - *		lower frequency - IDETAPE_DSC_MA_SLOW (1 minute).
> + * 2. After the successful initialization of a "media access packet command",
> + *    which is a command that can take a long time to complete (the interval can
> + *    range from several seconds to even an hour).
>   *
> - *	We also set a timeout for the timer, in case something goes wrong.
> - *	The timeout should be longer then the maximum execution time of a
> - *	tape operation.
> - */
> - 
> -/*
> - *	DSC timings.
> + * Again, we postpone our request in the middle to free the bus for the other
> + * device. The polling frequency here should be lower than the read/write
> + * frequency since those media access commands are slow. We start from a "fast"
> + * frequency - IDETAPE_DSC_MA_FAST (one second), and if we don't receive DSC
> + * after IDETAPE_DSC_MA_THRESHOLD (5 minutes), we switch it to a lower frequency
> + * - IDETAPE_DSC_MA_SLOW (1 minute). We also set a timeout for the timer, in

the above paragraph is true only for point 2.

[...]

> @@ -703,8 +654,8 @@ static void idetape_analyze_error(ide_drive_t *drive, u8 *sense)
>  	}
>  
>  	/*
> -	 * If error was the result of a zero-length read or write command,
> -	 * with sense key=5, asc=0x22, ascq=0, let it slide.  Some drives
> +	 * If error was the result of a zero-length read or write command, with
> +	 * sense key=5, asc=0x22, ascq=0, let it slide.  Some drives
>  	 * (i.e. Seagate STT3401A Travan) don't support 0-length read/writes.
>  	 */
>  	if ((pc->c[0] == READ_6 || pc->c[0] == WRITE_6)

[...]

> @@ -1070,25 +1012,24 @@ static ide_startstop_t idetape_pc_intr(ide_drive_t *drive)
>  	if (pc->flags & PC_FL_DMA_IN_PROGRESS) {
>  		if (hwif->ide_dma_end(drive) || (stat & ERR_STAT)) {
>  			/*
> -			 * A DMA error is sometimes expected. For example,
> -			 * if the tape is crossing a filemark during a
> -			 * READ command, it will issue an irq and position
> -			 * itself before the filemark, so that only a partial
> -			 * data transfer will occur (which causes the DMA
> -			 * error). In that case, we will later ask the tape
> -			 * how much bytes of the original request were
> -			 * actually transferred (we can't receive that
> -			 * information from the DMA engine on most chipsets).
> +			 * A DMA error is sometimes expected. For example, if
> +			 * the tape is crossing a filemark during a READ
> +			 * command, it will issue an irq and position itself
> +			 * before the filemark, so that only a partial data
> +			 * transfer will occur (which causes the DMA error). In
> +			 * that case, we will later ask the tape how much bytes
> +			 * of the original request were actually transferred (we
> +			 * can't receive that information from the DMA engine on
> +			 * most chipsets).
>  			 */
>  
>  			/*
> -			 * On the contrary, a DMA error is never expected;
> -			 * it usually indicates a hardware error or abort.
> -			 * If the tape crosses a filemark during a READ
> -			 * command, it will issue an irq and position itself
> -			 * after the filemark (not before). Only a partial
> -			 * data transfer will occur, but no DMA error.
> -			 * (AS, 19 Apr 2001)
> +			 * On the contrary, a DMA error is never expected; it
> +			 * usually indicates a hardware error or abort. If the
> +			 * tape crosses a filemark during a READ command, it
> +			 * will issue an irq and position itself after the
> +			 * filemark (not before). Only a partial data transfer
> +			 * will occur, but no DMA error. (AS, 19 Apr 2001)
>  			 */
>  			pc->flags |= PC_FL_DMA_ERROR;
>  		} else {

I dropped the above chunks (they don't seem to add any value)

[...]

> + * 3. ATAPI Tape media access commands have immediate status with a delayed
> + * process. In case of a successful initiation of a media access packet command,
> + * the DSC bit will be set when the actual execution of the command is finished.
> + * Since the tape drive will not issue an interrupt, we have to poll for this
> + * event. In this case, we define the request as "low priority request" by
> + * setting rq_status to	IDETAPE_RQ_POSTPONED, set a timer to poll for DSC and
> + * exit	the driver.

replaced tabs with spaces

[...]

> -	 * For SCSI this byte is defined as subpage instead of high byte
> -	 * of length and some IDE drives seem to interpret it this way
> -	 * and return an error when 255 is used.
> +	 * For SCSI this byte is defined as subpage instead of high byte of
> +	 * length and some IDE drives seem to interpret it this way and return
> +	 * an error when 255 is used.

this change was also dropped

[...]

> -	 * If the tape is still busy, postpone our request and service
> -	 * the other device meanwhile.
> +	 * If the tape is still busy, postpone our request and service the other
> +	 * device meanwhile.

same here

[...]

>  /*
> - *	ide_setup is called to:
> + * The function below is called to:
>   *
> - *		1.	Initialize our various state variables.
> - *		2.	Ask the tape for its capabilities.
> - *		3.	Allocate a buffer which will be used for data
> - *			transfer. The buffer size is chosen based on
> - *			the recommendation which we received in step (2).
> - *
> - *	Note that at this point ide.c already assigned us an irq, so that
> - *	we can queue requests here and wait for their completion.
> + * 1. Initialize our various state variables.
> + * 2. Ask the tape for its capabilities.
> + * 3. Allocate a buffer which will be used for data transfer. The buffer size is
> + * chosen based on the recommendation which we received in step 2. Note that at

"Note" is for the whole comment not only step 3.

> + * this point ide.c already assigned us an irq, so that we can queue requests
> + * here and wait for their completion.
>   */
