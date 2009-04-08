Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbZDHMC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbZDHMC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 08:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932887AbZDHLni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 07:43:38 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:37145 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869AbZDHLng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 07:43:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wSk8rr2tJXFbj+FJeDhEhUlsfHUP9DCa8shbNIKBMPXTpUNqxCyMdvgVqRoroFwONq
         xx7ppFs3jY5d0ZcOMsnYNnvfWVASbx+VOHTbkQ2qpX43O1UvtvRQfGZQv7YBzniuu1K5
         a8L3xeeGlqnFKV/GRbrfW0PCubwgo9/lrq2ao=
MIME-Version: 1.0
In-Reply-To: <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
References: <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-17-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-18-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-19-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-20-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-21-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-22-git-send-email-jwjstone@fastmail.fm>
	 <1239189748-11703-23-git-send-email-jwjstone@fastmail.fm>
Date: Wed, 8 Apr 2009 13:43:33 +0200
Message-ID: <36ca99e90904080443m2c50be7dp588dab68e89dadc7@mail.gmail.com>
Subject: Re: [PATCH 22/56] message/fusion: Remove void casts
From: Bert Wesarg <bert.wesarg@googlemail.com>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: linux-kernel@vger.kernel.org, jeff@garzik.org,
       kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 8, 2009 at 13:21, Jack Stone <jwjstone@fastmail.fm> wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/message/fusion/mptbase.c |    6 +++---
>  drivers/message/fusion/mptctl.c  |    4 ++--
>  drivers/message/fusion/mptfc.c   |    4 ++--
>  3 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/message/fusion/mptctl.c b/drivers/message/fusion/mptctl.c
> index c638171..fbcd791 100644
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -2667,7 +2667,7 @@ mptctl_hp_targetinfo(unsigned long arg)
>                /* Issue the second config page request */
>                cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
>                data_sz = (int) cfg.cfghdr.hdr->PageLength * 4;
> -               pg3_alloc = (SCSIDevicePage3_t *) pci_alloc_consistent(
> +               pg3_alloc = pci_alloc_consistent(
>                                                        ioc->pcidev, data_sz, &page_dma);
Dito. (Sorry for being lazy in typing from this point up).

>                if (pg3_alloc) {
>                        cfg.physAddr = page_dma;
> diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
> index c3c24fd..d22acfd 100644
> --- a/drivers/message/fusion/mptfc.c
> +++ b/drivers/message/fusion/mptfc.c
> @@ -766,7 +766,7 @@ mptfc_GetFcPortPage0(MPT_ADAPTER *ioc, int portnum)
>
>        data_sz = hdr.PageLength * 4;
>        rc = -ENOMEM;
> -       ppage0_alloc = (FCPortPage0_t *) pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
> +       ppage0_alloc = pci_alloc_consistent(ioc->pcidev, data_sz, &page0_dma);
>        if (ppage0_alloc) {
>
>  try_again:
> @@ -907,7 +907,7 @@ start_over:
>                if (data_sz < sizeof(FCPortPage1_t))
>                        data_sz = sizeof(FCPortPage1_t);
>
> -               page1_alloc = (FCPortPage1_t *) pci_alloc_consistent(ioc->pcidev,
> +               page1_alloc = pci_alloc_consistent(ioc->pcidev,
>                                                data_sz,
>                                                &page1_dma);
Please check.

>                if (!page1_alloc)

Bert
