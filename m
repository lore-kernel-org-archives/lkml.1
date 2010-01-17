Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355Ab0AQDUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab0AQDUK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 22:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250Ab0AQDUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 22:20:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:58936 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab0AQDUF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 22:20:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,289,1262592000"; 
   d="scan'208";a="484578084"
From: "Zhang, Xiantao" <xiantao.zhang@intel.com>
To: Bill Davidsen <davidsen@tmr.com>, Roel Kluin <roel.kluin@gmail.com>
CC: "kvm-ia64@vger.kernel.org" <kvm-ia64@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Sun, 17 Jan 2010 11:19:57 +0800
Subject: RE: [PATCH] KVM: remove redundant NULL tests
Thread-Topic: [PATCH] KVM: remove redundant NULL tests
Thread-Index: AcqW2c8kBFmENs7KQNW/h7U5taDglQASda2g
Message-ID: <EB8593BCECAB3D40A8248BE0B6400A38355E3BEC@shzsmsx502.ccr.corp.intel.com>
References: <4B4F4EF6.2050202@gmail.com> <4B520571.7050502@tmr.com>
In-Reply-To: <4B520571.7050502@tmr.com>
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

Bill Davidsen wrote:
> Roel Kluin wrote:
>> kvm_get_exit_data() cannot return a NULL pointer.
>> 
>> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> ---
>>  arch/ia64/kvm/kvm_fw.c |   28 +++++++++++++---------------
>>  1 files changed, 13 insertions(+), 15 deletions(-)
>> 
>> diff --git a/arch/ia64/kvm/kvm_fw.c b/arch/ia64/kvm/kvm_fw.c
>> index e4b8231..cb548ee 100644
>> --- a/arch/ia64/kvm/kvm_fw.c
>> +++ b/arch/ia64/kvm/kvm_fw.c
>> @@ -75,7 +75,7 @@ static void set_pal_result(struct kvm_vcpu *vcpu, 
>> struct exit_ctl_data *p; 
>> 
>>  	p = kvm_get_exit_data(vcpu);
>> -	if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
>> +	if (p->exit_reason == EXIT_REASON_PAL_CALL) {
>>  		p->u.pal_data.ret = result;
>>  		return ;
>>  	}
> 	[___etc___]
> 
> Clearly the original author thought that there was a path where
> kvm_exit_data could return a NULL pointer, was that ever possible?

Originally, we planed to allocate the exit_data dynamically, but considering some constrains, the exit_data is allocated statically, so the check for NULL is useless now. 
Xiantao