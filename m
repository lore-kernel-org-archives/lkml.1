Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637Ab0AVAVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0AVAVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 19:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622Ab0AVAVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 19:21:45 -0500
Received: from hq-exedge.brocade.com ([66.243.153.82]:21290 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab0AVAVp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 19:21:45 -0500
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Thu, 21 Jan 2010 19:21:45 EST
From: Jing Huang <huangj@Brocade.COM>
To: Julia Lawall <julia@diku.dk>,
       "James E.J. Bottomley" <James.Bottomley@suse.de>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Thu, 21 Jan 2010 16:16:32 -0800
Subject: RE: [PATCH 5/9] drivers/scsi: Eliminate useless code
Thread-Topic: [PATCH 5/9] drivers/scsi: Eliminate useless code
Thread-Index: AcqWxNWxjZrd5g0ET6CAicLGaRn5fQEMyayg
Message-ID: <04391A4E90BB2149B010D22452FA16875F0348B0@HQ-EXCH-6.corp.brocade.com>
References: <Pine.LNX.4.64.1001161658410.28745@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1001161658410.28745@ask.diku.dk>
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

Acked-by: Jing Huang <huangj@brocade.com>

> -----Original Message-----
> From: Julia Lawall [mailto:julia@diku.dk]
> Sent: Saturday, January 16, 2010 7:59 AM
> To: Jing Huang; James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org; kernel-janitors@vger.kernel.org
> Subject: [PATCH 5/9] drivers/scsi: Eliminate useless code
> 
> From: Julia Lawall <julia@diku.dk>
> 
> The variable bfa_itnim is initialized twice to the same (side effect-free)
> expression.  Drop one initialization.
> 
> A simplified version of the semantic match that finds this problem is:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @forall@
> idexpression *x;
> identifier f!=ERR_PTR;
> @@
> 
> x = f(...)
> ... when != x
> (
> x = f(...,<+...x...+>,...)
> |
> * x = f(...)
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/scsi/bfa/bfad_im.c          |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
> index f788c2a..37b0fa1 100644
> --- a/drivers/scsi/bfa/bfad_im.c
> +++ b/drivers/scsi/bfa/bfad_im.c
> @@ -243,9 +243,8 @@ bfad_im_target_reset_send(struct bfad_s *bfad, struct
> scsi_cmnd *cmnd,
>  	struct bfa_itnim_s *bfa_itnim;
>  	bfa_status_t    rc = BFA_STATUS_OK;
> 
> -	bfa_itnim = bfa_fcs_itnim_get_halitn(&itnim->fcs_itnim);
>  	tskim = bfa_tskim_alloc(&bfad->bfa, (struct bfad_tskim_s *) cmnd);
>  	if (!tskim) {
>  		BFA_DEV_PRINTF(bfad, BFA_ERR,
