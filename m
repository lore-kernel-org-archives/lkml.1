Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbYGaONX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbYGaONX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 10:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753426AbYGaONK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 10:13:10 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:25178 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192AbYGaONJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 10:13:09 -0400
From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
To: Nikanth Karthikesan <knikanth@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       LKML-scsi <linux-scsi@vger.kernel.org>
CC: ISS StorageDev <iss_storagedev@hp.com>, Jens Axboe <jens.axboe@oracle.com>
Date: Thu, 31 Jul 2008 14:12:08 +0000
Subject: RE: [PATCH] cciss: return -EFAULT if copy_from_user() fails
Thread-Topic: [PATCH] cciss: return -EFAULT if copy_from_user() fails
Thread-Index: Acjy0voDA+WAlfh3SZCC+HEK/MAWKQARE2jA
Message-ID: <0F5B06BAB751E047AB5C87D1F77A778826B3E814F0@GVW0547EXC.americas.hpqcorp.net>
References: <200807311135.48889.knikanth@suse.de>
In-Reply-To: <200807311135.48889.knikanth@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Nikanth Karthikesan [mailto:knikanth@suse.de]
> Sent: Thursday, July 31, 2008 1:06 AM
> To: Miller, Mike (OS Dev)
> Cc: ISS StorageDev; Jens Axboe
> Subject: [PATCH] cciss: return -EFAULT if copy_from_user() fails
>
> Return -EFAULT instead of -ENOMEM if copy_from_user() fails.
>
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

Acked-by: Mike Miller <mike.miller@hp.com>

>
> ---
>  drivers/block/cciss.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> Index: b/drivers/block/cciss.c
> ===================================================================
> --- a/drivers/block/cciss.c
> +++ b/drivers/block/cciss.c
> @@ -1134,7 +1134,7 @@ static int cciss_ioctl(struct inode *ino
>                                 if
> (ioc->Request.Type.Direction == XFER_WRITE) {
>                                         if (copy_from_user
>                                             (buff[sg_used],
> data_ptr, sz)) {
> -                                               status = -ENOMEM;
> +                                               status = -EFAULT;
>                                                 goto cleanup1;
>                                         }
>                                 } else {
>
