Return-Path: <linux-kernel-owner+w=401wt.eu-S1752823Ab0AGX3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab0AGX3N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188Ab0AGX3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:29:11 -0500
Received: from mga09.intel.com ([134.134.136.24]:22613 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab0AGX3J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:29:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="585318822"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Roel Kluin <roel.kluin@gmail.com>,
       "kvm-ia64@vger.kernel.org" <kvm-ia64@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jan 2010 07:28:57 +0800
Subject: RE: [PATCH] KVM: dereference of NULL pointer in set_pal_result()
Thread-Topic: [PATCH] KVM: dereference of NULL pointer in set_pal_result()
Thread-Index: AcqP5eiZhj8AasvRSY6i5TPbAlfqAgAChVog
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A38315E5831@shzsmsx502.ccr.corp.intel.com>
References: <4B465C2D.8030303@gmail.com>
In-Reply-To: <4B465C2D.8030303@gmail.com>
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

For the check "(p && p->exit_reason == EXIT_REASON_PAL_CALL", if p is NULL, the reference about "p->exit_reason == EXIT_REASON_PAL_CALL" won't be checked any more, so no issue here. 
Xiantao


Roel Kluin wrote:
> Do not dereference a NULL pointer
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/ia64/kvm/kvm_fw.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
> index e4b8231..d28494f 100644
> --- a/arch/ia64/kvm/kvm_fw.c
> +++ b/arch/ia64/kvm/kvm_fw.c
> @@ -75,9 +75,11 @@ static void set_pal_result(struct kvm_vcpu *vcpu,
>  	struct exit_ctl_data *p;
> 
>  	p = kvm_get_exit_data(vcpu);
> -	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
> +	if (!p)
> +		return;
> +	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
>  		p->u.pal_data.ret = result;
> -		return ;
> +		return;
>  	}
>  	INIT_PAL_STATUS_UNIMPLEMENTED(p->u.pal_data.ret);
>  }

