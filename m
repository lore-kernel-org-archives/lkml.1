Return-Path: <linux-kernel-owner+w=401wt.eu-S1758202AbYJMIry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202AbYJMIry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756766AbYJMIrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:47:23 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:41890 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709AbYJMIrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:47:21 -0400
From: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH 1/1] IB/ehca: Disallow creating UC QP with SRQ
Date: Mon, 13 Oct 2008 09:34:09 +0200
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       general@lists.openfabrics.org, micfaath@de.ibm.com, raisch@de.ibm.com,
       stefan.roscher@de.ibm.com
References: <200810011306.31544.hnguyen@linux.vnet.ibm.com> <adazllcku0c.fsf@cisco.com>
In-Reply-To: <adazllcku0c.fsf@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810130934.09592.hnguyen@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland,
That looks good to me.
Thanks for all help.

Nam

On Friday 10 October 2008 23:41, Roland Dreier wrote:
> thanks, applied -- it didn't apply to the latest tree, because of the
> flush CQE changes, so I merged it manually as below -- let me know if
> this is wrong:
> 
> commit 0540bbbe455e123a1692d26205ad1a29983883b0
> Author: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
> Date:   Fri Oct 10 14:40:39 2008 -0700
> 
>     IB/ehca: Don't allow creating UC QP with SRQ
>     
>     This patch prevents a UC QP to be created attached to an SRQ, since
>     current firmware does not support this feature.
>     
>     Signed-off-by: Michael Faath <micfaath@de.ibm.com>
>     Signed-off-by: Roland Dreier <rolandd@cisco.com>
> 
> diff --git a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
> index 4dbe287..40b578d 100644
> --- a/drivers/infiniband/hw/ehca/ehca_qp.c
> +++ b/drivers/infiniband/hw/ehca/ehca_qp.c
> @@ -502,6 +502,12 @@ static struct ehca_qp *internal_create_qp(
>  	if (init_attr->srq) {
>  		my_srq = container_of(init_attr->srq, struct ehca_qp, ib_srq);
> 
> +		if (qp_type == IB_QPT_UC) {
> +			ehca_err(pd->device, "UC with SRQ not supported");
> +			atomic_dec(&shca->num_qps);
> +			return ERR_PTR(-EINVAL);
> +		}
> +
>  		has_srq = 1;
>  		parms.ext_type = EQPT_SRQBASE;
>  		parms.srq_qpn = my_srq->real_qp_num;
> 


