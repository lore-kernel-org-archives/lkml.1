Return-Path: <linux-kernel-owner+w=401wt.eu-S1751655AbZLRBOh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbZLRBOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 20:14:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbZLRBOg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 20:14:36 -0500
Received: from mga01.intel.com ([192.55.52.88]:35455 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZLRBOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 20:14:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,415,1257148800"; 
   d="scan'208";a="757297457"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>
Date: Thu, 17 Dec 2009 17:14:32 -0800
Subject: RE: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
 setup
Thread-Topic: [PATCH 2/2] x86/apic: check global clockevent in lapic timer
 setup
Thread-Index: Acp/aRbFGT5hsjlFR66bYFgiAi4zaAACB4UQ
Message-ID: <43F901BD926A4E43B106BF17856F07559A257FE1@orsmsx508.amr.corp.intel.com>
References: <43F901BD926A4E43B106BF17856F07559A257B5C@orsmsx508.amr.corp.intel.com>
 <20091217194148.GB5414@lenovo>
 <43F901BD926A4E43B106BF17856F07559A257E3D@orsmsx508.amr.corp.intel.com>
 <4B2AB1F0.1020105@linux.intel.com>
In-Reply-To: <4B2AB1F0.1020105@linux.intel.com>
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
>From: H. Peter Anvin [mailto:hpa@linux.intel.com]
>Sent: Thursday, December 17, 2009 2:34 PM
>To: Pan, Jacob jun
>Cc: Cyrill Gorcunov; linux-kernel@vger.kernel.org; x86@kernel.org
>Subject: Re: [PATCH 2/2] x86/apic: check global clockevent in lapic timer setup
>
>On 12/17/2009 02:31 PM, Pan, Jacob jun wrote:
>>> Wouldn't be better to operate the same way as in case of "noapictimer"
>>> boot option. I guess the non-pc x86 midplatforms you're mentioning
>>> do not use SMP ever but just to be consistent in code.
>>>
>> [[JPAN]] We do use SMP with hyper threading in Moorestown.
>> In that case we have a per cpu platform timer without global clockevent.
>> so i think we don't want the dummy lapic event. we don't want to use the
>> broadcast mechanism as mentioned in the comments before disabling lapic
>> timer.
>>
>> For moorestown, I can use x86_init.timers.setup_percpu_clockev
>> abstraction function so that Moorestown platform does not need to call
>> setup_boot_APIC_clock() if per cpu platform timer is used. so many IFs :).
>>
>> But in the case of having constant and always on LAPIC timer, we still do
>> not want the dummy lapic clockevent and the broadcast. we will just have
>> per cpu always on local apic timers without global clockevent device.
>
>OK, I'm not entirely sure I follow this, and I'm not sure someone trying
>to understand the code in five years would, either.  I don't really see
>the above translating into "we don't have a global clockevent, therefore
>we shouldn't initialize (but should still not disable) the local APIC
>timer."
>
>	-hpa
[[JPAN]] There is some thing wrong in my logic.

If we have always running lapic timer, and per cpu platform timers, we would
still want to set up the lapic timer without global clockevent, just without
calibration. perhaps use a platform specific setup_percpu_clockev() function.

So i don't think we need this patch at the moment, maybe we only need to do a
sanity check for global clockevent in calibrate_APIC_clock().

Honestly, i don't fully understand how the dummy lapic event device is related
to the broadcast mechanism. can someone explain why we register the dummy
lapic clockevent?

