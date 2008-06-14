Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbYFNRri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbYFNRri (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 13:47:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753393AbYFNRrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 13:47:06 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:9239 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYFNRrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 13:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=iG8o77cqqBNndklpejQfsQaNZOKIexE+vPtcqY8bYQ5apswq0kB+G/ExYiB9Sdmlhs
         d88FnYKpsmjGoZJ5WEWYz4j/T+iBpz4PNpZhvQp9d8rKVdhHiOdNL16Vy89K6Itt6Ido
         Ma89dhkDotqzAXPAKMmRoL6AwkAqApW/dhvBI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 02/18] ide-cd: remove ide_cd_drain_data and ide_cd_pad_transfer
Date: Sat, 14 Jun 2008 19:29:05 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
References: <1213252870-20474-1-git-send-email-petkovbb@gmail.com> <1213252870-20474-3-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1213252870-20474-3-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806141929.05834.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 June 2008, Borislav Petkov wrote:
> Use the generic ide_pad_transfer() helper instead
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

applied w/ ide_cd_drain_data() -> ide_pad_transfer() conversion fixup

[...]

> @@ -1006,7 +981,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  					   - bio_cur_sectors(rq->bio),
>  					   thislen >> 9);
>  			if (nskip > 0) {
> -				ide_cd_drain_data(drive, nskip);
> +				ide_pad_transfer(drive, write, nskip);
>  				rq->current_nr_sectors -= nskip;
>  				thislen -= (nskip << 9);
>  			}

ide_cd_drain_data() took number for _sectors_ as an argument
while ide_pad_transfer() wants to be given number of _bytes_

> @@ -1043,7 +1018,7 @@ static ide_startstop_t cdrom_newpc_intr(ide_drive_t *drive)
>  				 * If the buffers are full, pipe the rest into
>  				 * oblivion.
>  				 */
> -				ide_cd_drain_data(drive, thislen >> 9);
> +				ide_pad_transfer(drive, 0, thislen >> 9);

ditto
