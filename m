Return-Path: <linux-kernel-owner+w=401wt.eu-S1758929AbYA0Tet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758929AbYA0Tet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 14:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756550AbYA0Tc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 14:32:29 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:32949 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbYA0TcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 14:32:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=kiSDtX0xsLnxw7GmDLB1Whb0GBgy3JiRSMgCxGMG+eekgHashg+DB3SKkJYhmEGsEbl6ysaR3aVeZ5woNNWT2hf/5akq1feXnFuWEryAibjquSRKpk07Em/RwzIMFcXYfa5gBBXMolH/sh7MRcbaBLmqrMXOXrT6XmdZqBHa2Vo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 22/32] ide-tape: struct idetape_packet_command_s: shorten member names
Date: Sun, 27 Jan 2008 20:40:49 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-17-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-17-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801272040.49377.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |   88 ++++++++++++++++++++++++-----------------------
>  1 files changed, 45 insertions(+), 43 deletions(-)
> 
> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index b487d56..4690f71 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -193,24 +193,25 @@ struct idetape_bh {
>  	char *b_data;
>  };
>  
> -/*
> - *	Our view of a packet command.
> - */
>  typedef struct idetape_packet_command_s {
> -	u8 c[12];				/* Actual packet bytes */
> -	int retries;				/* On each retry, we increment retries */
> -	int error;				/* Error code */
> -	int request_transfer;			/* Bytes to transfer */
> -	int actually_transferred;		/* Bytes actually transferred */
> -	int buffer_size;			/* Size of our data buffer */
> +	u8 c[12];		/* Actual packet bytes */
> +	int retries;		/* On each retry, we increment retries */
> +	int error;		/* Error code */
> +	int rq_xfer;		/* Request bytes to transfer */
> +	int xferred;		/* Bytes actually transferred */
> +	int buf_size;		/* Size of our data buffer */
>  	struct idetape_bh *bh;
>  	char *b_data;
>  	int b_count;
> -	u8 *buffer;				/* Data buffer */
> -	u8 *current_position;			/* Pointer into the above buffer */
> -	ide_startstop_t (*callback) (ide_drive_t *);	/* Called when this packet command is completed */
> +	u8 *buffer;		/* Data buffer */
> +	u8 *cur_pos;		/* Pointer into the above buffer */
> +
> +	/* Called when this packet command is completed */
> +	ide_startstop_t (*callback) (ide_drive_t *);
>  	u8 pc_buffer[IDETAPE_PC_BUFFER_SIZE];	/* Temporary buffer */
> -	unsigned long flags;			/* Status/Action bit flags: long for set_bit */
> +
> +	/* Status/Action bit flags: long for set_bit */
> +	unsigned long flags;
>  } idetape_pc_t;

ide-{floppy,scsi} are using 'request_transfer', 'actually_transferred',
'buffer_size' and 'current_position' in their packet command structures.

We are going to unify ATAPI packet command handling for all ATAPI
device drivers and this patch is a change in the opposite direction.
(IOW I suggest to drop it until ATAPI handling gets unified). 

Thanks,
Bart
