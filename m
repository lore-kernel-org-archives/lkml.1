Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZBYOFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZBYOFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 09:05:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753151AbZBYOFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 09:05:45 -0500
Received: from mga14.intel.com ([143.182.124.37]:21198 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbZBYOFo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 09:05:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,265,1233561600"; 
   d="scan'208";a="114251542"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Airlie <airlied@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Eric Anholt <eric@anholt.net>, Thomas Gleixner <tglx@linutronix.de>,
       H Peter Anvin <hpa@zytor.com>, Keith Packard <keithp@keithp.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Feb 2009 06:06:59 -0800
Subject: RE: [patch 0/4] gpu/drm, x86, PAT: Add PAT support for	io_mapping_*
 interface
Thread-Topic: [patch 0/4] gpu/drm, x86, PAT: Add PAT support for
	io_mapping_* interface
Thread-Index: AcmXQdfGXO0ccOGKSG2PCUYnHxfGWQAEC55Q
Message-ID: <7E82351C108FA840AB1866AC776AEC464A6A209C@orsmsx505.amr.corp.intel.com>
References: <20090225013510.010493000@intel.com>
 <20090225120839.GC14279@elte.hu>
In-Reply-To: <20090225120839.GC14279@elte.hu>
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
>From: Ingo Molnar [mailto:mingo@elte.hu] 
>Sent: Wednesday, February 25, 2009 4:09 AM
>To: Pallipadi, Venkatesh; Linus Torvalds
>Cc: Dave Airlie; Jesse Barnes; Eric Anholt; Thomas Gleixner; H 
>Peter Anvin; Keith Packard; linux-kernel@vger.kernel.org
>Subject: Re: [patch 0/4] gpu/drm, x86, PAT: Add PAT support 
>for io_mapping_* interface
>
>
>* Venkatesh Pallipadi <venkatesh.pallipadi@intel.com> wrote:
>
>> io_mapping_create_wc(), io_mapping_free() and associated 
>map/unmap routines
>> are relatively new set of APIs for drivers, that change memory type.
>> 
>> Currently, these interfaces hardcode WC type on x86 and does 
>not go through
>> "PAT enforcement". This patchset adds PAT support for this interface.
>> 
>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
>
>hm, the patches look sane and clean and mostly factor out 
>existing code and checks and apply them to the io_mapping_*() 
>interfaces - so it's something worth having for .29.
>
>But it's all rather awfully late in the cycle and ioremap type 
>of bugs typically have 1-2 rc's of latency to be fully 
>discovered.
>
>They will probably fix a few regressions and are easy to revert, 
>plus they affect the one driver whose authors wrote these 
>facilities:
>
>  drivers/gpu/drm/i915/i915_dma.c
>  drivers/gpu/drm/i915/i915_gem.c
>
>so maybe we should try it as it's all a clear step forward. I'll 
>give them a spin in tip:x86/urgent. Dunno.
>

Actual PAT support (patch 3 and 4) can probably wait until .30. As
there is only one user of this interface. Patch 1 and 2 are more in
bugfix category and probably considered for .29.

Thanks,
Venki