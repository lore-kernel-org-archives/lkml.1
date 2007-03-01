Return-Path: <linux-kernel-owner+w=401wt.eu-S965490AbXCASxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965490AbXCASxj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 13:53:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965505AbXCASxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 13:53:39 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:10907 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490AbXCASxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 13:53:38 -0500
Date: Thu, 1 Mar 2007 10:49:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Thomas Davies" <daviesth@onid.orst.edu>
Cc: kernel-janitors@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix warnings that occur on make *docs
Message-Id: <20070301104938.8674ca7b.randy.dunlap@oracle.com>
In-Reply-To: <953c67830703011039x53a28509v3af6dddabffbca9f@mail.gmail.com>
References: <953c67830703011039x53a28509v3af6dddabffbca9f@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Mar 2007 10:39:41 -0800 Thomas Davies wrote:

> From: Thomas Davies <daviesth@onid.orst.edu>
> 
> Cleaned up comments and whitespace in /drivers/message/fusion/*.c and also
> /lib/bitmap.c to remove make *docs warnings.  An attempt by a newbie
> to contribute
> in some small way to the codebase.  Did I do it right?

Hi,

Your patch looks fine (until I tested it), but I have already
corrected these warnings.  The patches have been in the -mm patchset
for awhile and Andrew has sent some of it to Linus to be merged.
Other parts need to go thru other maintainers.


> Signed-off-by: Thomas Davies <daviesth@onid.orst.edu>
> ---
> diff -uprN -X linux-2.6/Documentation/dontdiff
> linux-2.6/drivers/message/fusion/mptbase.c
> linux-2.6-new/drivers/message/fusion/mptbase.c

Looks like your mail client split these lines (above and below)
so that 'patch' cannot apply the patch.
lkml.org shows the same splitting, so I guess it's not my
mail client on the reading end that is doing this.


> --- linux-2.6/drivers/message/fusion/mptbase.c	2007-02-27
> 21:46:49.000000000 -0800
> +++ linux-2.6-new/drivers/message/fusion/mptbase.c	2007-02-28
> 23:03:26.000000000 -0800
> @@ -4743,7 +4743,7 @@ mpt_readScsiDevicePageHeaders(MPT_ADAPTE
>   *
>   * This clears this link list.
>   *
> - * @ioc - pointer to per adapter structure
> + * @ioc: pointer to per adapter structure
>   *
>   **/
>  static void
> @@ -4768,9 +4768,9 @@ mpt_inactive_raid_list_free(MPT_ADAPTER
>   *
>   * This sets up link list of phy_disk_nums for devices belonging in
> an inactive volume
>   *
> - * @ioc - pointer to per adapter structure
> - * @channel - volume channel
> - * @id - volume target id
> + * @ioc: pointer to per adapter structure
> + * @channel: volume channel
> + * @id: volume target id
>   *
>   *
>   **/
> @@ -4782,7 +4782,7 @@ mpt_inactive_raid_volumes(MPT_ADAPTER *i
>  	dma_addr_t			dma_handle;
>  	pRaidVolumePage0_t		buffer = NULL;
>  	int				i;
> -	RaidPhysDiskPage0_t 		phys_disk;
> +	RaidPhysDiskPage0_t		phys_disk;
>  	struct inactive_raid_component_info *component_info;
>  	int				handle_inactive_volumes;
> 
> @@ -6663,7 +6663,7 @@ union loginfo_type {
>  /**
>   *	mpt_iocstatus_info_config - IOCSTATUS information for config pages
>   *	@ioc: Pointer to MPT_ADAPTER structure
> - *	ioc_status: U32 IOCStatus word from IOC
> + *	@ioc_status: U32 IOCStatus word from IOC
>   *	@mf: Pointer to MPT request frame
>   *
>   *	Refer to lsi/mpi.h.
> diff -uprN -X linux-2.6/Documentation/dontdiff
> linux-2.6/drivers/message/fusion/mptscsih.c
> linux-2.6-new/drivers/message/fusion/mptscsih.c
> --- linux-2.6/drivers/message/fusion/mptscsih.c	2007-02-27
> 21:46:49.000000000 -0800
> +++ linux-2.6-new/drivers/message/fusion/mptscsih.c	2007-02-28
> 23:03:26.000000000 -0800
> @@ -1540,11 +1540,13 @@ mptscsih_freeChainBuffers(MPT_ADAPTER *i
>   *	Fall through to mpt_HardResetHandler if: not operational, too many
>   *	failed TM requests or handshake failure.
>   *
> - *	@ioc: Pointer to MPT_ADAPTER structure
> + *	@hd: Pointer to MPT_SCSI_HOST structure
>   *	@type: Task Management type
> + *	@channel: Logical bus number of the device
>   *	@id: Logical Target ID for reset (if appropriate)
>   *	@lun: Logical Unit for reset (if appropriate)
>   *	@ctx2abort: Context for the task to be aborted (if appropriate)
> + *	@timeout: Time to wait in seconds before giving up
>   *
>   *	Remark: Currently invoked from a non-interrupt thread (_bh).
>   *
> @@ -1650,9 +1652,11 @@ mptscsih_TMHandler(MPT_SCSI_HOST *hd, u8
>   *	mptscsih_IssueTaskMgmt - Generic send Task Management function.
>   *	@hd: Pointer to MPT_SCSI_HOST structure
>   *	@type: Task Management type
> + *	@channel: Logical bus number of the device
>   *	@id: Logical Target ID for reset (if appropriate)
>   *	@lun: Logical Unit for reset (if appropriate)
>   *	@ctx2abort: Context for the task to be aborted (if appropriate)
> + *	@timeout: time to wait in seconds before giving up
>   *
>   *	Remark: _HardResetHandler can be invoked from an interrupt thread (timer)
>   *	or a non-interrupt thread.  In the former, must not call schedule().
> @@ -2022,6 +2026,7 @@ mptscsih_tm_pending_wait(MPT_SCSI_HOST *
>  /**
>   *	mptscsih_tm_wait_for_completion - wait for completion of TM task
>   *	@hd: Pointer to MPT host structure.
> + *	@timeout: time to wait in seconds before giving up
>   *
>   *	Returns {SUCCESS,FAILED}.
>   */
> diff -uprN -X linux-2.6/Documentation/dontdiff
> linux-2.6/drivers/message/fusion/mptspi.c
> linux-2.6-new/drivers/message/fusion/mptspi.c
> --- linux-2.6/drivers/message/fusion/mptspi.c	2007-02-27
> 21:46:49.000000000 -0800
> +++ linux-2.6-new/drivers/message/fusion/mptspi.c	2007-02-28
> 23:03:26.000000000 -0800
> @@ -101,7 +101,7 @@ static int	mptspiInternalCtx = -1; /* Us
>   *	and NVRAM settings
>   *
>   *	@hd: Pointer to a SCSI Host Structure
> - *	@vtarget: per target private data
> + *	@target: per target private data
>   *	@sdev: SCSI device
>   *
>   **/
> @@ -232,9 +232,9 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST
>  }
> 
>  /**
> - * 	mptspi_writeIOCPage4  - write IOC Page 4
> + *	mptspi_writeIOCPage4  - write IOC Page 4
>   *	@hd: Pointer to a SCSI Host Structure
> - *	@channel:
> + *	@channel: Logical bus number of the device
>   *	@id: write IOC Page4 for this ID & Bus
>   *
>   *	Return: -EAGAIN if unable to obtain a Message Frame
> @@ -243,7 +243,7 @@ mptspi_setTargetNegoParms(MPT_SCSI_HOST
>   *	Remark: We do not wait for a return, write pages sequentially.
>   **/
>  static int
> -mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel , u8 id)
> +mptspi_writeIOCPage4(MPT_SCSI_HOST *hd, u8 channel, u8 id)
>  {
>  	MPT_ADAPTER		*ioc = hd->ioc;
>  	Config_t		*pReq;
> diff -uprN -X linux-2.6/Documentation/dontdiff linux-2.6/lib/bitmap.c
> linux-2.6-new/lib/bitmap.c
> --- linux-2.6/lib/bitmap.c	2007-02-28 23:15:13.000000000 -0800
> +++ linux-2.6-new/lib/bitmap.c	2007-02-28 23:15:19.000000000 -0800
> @@ -97,10 +97,10 @@ EXPORT_SYMBOL(__bitmap_complement);
> 
>  /**
>   * __bitmap_shift_right - logical right shift of the bits in a bitmap
> - *   @dst - destination bitmap
> - *   @src - source bitmap
> - *   @nbits - shift by this many bits
> - *   @bits - bitmap size, in bits
> + *   @dst: destination bitmap
> + *   @src: source bitmap
> + *   @shift: shift by this many bits
> + *   @bits: bitmap size, in bits
>   *
>   * Shifting right (dividing) means moving bits in the MS -> LS bit
>   * direction.  Zeros are fed into the vacated MS positions and the
> @@ -141,10 +141,10 @@ EXPORT_SYMBOL(__bitmap_shift_right);
> 
>  /**
>   * __bitmap_shift_left - logical left shift of the bits in a bitmap
> - *   @dst - destination bitmap
> - *   @src - source bitmap
> - *   @nbits - shift by this many bits
> - *   @bits - bitmap size, in bits
> + *   @dst: destination bitmap
> + *   @src: source bitmap
> + *   @shift: shift by this many bits
> + *   @bits: bitmap size, in bits
>   *
>   * Shifting left (multiplying) means moving bits in the LS -> MS
>   * direction.  Zeros are fed into the vacated LS bit positions
> -


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
