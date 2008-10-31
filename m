Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbYJaIFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbYJaIFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 04:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYJaIEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 04:04:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:40737 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYJaIEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 04:04:36 -0400
Date: Fri, 31 Oct 2008 09:03:23 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: James.Bottomley@HansenPartnership.com, LKML <linux-kernel@vger.kernel.org>,
       linux-scsi@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsierror: fix indentation and braces disagreement - add braces
Message-ID: <20081031080322.GC31673@kernel.dk>
References: <Pine.LNX.4.64.0810301259000.7072@wrl-59.cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.64.0810301259000.7072@wrl-59.cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30 2008, Ilpo Järvinen wrote:
> 
> ...and the list of recent breakage goes on and on, this time
> it's 242f9dcb8ba6f (block: unify request timeout handling)
> which broke it.
> 
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
> Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
> Cc: Jens Axboe <jens.axboe@oracle.com>
> ---
>  drivers/scsi/scsi_error.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 94ed262..a6b107c 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -136,7 +136,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  	else
>  		eh_timed_out = NULL;
> 
> -	if (eh_timed_out)
> +	if (eh_timed_out) {
>  		rtn = eh_timed_out(scmd);
>  		switch (rtn) {
>  		case BLK_EH_NOT_HANDLED:
> @@ -144,6 +144,7 @@ enum blk_eh_timer_return scsi_times_out(struct request *req)
>  		default:
>  			return rtn;
>  		}
> +	}
> 
>  	if (unlikely(!scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD))) {
>  		scmd->result |= DID_TIME_OUT << 16;
> --
> 1.5.2.2

James, will you queue this up? The missing braces are harmless as it
stands, but the patch is correct :-)

-- 
Jens Axboe

