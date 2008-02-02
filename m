Return-Path: <linux-kernel-owner+w=401wt.eu-S935593AbYBCAC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935593AbYBCAC0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935722AbYBCAAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:00:18 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:55863 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935713AbYBCAAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:00:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=CCqNW0m8OBGwqXP7eKcM4gAzm9/uFJKH1KKLm0l2SxFJoAcDPuKOihDRdAikGBeUHmyUxCQrY27kDAKmHKcQcu4BEaGFdahYZRKqJUu/nS0gjn+SYQL6j00ZxhlYGnfP+pZBdJbFatrjndQ/hX7MIrps0/KcfRaxOhKRfSt/Bwo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 23/32] ide-tape: struct idetape_tape_t: shorten member names
Date: Sun, 3 Feb 2008 00:43:22 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <bbpetkov@yahoo.de>
References: <1201427300-3954-1-git-send-email-petkovbb@gmail.com> <1201427300-3954-18-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1201427300-3954-18-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802030043.23110.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 27 January 2008, Borislav Petkov wrote:
> From: Borislav Petkov <bbpetkov@yahoo.de>
> 
> Some member names are self-explanatory, so remove their respective
> comments. Also, explain the exact purpose of struct members in comments
> in the struct definition instead of using excessively long member names
> thus replacing then with a shorter, more handy version.
> 
> Finally, remove unused members:

Could you factor out dead code removal to a separate (pre-)patch?

> - last_frame_position: only being written to once
> - firmware_revision: used once, remove from struct idetape_tape_t and deal with
> it locally
> - firmware_revision_num: only written to once
> - tape_still_time_begin: completely unused
> - tape_still_time: never written to; remove corresponding code chunk
> - uncontrolled_last_pipeline_head: only once written to
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>
> ---
>  drivers/ide/ide-tape.c |  673 +++++++++++++++++++++++------------------------
>  1 files changed, 329 insertions(+), 344 deletions(-)

Even if this patch contains only trivial changes, the amount of them
and the fact that it intermixes different logical changes (shortening
names, dead code removal and comments beautification) makes it somehow
non-trivial to review.

General comment:
please have some mercy on the reviewer (in this case me ;) and spread
the changes across more patches (it should also be easier for you since
with more patches it is more likely that the more changes get applied
the first time and you will have less code to recast/resubmit).

> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
> index 4690f71..31edb0c 100644
> --- a/drivers/ide/ide-tape.c
> +++ b/drivers/ide/ide-tape.c
> @@ -240,9 +240,9 @@ typedef struct idetape_stage_s {
>  } idetape_stage_t;
>  
>  /*
> - *	Most of our global data which we need to save even as we leave the
> - *	driver due to an interrupt or a timer event is stored in a variable
> - *	of type idetape_tape_t, defined below.
> + * Most of our global data which we need to save even as we leave the driver due
> + * to an interrupt or a timer event is stored in a variable of type
> + * idetape_tape_t, defined below.

hmm, this comment looks ugly now because of an extra long first line...

[...]

>  	/* Next free packet command storage space */
> -	int pc_stack_index;
> +	int pc_stack_idx;
>  	struct request rq_stack[IDETAPE_PC_STACK];
>  	/* We implement a circular array */
> -	int rq_stack_index;
> +	int rq_stack_idx;

it is not worth doing it for the sake of two characters saved,
(especially when we take into the account that both variables are
 removed by patch #26)

[...]

>  	/* Current block */
> -	unsigned int first_frame_position;
> -	unsigned int last_frame_position;
> +	unsigned int first_frm_pos;

'first_frame' would be more appropriate

>  	unsigned int blocks_in_buffer;

this one is write-only, can be removed

[...]

> -	/* Current character device data transfer direction */
> -	idetape_chrdev_dir_t chrdev_direction;
> +	/* current chrdev data transfer direction */
> +	idetape_chrdev_dir_t chrdev_dir;

this change belongs to patch #21

> -	/*
> -	 *	Device information
> -	 */
> -	/* Usually 512 or 1024 bytes */
> -	unsigned short tape_block_size;
> +	/* tape block size, usually 512 or 1024 bytes */
> +	unsigned short blk_sz;

how's about blk_size?

[...]

> -	struct request *active_data_request;
> -	/* Data buffer size (chosen based on the tape's recommendation */
> +	/* active data request */
> +	struct request *act_data_rq;

active_data_rq?

> +	/* Data buffer size chosen based on the tape's recommendation */
>  	int stage_size;
>  	idetape_stage_t *merge_stage;
> -	int merge_stage_size;
> +	int merge_stage_sz;

not worth it

[...]

>  	/* The first stage which will be removed from the pipeline */
>  	idetape_stage_t *first_stage;
> -	/* The currently active stage */
>  	idetape_stage_t *active_stage;
> -	/* Will be serviced after the currently active request */

there is also 'first_stage' so the above comment seems valueable

>  	idetape_stage_t *next_stage;
>  	/* New requests will be added to the pipeline here */
>  	idetape_stage_t *last_stage;
> @@ -385,21 +366,16 @@ typedef struct ide_tape_obj {
>  	/* Status/Action flags: long for set_bit */
>  	unsigned long flags;
>  	/* protects the ide-tape queue */
> -	spinlock_t spinlock;
> +	spinlock_t que_lock;

'lock' or 'queue_lock' would be more appropriate

[...]

> @@ -426,49 +400,39 @@ typedef struct ide_tape_obj {
>  	int tape_head;
>  	int last_tape_head;
>  
> -	/*
> -	 * Speed control at the tape buffers input/output
> -	 */
> -	unsigned long insert_time;
> -	int insert_size;
> -	int insert_speed;
> -	int max_insert_speed;
> -	int measure_insert_time;
> +	/* Speed control at the tape buffers input/output */
> +	ulong ins_time;

please don't use uint and ulong typedefs

> +	int ins_size;
> +	int ins_speed;
> +	int max_ins_speed;
> +	/* measure insert time */
> +	int m_ins_time;

all of the above renames seem to be not worth it

the reason is that this change sets the number of people who understand (at
least partially) pipelined operation from to near to zero to a definitive zero

> +	/* Speed regulation negative feedback loop */
> +	int speed_ctl;
> +	/* pipeline head speed */
> +	int pipe_hspeed;
> +	/* controlled pipeline head speed */
> +	int pipe_ctl_hspeed;
> +	/* uncontrolled pipeline head speed */
> +	int unctl_pipe_hspeed;
> +	/* controlled last pipeline head */
> +	int ctl_last_pipe_h;
> +	/* uncontrolled pipeline head time */
> +	ulong unctl_pipe_htime;
> +	/* controlled pipeline head time */
> +	ulong ctl_pipe_htime;
> +	/* controlled previous pipeline head */
> +	int ctl_prev_pipe_h;
> +	/* uncontrolled previous pipeline head */
> +	int unctl_prev_pipe_h;
> +	/* controlled previous head time */
> +	ulong ctl_prev_htime;
> +	/* uncontrolled previous head time */
> +	ulong unctl_prev_htime;
> +	/* restart speed control req */
> +	int rs_speed_ctl_rq;

ditto

[...]

> @@ -1009,7 +973,8 @@ static int idetape_end_request(ide_drive_t *drive, int uptodate, int nr_sects)
>  			/*
>  			 * Insert the next request into the request queue.
>  			 */
> -			(void) ide_do_drive_cmd(drive, tape->active_data_request, ide_end);
> +			(void) ide_do_drive_cmd(drive, tape->act_data_rq,
> +					ide_end);

minor CodingStyle issue:

			(void)ide_do_drive_cmd(drive, tape->act_data_rq,
					       ide_end);

[...]

> -	if (tape->merge_stage_size) {
> -		actually_read = min((unsigned int)(tape->merge_stage_size), (unsigned int)count);
> +	if (tape->merge_stage_sz) {
> +		actually_read = min((uint)(tape->merge_stage_sz), (uint)count);

min_t(unsigned int, ..., ...)

[...]

> -				if (mt_count < tape->tape_block_size || mt_count % tape->tape_block_size)
> +				if (mt_count < tape->blk_sz ||
> +						mt_count % tape->blk_sz)

CodingStyle

				if (mt_count < tape->blk_sz ||
				    mt_count % tape->blk_sz)

[...]

> @@ -3289,7 +3268,9 @@ static int idetape_chrdev_ioctl (struct inode *inode, struct file *file, unsigne
>  			memset(&mtget, 0, sizeof (struct mtget));
>  			mtget.mt_type = MT_ISSCSI2;
>  			mtget.mt_blkno = position / tape->user_bs_factor - block_offset;
> -			mtget.mt_dsreg = ((tape->tape_block_size * tape->user_bs_factor) << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;
> +			mtget.mt_dsreg = ((tape->blk_sz * tape->user_bs_factor)
> +					<< MT_ST_BLKSIZE_SHIFT)
> +				& MT_ST_BLKSIZE_MASK;

CodingStyle

			mtget.mt_dsreg =
				((tape->blk_sz * tape->user_bs_factor)
				 << MT_ST_BLKSIZE_SHIFT) & MT_ST_BLKSIZE_MASK;

or some other better way...

[...]

> @@ -3520,9 +3502,9 @@ static int idetape_identify_device (ide_drive_t *drive)
>  
>  static void idetape_get_inquiry_results(ide_drive_t *drive)
>  {
> -	char *r;
>  	idetape_tape_t *tape = drive->driver_data;
>  	idetape_pc_t pc;
> +	char fw_rev[6];
>  
>  	idetape_create_inquiry_cmd(&pc);
>  	if (idetape_queue_pc_tail(drive, &pc)) {
> @@ -3532,18 +3514,15 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>  	}
>  	memcpy(tape->vendor_id, &pc.buffer[8], 8);
>  	memcpy(tape->product_id, &pc.buffer[16], 16);
> -	memcpy(tape->firmware_revision, &pc.buffer[32], 4);
> +	memcpy(fw_rev, &pc.buffer[32], 4);

'vendor_id' and 'product_id' can also be converted to local variables

[...]

> @@ -3718,14 +3701,16 @@ static void idetape_setup (ide_drive_t *drive, idetape_tape_t *tape, int minor)
>  	 *	Ensure that the number we got makes sense; limit
>  	 *	it within IDETAPE_DSC_RW_MIN and IDETAPE_DSC_RW_MAX.
>  	 */
> -	tape->best_dsc_rw_frequency = max_t(unsigned long, min_t(unsigned long, t, IDETAPE_DSC_RW_MAX), IDETAPE_DSC_RW_MIN);
> +	tape->best_dsc_rw_freq = max_t(ulong,
> +			min_t(ulong, t, IDETAPE_DSC_RW_MAX),
> +			IDETAPE_DSC_RW_MIN);

ulong -> unsigned long

Please recast/resubmit.

Thanks,
Bart
