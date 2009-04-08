Return-Path: <linux-kernel-owner+w=401wt.eu-S1765220AbZDHMFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765220AbZDHMFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765102AbZDHL6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:58:21 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:52851 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933306AbZDHL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dTO9hHjHZ6wMlppBEkg5gaqTusXTQtxxDf4uIys53ucFVbD4hbcjcp26H4XBaM2db2
         0nKQ4TEL3dAFqqk3WIY6m5e6mFR3urkqn6NRegf3qxXzIC8vyL7CFyhyTLwMnh0xVXrE
         MnbWAdQ9Z4fnnA2PglEu887bPGdojEcVGHSb8=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-38-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-39-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-40-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-41-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-42-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-43-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-44-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-45-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-46-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 13:58:15 +0200
Message-ID: <36ca99e90904080458u71ccbd15vd568bbf25c218a6a@mail.gmail.com>
Subject: Re: [PATCH 45/56] scsi: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n38C5squ029667

On Wed, Apr 8, 2009 at 13:22, Jack Stone <jwjstone@fastmail.fm> wrote:> Remove uneeded void casts>> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>> --->  drivers/scsi/aic7xxx/aic79xx_core.c         |    4 ++-->  drivers/scsi/aic7xxx/aic7xxx_core.c         |    7 +++---->  drivers/scsi/aic7xxx/aicasm/aicasm.c        |   10 +++++----->  drivers/scsi/aic7xxx/aicasm/aicasm_symbol.c |    4 ++-->  drivers/scsi/aic7xxx_old.c                  |    3 +-->  drivers/scsi/ibmvscsi/ibmvscsi.c            |    3 +-->  drivers/scsi/ibmvscsi/ibmvstgt.c            |    2 +->  drivers/scsi/lpfc/lpfc_hbadisc.c            |    3 +-->  drivers/scsi/lpfc/lpfc_init.c               |    4 ++-->  drivers/scsi/lpfc/lpfc_nportdisc.c          |    4 ++-->  drivers/scsi/lpfc/lpfc_sli.c                |    8 ++++---->  drivers/scsi/osst.c                         |    6 +++--->  drivers/scsi/scsi_debug.c                   |    2 +->  13 files changed, 28 insertions(+), 32 deletions(-)>> diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c> index 63b521d..01f6d6f 100644> --- a/drivers/scsi/aic7xxx/aic79xx_core.c> +++ b/drivers/scsi/aic7xxx/aic79xx_core.c> @@ -6932,12 +6932,12 @@ ahd_alloc_scbs(struct ahd_softc *ahd)>                int error;>  #endif>> -               next_scb = (struct scb *)malloc(sizeof(*next_scb),> +               next_scb = malloc(sizeof(*next_scb),>                                                M_DEVBUF, M_NOWAIT);Dito.
>                if (next_scb == NULL)>                        break;>> -               pdata = (struct scb_platform_data *)malloc(sizeof(*pdata),> +               pdata = malloc(sizeof(*pdata),>                                                           M_DEVBUF, M_NOWAIT);Dito.
>                if (pdata == NULL) {>                        free(next_scb, M_DEVBUF);> diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c> index e6f2bb7..a46800d 100644> --- a/drivers/scsi/aic7xxx/aic7xxx_core.c> +++ b/drivers/scsi/aic7xxx/aic7xxx_core.c> @@ -2152,7 +2152,7 @@ ahc_alloc_tstate(struct ahc_softc *ahc, u_int scsi_id, char channel)>         && ahc->enabled_targets[scsi_id] != master_tstate)>                panic("%s: ahc_alloc_tstate - Target already allocated",>                      ahc_name(ahc));> -       tstate = (struct ahc_tmode_tstate*)malloc(sizeof(*tstate),> +       tstate = malloc(sizeof(*tstate),>                                                   M_DEVBUF, M_NOWAIT);Dito.
>        if (tstate == NULL)>                return (NULL);> @@ -5014,7 +5013,7 @@ ahc_alloc_scbs(struct ahc_softc *ahc)>  #ifndef __linux__>                int error;>  #endif> -               pdata = (struct scb_platform_data *)malloc(sizeof(*pdata),> +               pdata = malloc(sizeof(*pdata),>                                                           M_DEVBUF, M_NOWAIT);Dito.
>                if (pdata == NULL)>                        break;> diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c> index e2dd6a4..8d52a03 100644> --- a/drivers/scsi/ibmvscsi/ibmvstgt.c> +++ b/drivers/scsi/ibmvscsi/ibmvstgt.c> @@ -852,7 +852,7 @@ static int ibmvstgt_probe(struct vio_dev *dev, const struct vio_device_id *id)>        if (err)>                goto put_host;>> -       dma = (unsigned int *) vio_get_attribute(dev, "ibm,my-dma-window",> +       dma = vio_get_attribute(dev, "ibm,my-dma-window",>                                                 &dma_size);Dito.
>        if (!dma || dma_size != 40) {>                eprintk("Couldn't get window property %d\n", dma_size);
Bert���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
