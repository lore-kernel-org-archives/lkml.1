Return-Path: <linux-kernel-owner+w=401wt.eu-S1758208AbYLPPbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758208AbYLPPbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 10:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbYLPPbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 10:31:09 -0500
Received: from emulex.emulex.com ([138.239.112.1]:60698 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbYLPPbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 10:31:07 -0500
Message-ID: <4947CA08.4000606@emulex.com>
Date: Tue, 16 Dec 2008 10:32:24 -0500
From: James Smart <James.Smart@Emulex.Com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: "James.Bottomley@HansenPartnership.com" 
	<James.Bottomley@HansenPartnership.com>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 9/11] drivers/scsi: Move a dereference below a NULL test
References: <Pine.LNX.4.64.0812161614500.20444@pc-004.diku.dk>
In-Reply-To: <Pine.LNX.4.64.0812161614500.20444@pc-004.diku.dk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2008 15:32:28.0658 (UTC) FILETIME=[810AF520:01C95F93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

-- james s

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> In each case, if the NULL test is necessary, then the dereference should be
> moved below the NULL test.
> 
> The semantic patch that makes this change is as follows:
> (http://www.emn.fr/x-info/coccinelle/)
> 
> // <smpl>
> @@
> type T;
> expression E;
> identifier i,fld;
> statement S;
> @@
> 
> - T i = E->fld;
> + T i;
>   ... when != E
>       when != i
>   if (E == NULL) S
> + i = E->fld;
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/scsi/lpfc/lpfc_init.c       |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
> index 909be33..9a01cf0 100644
> --- a/drivers/scsi/lpfc/lpfc_init.c
> +++ b/drivers/scsi/lpfc/lpfc_init.c
> @@ -1736,12 +1736,13 @@ lpfc_block_mgmt_io(struct lpfc_hba * phba)
>  int
>  lpfc_online(struct lpfc_hba *phba)
>  {
> -       struct lpfc_vport *vport = phba->pport;
> +       struct lpfc_vport *vport;
>         struct lpfc_vport **vports;
>         int i;
> 
>         if (!phba)
>                 return 0;
> +       vport = phba->pport;
> 
>         if (!(vport->fc_flag & FC_OFFLINE_MODE))
>                 return 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
