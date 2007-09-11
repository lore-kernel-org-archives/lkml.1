Return-Path: <linux-kernel-owner+w=401wt.eu-S1762452AbXIKIIX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762452AbXIKIIX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 04:08:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759041AbXIKIIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 04:08:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:56345 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908AbXIKIIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 04:08:10 -0400
Date: Tue, 11 Sep 2007 09:08:08 +0100 (IST)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: Andrew Morton <akpm@linux-foundation.org>
cc: Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
In-Reply-To: <20070910221316.d31af0dd.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0709110907240.11816@skynet.skynet.ie>
References: <20070905071152.GA5817@zhen-devel.sh.intel.com>
 <20070905081937.35965e97.randy.dunlap@oracle.com> <20070906012852.GA8058@zhen-devel.sh.intel.com>
 <20070910221316.d31af0dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Subject: [PATCH] [AGPGART] intel_agp: fix stolen mem range on G33
>>
>> G33 GTT stolen memory is below graphics data
>> stolen memory and be seperate, so don't subtract
>> it in stolen mem counting.
>>
>> Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>

Andrew I meant to upstream these for 2.6.23 but travelling is still in 
progress, so if you could send them to Linus...

Acked-by: Dave Airlie <airlied@linux.ie>


>> ---
>>  drivers/char/agp/intel-agp.c |    5 +++++
>>  1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
>> index 2c9ca2c..581f922 100644
>> --- a/drivers/char/agp/intel-agp.c
>> +++ b/drivers/char/agp/intel-agp.c
>> @@ -506,6 +506,11 @@ static void intel_i830_init_gtt_entries(void)
>>  			break;
>>  		}
>>  	} else {
>> +		/* G33's GTT stolen memory is separate from gfx data
>> +		 * stolen memory.
>> +		 */
>> +		if (IS_G33)
>> +			size = 0;
>>  		switch (gmch_ctrl & I830_GMCH_GMS_MASK) {
>>  		case I855_GMCH_GMS_STOLEN_1M:
>>  			gtt_entries = MB(1) - KB(size);
>
> When looking at a "fix" I need to work out whether it might be needed in
> 2.6.23.  But your description of this patch didn't describe the problem
> which it fixes in a way which allows me to decide this.
>
>
>
