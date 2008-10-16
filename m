Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYJPFaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYJPFaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 01:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYJPFaD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 01:30:03 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:55911 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbYJPFaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 01:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=Rua+D2skUH1rlJqn+Jn7sy7+b0Xer43PMN54Z2GNelzFBkfgy4MT85c+xGzL8iGt8I
         xL+TdcMpnAsUVngUfHKAfxs4qGKQkE8sIYROKmEnqGciU1gSYdAEoaD3XIPsMjhEs4wH
         xpjcjniUIT77MCwN4P9qZ9hdsbifDz5mazm2M=
Date: Thu, 16 Oct 2008 07:29:54 +0200
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-floppy: remove idefloppy_floppy_t typedef
Message-ID: <20081016052953.GA32756@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200810152136.48019.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810152136.48019.bzolnier@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 09:36:47PM +0200, Bartlomiej Zolnierkiewicz wrote:
> There should be no functional changes caused by this patch.
> 
> Cc: Borislav Petkov <petkovbb@googlemail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Borislav Petkov <petkovbb@gmail.com>

> ---
> against pata tree
> 
>  drivers/ide/ide-floppy.c       |   18 +++++++++---------
>  drivers/ide/ide-floppy.h       |    2 --
>  drivers/ide/ide-floppy_ioctl.c |    8 ++++----
>  3 files changed, 13 insertions(+), 15 deletions(-)
> 
> Index: b/drivers/ide/ide-floppy.c
> ===================================================================
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -70,7 +70,7 @@
>   */
>  static int ide_floppy_end_request(ide_drive_t *drive, int uptodate, int nsecs)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct request *rq = HWGROUP(drive)->rq;
>  	int error;
>  
> @@ -117,7 +117,7 @@ static void idefloppy_update_buffers(ide
>  
>  static void ide_floppy_callback(ide_drive_t *drive, int dsc)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct ide_atapi_pc *pc = drive->pc;
>  	int uptodate = pc->error ? 0 : 1;
>  
> @@ -154,7 +154,7 @@ static void ide_floppy_callback(ide_driv
>  	ide_floppy_end_request(drive, uptodate, 0);
>  }
>  
> -static void ide_floppy_report_error(idefloppy_floppy_t *floppy,
> +static void ide_floppy_report_error(struct ide_disk_obj *floppy,
>  				    struct ide_atapi_pc *pc)
>  {
>  	/* supress error messages resulting from Medium not present */
> @@ -173,7 +173,7 @@ static void ide_floppy_report_error(idef
>  static ide_startstop_t idefloppy_issue_pc(ide_drive_t *drive,
>  		struct ide_atapi_pc *pc)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  
>  	if (floppy->failed_pc == NULL &&
>  	    pc->c[0] != GPCMD_REQUEST_SENSE)
> @@ -237,7 +237,7 @@ static void idefloppy_create_rw_cmd(ide_
>  				    struct ide_atapi_pc *pc, struct request *rq,
>  				    unsigned long sector)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	int block = sector / floppy->bs_factor;
>  	int blocks = rq->nr_sectors / floppy->bs_factor;
>  	int cmd = rq_data_dir(rq);
> @@ -261,7 +261,7 @@ static void idefloppy_create_rw_cmd(ide_
>  	pc->flags |= PC_FLAG_DMA_OK;
>  }
>  
> -static void idefloppy_blockpc_cmd(idefloppy_floppy_t *floppy,
> +static void idefloppy_blockpc_cmd(struct ide_disk_obj *floppy,
>  		struct ide_atapi_pc *pc, struct request *rq)
>  {
>  	ide_init_pc(pc);
> @@ -283,7 +283,7 @@ static void idefloppy_blockpc_cmd(ideflo
>  static ide_startstop_t ide_floppy_do_request(ide_drive_t *drive,
>  					     struct request *rq, sector_t block)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	ide_hwif_t *hwif = drive->hwif;
>  	struct ide_atapi_pc *pc;
>  
> @@ -344,7 +344,7 @@ static ide_startstop_t ide_floppy_do_req
>   */
>  static int ide_floppy_get_flexible_disk_page(ide_drive_t *drive)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct gendisk *disk = floppy->disk;
>  	struct ide_atapi_pc pc;
>  	u8 *page;
> @@ -407,7 +407,7 @@ static int ide_floppy_get_flexible_disk_
>   */
>  static int ide_floppy_get_capacity(ide_drive_t *drive)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct gendisk *disk = floppy->disk;
>  	struct ide_atapi_pc pc;
>  	u8 *cap_desc;
> Index: b/drivers/ide/ide-floppy.h
> ===================================================================
> --- a/drivers/ide/ide-floppy.h
> +++ b/drivers/ide/ide-floppy.h
> @@ -4,8 +4,6 @@
>  #include "ide-gd.h"
>  
>  #ifdef CONFIG_IDE_GD_ATAPI
> -typedef struct ide_disk_obj idefloppy_floppy_t;
> -
>  /*
>   * Pages of the SELECT SENSE / MODE SENSE packet commands.
>   * See SFF-8070i spec.
> Index: b/drivers/ide/ide-floppy_ioctl.c
> ===================================================================
> --- a/drivers/ide/ide-floppy_ioctl.c
> +++ b/drivers/ide/ide-floppy_ioctl.c
> @@ -113,7 +113,7 @@ static void ide_floppy_create_format_uni
>  
>  static int ide_floppy_get_sfrp_bit(ide_drive_t *drive)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct ide_atapi_pc pc;
>  
>  	drive->atapi_flags &= ~IDE_AFLAG_SRFP;
> @@ -132,7 +132,7 @@ static int ide_floppy_get_sfrp_bit(ide_d
>  
>  static int ide_floppy_format_unit(ide_drive_t *drive, int __user *arg)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct ide_atapi_pc pc;
>  	int blocks, length, flags, err = 0;
>  
> @@ -190,7 +190,7 @@ out:
>  
>  static int ide_floppy_get_format_progress(ide_drive_t *drive, int __user *arg)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct ide_atapi_pc pc;
>  	int progress_indication = 0x10000;
>  
> @@ -226,7 +226,7 @@ static int ide_floppy_get_format_progres
>  static int ide_floppy_lockdoor(ide_drive_t *drive, struct ide_atapi_pc *pc,
>  			       unsigned long arg, unsigned int cmd)
>  {
> -	idefloppy_floppy_t *floppy = drive->driver_data;
> +	struct ide_disk_obj *floppy = drive->driver_data;
>  	struct gendisk *disk = floppy->disk;
>  	int prevent = (arg && cmd != CDROMEJECT) ? 1 : 0;
>  

-- 
Regards/Gruss,
    Boris.
