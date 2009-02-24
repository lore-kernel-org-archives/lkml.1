Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbZBXWJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbZBXWJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:09:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757477AbZBXWJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:09:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:55554 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974AbZBXWJ0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:09:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,261,1233561600"; 
   d="scan'208";a="114008529"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Airlie <airlied@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andy Isaacson <adi@hexapodia.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "lenb@kernel.org" <lenb@kernel.org>, "mjg@redhat.com" <mjg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Zhang, Rui" <rui.zhang@intel.com>
Date: Tue, 24 Feb 2009 14:10:48 -0800
Subject: RE: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not
 ioremap virtual address for G33 hw status page
Thread-Topic: [Linux 2.6.29-rc6] [drm:i915_set_status_page] *ERROR* can not
 ioremap virtual address for G33 hw status page
Thread-Index: AcmWyzqAK6NHI4zMR/mgEH9oEyqr2wAAKWCA
Message-ID: <7E82351C108FA840AB1866AC776AEC464A6A1717@orsmsx505.amr.corp.intel.com>
References: <8db1092f0902230646o78a07a09t920ad65369b5a20d@mail.gmail.com>
  <1235419343.4816.27.camel@gaiman> <200902232230.29501.rjw@sisk.pl>
  <8db1092f0902231340k7c7d0fd1me49302f2efd03491@mail.gmail.com>
  <86802c440902231701q1e169a67oa12bd84ac0e4c7aa@mail.gmail.com>
  <20090224032304.GA26344@hexapodia.org>
  <86802c440902232150m2b22e3cfg8993193f8867dfbf@mail.gmail.com>
  <20090224194432.GB28772@elte.hu> <49A44F0F.4060105@kernel.org>
  <20090224213907.GA12601@elte.hu> <1235511845.20084.2.camel@optimus>
 <alpine.LFD.2.00.0902241354220.3111@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902241354220.3111@localhost.localdomain>
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
>From: Linus Torvalds [mailto:torvalds@linux-foundation.org] 
>Sent: Tuesday, February 24, 2009 1:59 PM
>To: Dave Airlie
>Cc: Ingo Molnar; Yinghai Lu; H. Peter Anvin; Pallipadi, 
>Venkatesh; Siddha, Suresh B; Arjan van de Ven; Andy Isaacson; 
>Maciej Rutecki; Rafael J. Wysocki; Eric Anholt; Linux Kernel 
>Mailing List; Jesse Barnes; lenb@kernel.org; mjg@redhat.com; 
>Andrew Morton; Zhang, Rui
>Subject: Re: [Linux 2.6.29-rc6] [drm:i915_set_status_page] 
>*ERROR* can not ioremap virtual address for G33 hw status page
>
>
>
>On Wed, 25 Feb 2009, Dave Airlie wrote:
>> > 
>> > The other question is, why did the ioremap_wc() fail? Why doesnt 
>> > it fall back to UC transparently?
>>
>> I'm sort of worried the drivers are going to end up doing, which at
>> the moment is the only option that will work.
>> 
>> blah = ioremap_wc();
>> if (!blah)
>> 	blah = ioremap_nocache();
>> 
>> which seems pointless so this is a good point, where is the fallback?
>
>I agree.
>
>We should not fail the ioremap_wc(), we should just fall back 
>to nocache, 
>(possibly with a warning). In fact I thought we did exactly that, but 
>maybe it only happens in certain directions.
>

Yes. We do allow fallback from WC to UC in ioremap. Atleast the code is
intended to do that, unless there is a conflicting WB mapping to this region,
in which case we will fail ioremap_wc. But, that doesn't seem to be the case
as simple ioremap seems to go through without any error. Looking through this
code for any bugs...

Also, it will be interesting to look at pat_memtype_list in /debug/x86 when
ioremap_wc fails here..

Thanks,
Venki