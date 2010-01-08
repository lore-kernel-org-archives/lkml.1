Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807Ab0AHJPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0AHJPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 04:15:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322Ab0AHJPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 04:15:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:44784 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab0AHJPN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 04:15:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,241,1262592000"; 
   d="scan'208";a="482389516"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Gabor Gombas <gombasg@sztaki.hu>
CC: Roel Kluin <roel.kluin@gmail.com>,
       "kvm-ia64@vger.kernel.org" <kvm-ia64@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Date: Fri, 8 Jan 2010 17:14:25 +0800
Subject: RE: [PATCH] KVM: dereference of NULL pointer in set_pal_result()
Thread-Topic: [PATCH] KVM: dereference of NULL pointer in set_pal_result()
Thread-Index: AcqQMeNH9yyhCx5aQr2vdQpCo80pMQAEPa8A
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A38318A1443@shzsmsx502.ccr.corp.intel.com>
References: <4B465C2D.8030303@gmail.com>
 <EB8593BCECAB3D40A8248BE0B6400A38315E5831@shzsmsx502.ccr.corp.intel.com>
 <20100108071200.GB15621@boogie.lpds.sztaki.hu>
In-Reply-To: <20100108071200.GB15621@boogie.lpds.sztaki.hu>
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

Gabor Gombas wrote:
> On Fri, Jan 08, 2010 at 07:28:57AM +0800, Zhang, Xiantao wrote:
> 
>> For the check "(p && p->exit_reason == EXIT_REASON_PAL_CALL", if p
>> is NULL, the reference about "p->exit_reason ==
>> EXIT_REASON_PAL_CALL" won't be checked any more, so no issue here.  
> 
>>> diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
>>> index e4b8231..d28494f 100644
>>> --- a/arch/ia64/kvm/kvm_fw.c
>>> +++ b/arch/ia64/kvm/kvm_fw.c
>>> @@ -75,9 +75,11 @@ static void set_pal_result(struct kvm_vcpu
>>> *vcpu,  	struct exit_ctl_data *p; 
>>> 
>>>  	p = kvm_get_exit_data(vcpu);
>>> -	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) { +	if (!p)
>>> +		return;
>>> +	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
>>>  		p->u.pal_data.ret = result;
>>> -		return ;
>>> +		return;
>>>  	}
>>>  	INIT_PAL_STATUS_UNIMPLEMENTED(p->u.pal_data.ret);
> 
> IMHO it's not the test but the INIT_PAL_STATUS_UNIMPLEMENTED() that
> does the unwanted dereferencing, and that's fixed by the patch.
Make sense. 
Xiantao
