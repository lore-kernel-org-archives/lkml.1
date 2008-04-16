Return-Path: <linux-kernel-owner+w=401wt.eu-S932383AbYDPW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932383AbYDPW3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 18:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758515AbYDPW2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 18:28:08 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:15691 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667AbYDPW2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 18:28:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=fwdtS2syuN7r9P9UzC/2Ls472Rpg2ZAwdH+SseUxbVghGUqaHiE+0NUiHOXhB0WWNwzOvKb5EptFMgbnZ79HvR4AGILtosyUuvxWjiLsEx/MUC4+8Sba+2/CAGN40kQrf99elCJcbEqmxjDM8YD1+ZTC0MK8c8t5eCX1GrC+vuQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Roel Kluin <12o3l@tiscali.nl>
Subject: Re: [PATCH 3/6] IDE: ide-cd: fix test unsigned var < 0
Date: Thu, 17 Apr 2008 00:40:07 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       Borislav Petkov <petkovbb@gmail.com>
References: <48055F1A.9020706@tiscali.nl>
In-Reply-To: <48055F1A.9020706@tiscali.nl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200804170040.07397.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Wednesday 16 April 2008, Roel Kluin wrote:
> Is this the right fix in this case?

Yes, but it seems that 'valid' is only written to
so it may be as well removed completely.

Care to update the patch?

Thanks,
Bart

> ---
> valid is unsigned and cannot be below 0.,
>     
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
> index c8d0e87..a60f5df 100644
> --- a/drivers/ide/ide-cd.c
> +++ b/drivers/ide/ide-cd.c
> @@ -182,8 +182,6 @@ void cdrom_analyze_sense_data(ide_drive_t *drive,
>  			sector &= ~(bio_sectors -1);
>  			valid = (sector - failed_command->sector) << 9;
>  
> -			if (valid < 0)
> -				valid = 0;
>  			if (sector < get_capacity(info->disk) &&
>  				drive->probed_capacity - sector < 4 * 75) {
>  				set_capacity(info->disk, sector);
