Return-Path: <linux-kernel-owner+w=401wt.eu-S1758615AbYBMOGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbYBMOGg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 09:06:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbYBMOG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 09:06:26 -0500
Received: from ts.adaptec.com ([162.62.93.58]:51993 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbYBMOGZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 09:06:25 -0500
From: "Salyzyn, Mark" <Mark_Salyzyn@adaptec.com>
To: "marcin.slusarz@gmail.com" <marcin.slusarz@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>
Date: Wed, 13 Feb 2008 06:06:22 -0800
Subject: RE: [PATCH] scsi: le*_add_cpu conversion
Thread-Topic: [PATCH] scsi: le*_add_cpu conversion
Thread-Index: AchtzE+7rIBlrQhwSPqkDEpqpsMb0wAe9myA
Message-ID: <532ABFBDAAC3A34EB12EBA6CEC2838F439963FA2@ADPE2K703.adaptec.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
 <1202857582-15450-9-git-send-email-marcin.slusarz@gmail.com>
In-Reply-To: <1202857582-15450-9-git-send-email-marcin.slusarz@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: marcin.slusarz@gmail.com [mailto:marcin.slusarz@gmail.com]
> Sent: Tuesday, February 12, 2008 6:06 PM
> To: LKML
> Cc: Marcin Slusarz; linux-scsi@vger.kernel.org; AACRAID;
> James.Bottomley@HansenPartnership.com
> Subject: [PATCH] scsi: le*_add_cpu conversion
>
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
>
> replace all:
> little_endian_variable =
> cpu_to_leX(leX_to_cpu(little_endian_variable) +
>                                         expression_in_cpu_byteorder);
> with:
>         leX_add_cpu(&little_endian_variable,
> expression_in_cpu_byteorder);
> generated with semantic patch
>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: linux-scsi@vger.kernel.org
> Cc: aacraid@adaptec.com
> Cc: James.Bottomley@HansenPartnership.com
> ---
>  drivers/scsi/aacraid/commsup.c |    2 +-
>  drivers/scsi/ips.c             |    8 ++------
>  2 files changed, 3 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/scsi/aacraid/commsup.c
> b/drivers/scsi/aacraid/commsup.c
> index 81b3692..3ac8c82 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -594,7 +594,7 @@ void aac_consumer_free(struct aac_dev *
> dev, struct aac_queue *q, u32 qid)
>         if (le32_to_cpu(*q->headers.consumer) >= q->entries)
>                 *q->headers.consumer = cpu_to_le32(1);
>         else
> -               *q->headers.consumer =
> cpu_to_le32(le32_to_cpu(*q->headers.consumer)+1);
> +               le32_add_cpu(q->headers.consumer, 1);
>
>         if (wasfull) {
>                 switch (qid) {
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index bb152fb..f45770a 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -3696,9 +3696,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
>                         scb->cmd.basic_io.sg_count = scb->sg_len;
>
>                         if (scb->cmd.basic_io.lba)
> -                               scb->cmd.basic_io.lba =
> -                                   cpu_to_le32(le32_to_cpu
> -
> (scb->cmd.basic_io.lba) +
> +                               le32_add_cpu(&scb->cmd.basic_io.lba,
>
> le16_to_cpu(scb->cmd.basic_io.
>
> sector_count));
>                         else
> @@ -3744,9 +3742,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
>                         scb->cmd.basic_io.sg_count = scb->sg_len;
>
>                         if (scb->cmd.basic_io.lba)
> -                               scb->cmd.basic_io.lba =
> -                                   cpu_to_le32(le32_to_cpu
> -
> (scb->cmd.basic_io.lba) +
> +                               le32_add_cpu(&scb->cmd.basic_io.lba,
>
> le16_to_cpu(scb->cmd.basic_io.
>
> sector_count));
>                         else
> --
> 1.5.3.7
