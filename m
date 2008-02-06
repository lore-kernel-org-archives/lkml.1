Return-Path: <linux-kernel-owner+w=401wt.eu-S1757920AbYBFRqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbYBFRqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYBFRps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:45:48 -0500
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37168 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756664AbYBFRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:45:44 -0500
Subject: Re: [PATCH][drivers/scsi/u14-34f.c] duplicate test
	'SCpnt->sc_data_direction == DMA_FROM_DEVICE'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: ballabio_dario@emc.com, linux-scsi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47A7937C.7040701@tiscali.nl>
References: <47A7937C.7040701@tiscali.nl>
Content-Type: text/plain
Date: Wed, 06 Feb 2008 11:45:39 -0600
Message-Id: <1202319939.3112.89.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-02-04 at 23:36 +0100, Roel Kluin wrote:
> It should be like this I guess? this patch was not yet tested, please
> confirm.
> --
> Note the duplicate test 'SCpnt->sc_data_direction == DMA_FROM_DEVICE'
> 
> from Documentation/DMA-API.txt:
> DMA_TO_DEVICE         = PCI_DMA_TODEVICE      data is going from the
>                                               memory to the device
> DMA_FROM_DEVICE       = PCI_DMA_FROMDEVICE    data is coming from
>                                               the device to the
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
> ---
> diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
> index 662c004..1e704f9 100644
> --- a/drivers/scsi/u14-34f.c
> +++ b/drivers/scsi/u14-34f.c
> @@ -1208,15 +1208,15 @@ static void scsi_to_dev_dir(unsigned int i, unsigned int j) {
>        };
>  
>     struct mscp *cpp;
>     struct scsi_cmnd *SCpnt;
>  
>     cpp = &HD(j)->cp[i]; SCpnt = cpp->SCpnt;
>  
> -   if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
> +   if (SCpnt->sc_data_direction == DMA_TO_DEVICE) {
>        cpp->xdir = DTD_IN;
>        return;
>        }
>     else if (SCpnt->sc_data_direction == DMA_FROM_DEVICE) {
>        cpp->xdir = DTD_OUT;
>        return;
>        }

Well spotted, this is definitely a huge bug in the driver.

However, I think on closer examination that DTD_IN actually means
transfer from device to host, so DMA_FROM_DEVICE is correct for that
case.  It should be DMA_TO_DEVICE in the else if() piece.

Could you correct and resend the patch and I'll apply it.

Thanks,

James


