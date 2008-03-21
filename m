Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbYCUAAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbYCUAAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 20:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758896AbYCTX4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:56:40 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:57106 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758365AbYCTX4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:56:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=tufkJyjafFD7ANvOHEDL+6r/wpN8jDtlK2Vpg8DV3SMy5YxI2Pfb1X8vgeShU79HgqIo2RDtTFperTx5ngQ+BkmJs6QrYVOE8/hOjamApkiVz71CbJftMFdYTM2hqTSGVQwXNgpjKu79OpLL24UTsBJfVP9oGJ4DXGfdxUpqGAk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 14/17] ide-tape: remove pipeline-specific members from struct ide_tape_obj
Date: Fri, 21 Mar 2008 01:09:47 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1205736090-4435-1-git-send-email-petkovbb@gmail.com> <1205736090-4435-15-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1205736090-4435-15-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803210109.47178.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2008, Borislav Petkov wrote:
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied after:
- merging with "ide-tape: remove pipeline-specific code from idetape_setup"
- cleaning up __idetape_discard_read_pipeline() (since patch #3 was dropped)
- cleaning up idetape_empty_write_pipeline() (since patch #4 was dropped)

> @@ -1905,7 +1855,6 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
>  	struct idetape_config {
>  		int dsc_rw_frequency;
>  		int dsc_media_access_frequency;
> -		int nr_stages;

we need to keep it:

>  	} config;
>  
>  	debug_log(DBG_PROCS, "Enter %s\n", __func__);
> @@ -1915,11 +1864,9 @@ static int idetape_blkdev_ioctl(ide_drive_t *drive, unsigned int cmd,
>  		if (copy_from_user(&config, argp, sizeof(config)))
>  			return -EFAULT;
>  		tape->best_dsc_rw_freq = config.dsc_rw_frequency;
> -		tape->max_stages = config.nr_stages;
>  		break;
>  	case 0x0350:
>  		config.dsc_rw_frequency = (int) tape->best_dsc_rw_freq;
> -		config.nr_stages = tape->max_stages;

changed this to export '1' to user-space
(which has always meant that pipeline-mode is disabled)

>  		if (copy_to_user(argp, &config, sizeof(config)))
>  			return -EFAULT;
>  		break;
