Return-Path: <linux-kernel-owner+w=401wt.eu-S1761425AbYFFTP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761425AbYFFTP7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 15:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYFFTPt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 15:15:49 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:17517 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbYFFTPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 15:15:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=uKoAFieCWKtWtfZkcj4ZoTIo/NXcnJUSp4VDCg5KNA48hLyalQvb0NUs03y4MHeo3F
         pmvW6UuYwPWq3RuNW8pFTgr/bGdfZ3ORNB7Vcnk6o78KXQ1Wm6QFT2WRr4kSsDzlsa/R
         9zAsSPdHw8jjwpVDSn2j9uI6ha8uubzj/aRvo=
Message-ID: <48499C11.7030504@gmail.com>
Date: Fri, 06 Jun 2008 22:20:33 +0200
From: Dotan Barak <dotanba@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Joachim Fenkes <fenkes@de.ibm.com>
CC: LinuxPPC-Dev <linuxppc-dev@ozlabs.org>,
       LKML <linux-kernel@vger.kernel.org>,
       OF-General <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, OF-EWG <ewg@lists.openfabrics.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [ofa-general] IB/ehca: Reject send WRs only for RESET, INIT and
 RTR state
References: <200806061835.43802.fenkes@de.ibm.com>
In-Reply-To: <200806061835.43802.fenkes@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

I checked the code in the ehca driver and noticed that
post RR to a QP is being accepted in any state (including the RESET state).

thanks
Dotan

Joachim Fenkes wrote:
> Signed-off-by: Joachim Fenkes <fenkes@de.ibm.com>
> ---
>  drivers/infiniband/hw/ehca/ehca_reqs.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/hw/ehca/ehca_reqs.c b/drivers/infiniband/hw/ehca/ehca_reqs.c
> index bbe0436..f093b00 100644
> --- a/drivers/infiniband/hw/ehca/ehca_reqs.c
> +++ b/drivers/infiniband/hw/ehca/ehca_reqs.c
> @@ -421,8 +421,10 @@ int ehca_post_send(struct ib_qp *qp,
>  	int ret = 0;
>  	unsigned long flags;
>  
> -	if (unlikely(my_qp->state != IB_QPS_RTS)) {
> -		ehca_err(qp->device, "QP not in RTS state  qpn=%x", qp->qp_num);
> +	/* Reject WR if QP is in RESET, INIT or RTR state */
> +	if (unlikely(my_qp->state < IB_QPS_RTS)) {
> +		ehca_err(qp->device, "Invalid QP state  qp_state=%d qpn=%x",
> +			 my_qp->state, qp->qp_num);
>  		return -EINVAL;
>  	}
>  
>   

