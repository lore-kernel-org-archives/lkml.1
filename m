Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbZBLNnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbZBLNnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 08:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756933AbZBLNnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 08:43:07 -0500
Received: from mga09.intel.com ([134.134.136.24]:58722 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbZBLNnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:43:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,197,1233561600"; 
   d="scan'208";a="386235242"
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
       "Yu, Fenghua" <fenghua.yu@intel.com>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>, Chris Wright <chrisw@sous-sol.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Date: Thu, 12 Feb 2009 15:42:05 +0200
Subject: RE: [PATCH]iwlan dma mapping read and write changes
Thread-Topic: [PATCH]iwlan dma mapping read and write changes
Thread-Index: AcmMlgQ00DLbrGHwSFGdeNwM49bG0QAgNZCA
Message-ID: <6F5C1D715B2DA5498A628E6B9C124F04F639FADE@hasmsx504.ger.corp.intel.com>
References: <20081001165606.GA21279@linux-os.sc.intel.com>
	 <20090211182648.GA1661@linux-os.sc.intel.com>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2CD@hasmsx504.ger.corp.intel.com>
	 <1234388027.16004.50.camel@johannes.local>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2D5@hasmsx504.ger.corp.intel.com>
	 <1234388845.16004.53.camel@johannes.local>
	 <1234389007.16004.55.camel@johannes.local>
	 <6F5C1D715B2DA5498A628E6B9C124F04F633E2FA@hasmsx504.ger.corp.intel.com>
 <1234390413.3586.85.camel@macbook.infradead.org>
In-Reply-To: <1234390413.3586.85.camel@macbook.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: David Woodhouse [mailto:dwmw2@infradead.org]
>Sent: Thursday, February 12, 2009 12:14 AM
>To: Winkler, Tomas
>Cc: Johannes Berg; Yu, Fenghua; Ingo Molnar; Stephen Rothwell; Grumbach,
>Emmanuel; Zhu, Yi; Chris Wright; LKML; iommu@lists.linux-foundation.org
>Subject: RE: [PATCH]iwlan dma mapping read and write changes
>
>On Thu, 2009-02-12 at 00:10 +0200, Winkler, Tomas wrote:
>>
>> >-----Original Message-----
>> >From: Johannes Berg [mailto:johannes@sipsolutions.net]
>> >Sent: Wednesday, February 11, 2009 11:50 PM
>> >To: Winkler, Tomas
>> >Cc: Yu, Fenghua; David Woodhouse; Ingo Molnar; Stephen Rothwell;
>Grumbach,
>> >Emmanuel; Zhu, Yi; Chris Wright; LKML; iommu@lists.linux-foundation.org
>> >Subject: RE: [PATCH]iwlan dma mapping read and write changes
>> >
>> >On Wed, 2009-02-11 at 22:47 +0100, Johannes Berg wrote:
>> >> > >> Indeed the firmware/ucode write back to host memory to update
>retry
>> >> > >> counter for APMDU packets. I'm not sure if this is needed for
>legacy
>> >> > >> traffic, though.
>> >> > >
>> >> > >I don't think they can be seeing AMPDU packets since that is, well,
>> >> > >broken?
>> >> >
>> >> > Currently I'm not aware of any other cases where memory is accessed
>> >> > back but I may have not complete info.  Will be back with the answer
>> >> > tomorrow.
>> >>
>> >> I don't think it really matters, since AMPDU packets will be fixed
>soon,
>> >> and for those you know it's necessary (and the report says that under
>> >> some other circumstances it's also necessary). Unless there'd be some
>> >> benefit from using BIDI only when we know it'll be needed, and using
>> >> TODEV in the other cases?
>> >
>> >Or if there's a firmware bug.
>>
>> That's why it's better to clear the picture.
>> Fenghua
>> What exact HW do you get this error?
>
>Lenovo T400.
>


>03:00.0 0280: 8086:4236
>

I can confirm that for 5000 series the patch is required also for regular frames. In this particular machine the NIC is 5300. For 4965 only for AMPDU frames are affected also the implementation is not the same but I'm not sure if it makes any sense to differentiate. 

Does anybody know what performance implications of this change are? 

Thanks Tomas  


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

