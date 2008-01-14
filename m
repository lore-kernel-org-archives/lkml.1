Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbYANVoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbYANVoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:44:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYANVoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:44:14 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:2576 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbYANVoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=RbC9VPeBLYKmschdSGa8BZMNIqyBN0H1knNtTEOn21djfKUYK6KZMIOtnNW73o+u53ruNxPTtk6sB9c3Iv7AFWXMNm+iWDfC8mMtDVNVYLvxukPsUR5FtaUDWgC+116WquIjX2zvG32k2CHNIRW7D0QSV0Os4Hod8VkEV0Ae1aY=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [PATCH 8/12] ide-floppy: merge idefloppy_{input,output}_buffers
Date: Mon, 14 Jan 2008 22:38:35 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1200255505-31418-1-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-8-git-send-email-bbpetkov@yahoo.de> <1200255505-31418-9-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1200255505-31418-9-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801142238.35893.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 January 2008, Borislav Petkov wrote:
> We merge idefloppy_{input,output}_buffers() into idefloppy_io_buffers() by
> introducing a 4th arg. called direction. According to its value
> we atapi_input_bytes() or atapi_output_bytes(). Also, this simplifies the
> interrupt handler logic a bit. Finally, rename idefloppy_io_buffers() to
> ide_floppy_io_buffers().
> 
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

This change depends on "ide-floppy: use an xfer_func_t and io_buf_t typedefs
in order to unify rw" which was not in the "v2.5" series.

I took the patch #16/21 from the previous series and applied it manually
fixing rejects, please verify that I didn't brake something in the process.

[...]

> @@ -380,8 +352,13 @@ static void idefloppy_output_buffers (ide_drive_t *drive, idefloppy_pc_t *pc, un
>  	idefloppy_do_end_request(drive, 1, done >> 9);
>  
>  	if (bcount) {
> -		printk(KERN_ERR "%s: leftover data in idefloppy_output_buffers, bcount == %d\n", drive->name, 
bcount);
> -		idefloppy_write_zeros(drive, bcount);
> +		printk(KERN_ERR "%s: leftover data in idefloppy_output_buffers,"
> +			" bcount == %d\n", drive->name, bcount);

I fixed the above to use __func__ while at it.

[ __FUNCTION__ is gcc-specific, __func__ is in C99 and is shorter ]
