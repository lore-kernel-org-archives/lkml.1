Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYDUIpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYDUIpi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753980AbYDUIpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:45:30 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:36515 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753966AbYDUIp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:45:29 -0400
From: Joachim Fenkes <fenkes@de.ibm.com>
To: "LinuxPPC-Dev" <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH 1/5] IB/ehca: Prevent posting of SQ WQEs if QP not in RTS
Date: Mon, 21 Apr 2008 09:45:25 +0100
User-Agent: KMail/1.9.1
Cc: LKML <linux-kernel@vger.kernel.org>,
       "OF-General" <general@lists.openfabrics.org>,
       Roland Dreier <rolandd@cisco.com>, "OF-EWG" <ewg@lists.openfabrics.org>,
       "Hoang-Nam Nguyen" <hnguyen@de.ibm.com>,
       Christoph Raisch <raisch@de.ibm.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
References: <200804211003.10695.fenkes@de.ibm.com> <200804211004.44666.fenkes@de.ibm.com>
In-Reply-To: <200804211004.44666.fenkes@de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804211045.26183.fenkes@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2008 10:04, Joachim Fenkes wrote:

> +	if (unlikely(my_qp->state != IB_QPS_RTS)) {
> +		ehca_err(qp->device, "QP not in RTS state  qpn=%x", qp->qp_num);
> +		return -EINVAL;
> +	}

Myself, I'm not very happy with using EINVAL, but I can't think of a more
fitting return code. Also, this is what nes, amso and cxgb3 return in such a
case; ipath posts an error CQE and mthca/mlx4 don't do this check at all
(AFAICS).

Better suggestions, anyone?

Regards,
  Joachim

