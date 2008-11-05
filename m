Return-Path: <linux-kernel-owner+w=401wt.eu-S1755956AbYKEKVz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956AbYKEKVz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 05:21:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047AbYKEKVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 05:21:45 -0500
Received: from mga01.intel.com ([192.55.52.88]:40786 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754508AbYKEKVo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 05:21:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,550,1220252400"; 
   d="scan'208";a="400156492"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] intel_menlo: max_state is unsigned, invalid test
Date: Wed, 5 Nov 2008 15:50:37 +0530
Message-ID: <7D0189F5BE1DF549A570B212D1D5612182AEA5@bgsmsx412.gar.corp.intel.com>
In-Reply-To: <alpine.LFD.2.00.0811032300551.3132@localhost.localdomain>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] intel_menlo: max_state is unsigned, invalid test
Thread-Index: Ack+MtSl7UHNAU32QR2FCCTBC9DUbAA/I9cQ
References: <4908D067.9080207@gmail.com> <20081103143526.375be238.akpm@linux-foundation.org> <alpine.LFD.2.00.0811032300551.3132@localhost.localdomain>
From: "Thomas, Sujith" <sujith.thomas@intel.com>
To: "Len Brown" <lenb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
Cc: "roel kluin" <roel.kluin@gmail.com>, "Brown, Len" <len.brown@intel.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>
X-OriginalArrivalTime: 05 Nov 2008 10:20:42.0021 (UTC) FILETIME=[2814ED50:01C93F30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: Len Brown [mailto:lenb@kernel.org]
>Sent: Tuesday, November 04, 2008 9:37 AM
>To: Andrew Morton; Thomas, Sujith; Zhang, Rui
>Cc: roel kluin; Brown, Len; Linux Kernel Mailing List; linux-
>acpi@vger.kernel.org
>Subject: Re: [PATCH] intel_menlo: max_state is unsigned, invalid test
>
>
>
>On Mon, 3 Nov 2008, Andrew Morton wrote:
>
>> On Wed, 29 Oct 2008 17:06:47 -0400
>> roel kluin <roel.kluin@gmail.com> wrote:
>>
>> > max_state is unsigned, so the test is invalid.
>> >
>> > Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
>> > ---
>> > I think max_state can only become -1, no? then probably a different
>> > patch is required.
>> > I may not be able to respond for a few weeks.
>> >
>> > diff --git a/drivers/misc/intel_menlow.c
b/drivers/misc/intel_menlow.c
>> > index e00a275..980171d 100644
>> > --- a/drivers/misc/intel_menlow.c
>> > +++ b/drivers/misc/intel_menlow.c
>> > @@ -121,7 +121,7 @@ static int memory_set_cur_bandwidth(struct
>thermal_cooling_device *cdev,
>> >  	if (memory_get_int_max_bandwidth(cdev, &max_state))
>> >  		return -EFAULT;
>> >
>> > -	if (max_state < 0 || state > max_state)
>> > +	if (max_state == -1 || state > max_state)
>> >  		return -EINVAL;
>> >
>> >  	arg_list.count = 1;
>> >
>>
>> hm, maybe.
>>
>> This can only happen if acpi_evaluate_integer(MEMORY_GET_BANDWIDTH)
>> returned no-error and a bandwidth of zero (I assume).
>>
>> Is this a special case which the driver really wanted to handle?  If
>> so, why is "0" the only bad value which we're checking for?  Or is
this
>> all some big brainfart which should be removed?
>
>Sujith,
>Please send me a patch to intel_menlo.c that documents the
>legal return values from GTHS.
>
>If 0 is illegal, that is fine, but the upstream driver doesn't
>check for it properl (I like Rui's 9/11 patch better than the above,
>so andrew, you can drop this patch in any case)
>
>thanks,
>-Len
>
>ps.  Sujith, shouldn't there be a MAINTAINERS for this driver with your
>name on it?
>
>
Hi Len,
I am also in agreement that Rui's 9/11 patch is the solution.
I'll be sending out patches you requested.
These can be applied over Rui's 9/11 patch.

Regards,
Sujith
	
