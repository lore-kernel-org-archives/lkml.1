Return-Path: <linux-kernel-owner+w=401wt.eu-S1753529AbXLSIsk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbXLSIsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 03:48:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751571AbXLSIsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 03:48:30 -0500
Received: from py-out-1112.google.com ([64.233.166.183]:52103 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXLSIs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 03:48:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pCfdah0oz3VEokuXJMC5gtbeKerH2c4Bv4X3WDv3e3cOIktFuNw+DzjU+4zqv4Dr4zkBb4RdwhnPTutBZo07ykE4A4Nt9zJFnTtUpFvtGsRLR2zcyQR8JenhvOo8gCXcGhkiSYXewybWj0535jclYoTZeXV2cOFQ/rbwXM/vGl4=
Message-ID: <9f00bd9d0712190048g60d79ma067ba85b5553459@mail.gmail.com>
Date: Wed, 19 Dec 2007 10:48:27 +0200
From: "Filippos Papadopoulos" <psybases@gmail.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Subject: Re: INITIO scsi driver fails to work properly
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
In-Reply-To: <47666904.8060605@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>
	 <20071217031841.f483e5ac.akpm@linux-foundation.org>
	 <9f00bd9d0712170341u7fef1fc9pc9986dda1a0475cb@mail.gmail.com>
	 <47666904.8060605@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 17, 2007 2:18 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> I have found one problem. Please try patch [2] below and report.
> If it still fails try to enable debugging by setting with patch [1]
> these values at top of drivers/scsi/initio.c. And send dmsgs.
>
> Boaz
>


I tried patch[2] (addition of   sg++)  at 2.6.24-rc5-mm1 but the
system hangs after some seconds when the initio driver loads.
I will try patch[1] next week to see what happens.

Would it be better to open a bug report at bugzilla?


	

>
> --------
> patch [1]
> --------
>
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 4c4465d..61edcd2 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -138,10 +138,10 @@ static struct pci_device_id i91u_pci_devices[] = {
>  };
>  MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
>
> -#define DEBUG_INTERRUPT 0
> -#define DEBUG_QUEUE     0
> -#define DEBUG_STATE     0
> -#define INT_DISC       0
> +#define DEBUG_INTERRUPT 1
> +#define DEBUG_QUEUE     1
> +#define DEBUG_STATE     1
> +#define INT_DISC       1
>
>  /*--- forward references ---*/
>  static struct scsi_ctrl_blk *initio_find_busy_scb(struct initio_host * host, u16 tarlun);
>
>
> -----------
> patch [2]
> -----------
> git-diff --stat -p
>  drivers/scsi/initio.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
> index 4c4465d..61595f6 100644
> --- a/drivers/scsi/initio.c
> +++ b/drivers/scsi/initio.c
> @@ -2616,6 +2616,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
>                 scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
>                         sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
>                         total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
> +                       sg++;
>                 }
>
>                 cblk->buflen = (scsi_bufflen(cmnd) > total_len) ?
>
>
>
