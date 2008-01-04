Return-Path: <linux-kernel-owner+w=401wt.eu-S1757574AbYADBUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574AbYADBUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:20:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753059AbYADBTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:19:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:60452 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbYADBT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:19:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=t/4Ch+Wp6iZXr44Nhlfl5bb4yDJdkctcgLxvOP8RinDBc9GAn90SY7HmtyRgQIfJsnqwp11MPIY4eIG8bYJfXw/5So2Uvak4WFYBMnc7NCaWhNN4e6WjJAEGjP1Yxj4uldX1FWbmy3nYjn9KwtXqWniqCivnRru8LSYsnyNwMEE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Borislav Petkov <bbpetkov@yahoo.de>
Subject: Re: [RESEND PATCH 03/10] ide-floppy: convert to generic packet commands
Date: Fri, 4 Jan 2008 02:04:04 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071123.740460)
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>
References: <1199366409-26016-1-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-3-git-send-email-bbpetkov@yahoo.de> <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
In-Reply-To: <1199366409-26016-4-git-send-email-bbpetkov@yahoo.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801040204.04816.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 January 2008, Borislav Petkov wrote:
> Replace the ide-floppy packet commands opcode defines with the generic ones.
> Add a missing GPCMD_WRITE_12 (opcode 0xaa) to the generic ones in cdrom.h. The
> last one can be found in the current version of INF-8090, p.905.
> 
> CC: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Borislav Petkov <bbpetkov@yahoo.de>

please move this patch at the beggining of the patch series so it can be
applied immediately (patch #2 needs some more work)

> ---
>  drivers/ide/ide-floppy.c |   26 +++++++++++++-------------
>  drivers/ide/ide-floppy.h |   21 ---------------------

Please also note that patch #2 moved these defines to ide-floppy.h and now
patch #3 removes them so by re-ordering patches you can make patch #2 simpler.

[ This is a general hint for optimizing patches to make them smaller and easier
  to maintain, it also makes reviewer's job easier. ]

[...]

> --- a/include/linux/cdrom.h
> +++ b/include/linux/cdrom.h
> @@ -480,6 +480,7 @@ struct cdrom_generic_command
>  #define GPCMD_TEST_UNIT_READY		    0x00
>  #define GPCMD_VERIFY_10			    0x2f
>  #define GPCMD_WRITE_10			    0x2a
> +#define GPCMD_WRITE_12			    0xaa	/* ide floppy */

0xaa is a generic SCSI opcode so the above comment is not necessary

>  #define GPCMD_WRITE_AND_VERIFY_10	    0x2e
>  /* This is listed as optional in ATAPI 2.6, but is (curiously) 
>   * missing from Mt. Fuji, Table 57.  It _is_ mentioned in Mt. Fuji
