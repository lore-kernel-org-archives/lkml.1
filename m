Return-Path: <linux-kernel-owner+w=401wt.eu-S1753160AbYH2W7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbYH2W7x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 18:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750893AbYH2W7p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 18:59:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:58358 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091AbYH2W7o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 18:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,295,1217833200"; 
   d="scan'208";a="433516680"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Brice Goglin <brice@myri.com>
CC: Dave Airlie <airlied@gmail.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Date: Fri, 29 Aug 2008 15:59:06 -0700
Subject: RE: [patch 3/4] x86: PAT Update validate_pat_support for intel CPUs
Thread-Topic: [patch 3/4] x86: PAT Update validate_pat_support for intel CPUs
Thread-Index: AckIBhxSNDa/ldDmSdaYNAQAOQ5IrwCJFEMQ
Message-ID: <7E82351C108FA840AB1866AC776AEC460B7FC138@orsmsx505.amr.corp.intel.com>
References: <20080820234550.923970000@intel.com>
	 <20080820234604.592277000@intel.com>
 <21d7e9970808260005g14ec71e9xfa584780498a86e7@mail.gmail.com>
 <7E82351C108FA840AB1866AC776AEC460B68CC5F@orsmsx505.amr.corp.intel.com>
 <48B4E66C.2080806@myri.com>
In-Reply-To: <48B4E66C.2080806@myri.com>
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



>-----Original Message-----
>From: Brice Goglin [mailto:brice@myri.com]
>Sent: Tuesday, August 26, 2008 10:30 PM
>To: Pallipadi, Venkatesh
>Cc: Dave Airlie; mingo@elte.hu; tglx@linutronix.de;
>hpa@zytor.com; linux-kernel@vger.kernel.org; Siddha, Suresh B
>Subject: Re: [patch 3/4] x86: PAT Update validate_pat_support
>for intel CPUs
>
>Pallipadi, Venkatesh wrote:
>> Default MTRR being UC for all reserved regions and drivers
>> wanting WC is very common situation and performance will be
>> affected when that ends up being UC access.
>> With pat disabled, drivers can set MTRR with WC in this case
>> and get the expected performance.
>>
>
>Are you saying that drivers are supposed to check if PAT is disabled
>before deciding whether they need to setup a MTRR WC? If so, how to do
>we check that? Unless we get a way to know whether
>ioremap_wc() returned
>WC or UC, I will always keep the MTRR WC in myri10ge.
>

Agreed. There is no way for driver to cleanly know whether it got
WC mapping or not. I guess it is possibly simpler for kernel to
ignore MTRR writes when WC is working, rather than each driver
checking the return value. But, that will come later,
once we have PAT code stable.

Thanks,
Venki
