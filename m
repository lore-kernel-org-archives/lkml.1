Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbZFIMuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbZFIMuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 08:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbZFIMt6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 08:49:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:44736 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbZFIMt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 08:49:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,331,1241420400"; 
   d="scan'208";a="697763080"
From: "Pan, Jacob jun" <jacob.jun.pan@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "Tang, Feng" <feng.tang@intel.com>, "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>
Date: Tue, 9 Jun 2009 05:49:58 -0700
Subject: RE: [PATCH] tick: add check for the existence of broadcast clock
 event device
Thread-Topic: [PATCH] tick: add check for the existence of broadcast clock
 event device
Thread-Index: Acno2vfz7sldVO0vQnqWli+mtrNYggAJVqJg
Message-ID: <43F901BD926A4E43B106BF17856F075563408766@orsmsx508.amr.corp.intel.com>
References: <20090605112711.67e7d5cb@feng-desktop>
 <alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
 <20090606204736.00700bd0@feng-desktop>
 <alpine.LFD.2.00.0906061450220.3419@localhost.localdomain>
 <alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
 <20090608095730.0c945e78@feng-desktop>
 <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain>
 <20090608141250.6a5735fa@feng-desktop>
 <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain>
 <20090608144740.62f2ed95@feng-desktop>
 <alpine.LFD.2.00.0906080857260.3419@localhost.localdomain>
 <EADF0A36011179459010BDF5142A457501C9CD39CC@pdsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.00.0906081109080.3419@localhost.localdomain>
 <43F901BD926A4E43B106BF17856F07556340868E@orsmsx508.amr.corp.intel.com>
 <alpine.LFD.2.00.0906091014110.3351@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906091014110.3351@localhost.localdomain>
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

Thanks for the explanations, I will add the secondary clock code to the
 x86_quirks. It should be submitted for review soon.

Jacob

>-----Original Message-----
>From: Thomas Gleixner [mailto:tglx@linutronix.de]
>Sent: Tuesday, June 09, 2009 1:19 AM
>To: Pan, Jacob jun
>Cc: Tang, Feng; mingo@elte.hu; linux-kernel@vger.kernel.org; Li, Shaohua
>Subject: RE: [PATCH] tick: add check for the existence of broadcast clock event
>device
>
>On Mon, 8 Jun 2009, Pan, Jacob jun wrote:
>> >I understand that, but HPET does not rely on some magic events
>> >happening. That's what I'm worried about. The boot code is fragile and
>> >I prefer some explicit setup call over a fragile solution which
>> >happens to work.
>> >
>> >There is not much to complain about a platform specific function call
>> >to set up special devices if there is a requirement for a call order.
>> >
>> >In fact you can avoid setting up the local APIC timer at all. So what
>> >you want is something like the patch below. You can set the
>> >setup_secondary_clock pointer in the quirks structure when you detect
>> >that you are running on such a system.
>> >
>
>> [[JPAN]] Hi Thomas, I have been developing the APB timer driver as
>> Feng mentioned, thank you for the suggestions.  I agree with you
>> that direct setting up secondary clockevent is a better solution.
>> But maybe I misunderstand the HPET code, isn't it true that per CPU
>> HPET timer also rely on IPI? In hpet_cpuhp_notify().
>
>Well the difference is, that the HPET setup always has a functional
>clock event device (local APIC + the broadcast fallback) and it does
>not depend on that IPI to make progress.
>
>> Also for using x86_quirks, I think the default quirks are more
>> generic in the sense of x86 platform, but here we are really
>> choosing timer device, so can we switch based on availability of the
>> timer devices instead of quirks? Otherwise, if more platforms share
>> the same setup_secondary_clock() quirk, we would have to check for
>> timer devices anyway.
>
>The quirks mechanism is exactly the right thing. It provides platforms
>and I consider your system a platform which has neither PIT nor HPET a
>mechanism to override the default implementation. And overriding the
>default local APIC timer setup is exaclty what you want to do.
>
>Thanks,
>
>	tglx
