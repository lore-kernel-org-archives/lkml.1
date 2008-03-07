Return-Path: <linux-kernel-owner+w=401wt.eu-S1765441AbYCGAVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765441AbYCGAVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 19:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758134AbYCGAU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 19:20:58 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:48210 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757158AbYCGAU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 19:20:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=eWYBEMwZ5/FSmC+Ys1fPNi2ThvJE6R9MvgvZphvAm3CjDyCFkOJTwDdEIN8SyuzD6Hl8sttX0Z3bSQ8n/sOBY9fyJtBYIwLmgizVyEPxmCT9zhsArhHcjhE8Xp0VoIpFOH3MwpjvpSLDIlX2DbbbePRqmuyDMZ7kBVM7S/Om6m8=
Message-ID: <47D08AA1.4020003@gmail.com>
Date: Thu, 06 Mar 2008 16:21:53 -0800
From: walt <w41ter@gmail.com>
User-Agent: Thunderbird 3.0a1pre (X11/2008030605)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: Commit 9f10d9ee breaks CD mounting/burning
References: <fqngjf$cjf$1@ger.gmane.org> <200803062235.00396.bzolnier@gmail.com>
In-Reply-To: <200803062235.00396.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> On Thursday 06 March 2008, walt wrote:
>> Hi Bartolmiej,
>>
>> For me, this commit causes the problem it's intended to fix:
>>
>> commit 9f10d9ee0ac6d79d7bc8b9a158bf4a29322d84d3
>> Author: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> Date:   Tue Feb 26 21:50:35 2008 +0100
>>
>>       ide-cd: fix 'ireason' handling for REQ_TYPE_ATA_PC requests


> Does the following patch help?
>
> [ Borislav, please take a look and double check that it is OK. ]
>
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] ide-cd: mark REQ_TYPE_ATA_PC write requests with REQ_RW flag
>
> It turned out that REQ_TYPE_ATA_PC write requests were not marked as such
> (the previous commit assumed them to be).
>
> Reported-by: walt<w41ter@gmail.com>
> Cc: Borislav Petkov<petkovbb@googlemail.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ide/ide-cd_ioctl.c |    4 ++++
>   1 file changed, 4 insertions(+)
>
> Index: b/drivers/ide/ide-cd_ioctl.c
> ===================================================================
> --- a/drivers/ide/ide-cd_ioctl.c
> +++ b/drivers/ide/ide-cd_ioctl.c
> @@ -457,6 +457,10 @@ int ide_cdrom_packet(struct cdrom_device
>   	   layer. the packet must be complete, as we do not
>   	   touch it at all. */
>   	ide_cd_init_rq(drive,&req);
> +
> +	if (cgc->data_direction == CGC_DATA_WRITE)
> +		req.cmd_flags |= REQ_RW;
> +
>   	memcpy(req.cmd, cgc->cmd, CDROM_PACKET_SIZE);
>   	if (cgc->sense)
>   		memset(cgc->sense, 0, sizeof(struct request_sense));
>

It's perfect, thanks!
