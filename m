Return-Path: <linux-kernel-owner+w=401wt.eu-S1759354AbZDFVNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759354AbZDFVNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 17:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757009AbZDFVLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 17:11:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:55424 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757938AbZDFVLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 17:11:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=L5qELrahMeEQv27n8WxttO+EG+tMT9UX401uJp6m281jOWxNzKdSDqLfMRZiRPQdlk
         xZzqIu8rKwDNsvgALUPdg0Mur+ti62gH+5ca9LDVOj9imz/ejh1dx+oFJ/UNaWkyLZfd
         R5ejXyAbM8tT2CXVykl9kfNz5O7bFG08fk/X0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <petkovbb@googlemail.com>
Subject: Re: [PATCH 2/2] ide-cd: cdrom_decode_status: use return codes instead of naked numbers
Date: Mon, 6 Apr 2009 23:00:15 +0200
User-Agent: KMail/1.11.1 (Linux/2.6.29-next-20090403; KDE/4.2.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <1238922962-19727-2-git-send-email-petkovbb@gmail.com>
In-Reply-To: <1238922962-19727-2-git-send-email-petkovbb@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200904062300.16108.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 05 April 2009, Borislav Petkov wrote:
> Remove unused SECTOR_SIZE while at it.
> 
> There should be no functional change resulting from this patch.
> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>

[...]

> @@ -431,7 +425,7 @@ static int cdrom_decode_status(ide_drive_t *drive, u8 stat)
>  	/* if we got a CHECK_CONDITION status, queue a request sense command */
>  	if (stat & ATA_ERR)
>  		cdrom_queue_request_sense(drive, NULL, NULL);
> -	return 1;
> +	return REQ_RECOVER;
>  
>  end_request:
>  	if (stat & ATA_ERR) {
> @@ -445,9 +439,9 @@ end_request:
>  		hwif->rq = NULL;
>  
>  		cdrom_queue_request_sense(drive, rq->sense, rq);
> -		return 1;
> -	} else
> -		return 2;
> +		return REQ_RECOVER;
> +	}
> +	return REQ_FAIL;
>  }

Could it be that cdrom_newpc_intr() chunk got lost somewhere along the way,
IIRC it was there?

[...]
  
> +/* internal decode_status codes */
> +#define REQ_CONT               0
> +#define REQ_RECOVER            1
> +#define REQ_FAIL               2

Did you notice my comments about REQ_* in previous mail?
