Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbZBRR3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbZBRR3A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 12:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753442AbZBRR2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 12:28:51 -0500
Received: from mga14.intel.com ([143.182.124.37]:23736 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbZBRR2u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 12:28:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,230,1233561600"; 
   d="scan'208";a="111928384"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: "'Ingo Molnar'" <mingo@elte.hu>,
       "'Linus Torvalds'" <torvalds@linux-foundation.org>
CC: "'David Woodhouse'" <dwmw2@infradead.org>,
       "'Stephen Rothwell'" <sfr@canb.auug.org.au>,
       "'iommu@lists.linux-foundation.org'" 
	<iommu@lists.linux-foundation.org>,
       "'LKML'" <linux-kernel@vger.kernel.org>
Date: Wed, 18 Feb 2009 09:28:44 -0800
Subject: RE: [PATCH] Suspend and Resume Support for Intel IOMMU
Thread-Topic: [PATCH] Suspend and Resume Support for Intel IOMMU
Thread-Index: AcmR7R9CRYKQMlpjQEq29qpy5FRTJQAAGA2w
Message-ID: <A6AD88C3F2289247BE726C37303E1EB894F11D64@orsmsx505.amr.corp.intel.com>
References: <20090218165633.GA20167@linux-os.sc.intel.com>
 <alpine.LFD.2.00.0902180910160.21686@localhost.localdomain>
 <20090218171935.GA14625@elte.hu>
In-Reply-To: <20090218171935.GA14625@elte.hu>
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


>> On Wed, 18 Feb 2009, Fenghua Yu wrote:
>> >
>> > +static int vtd_enabled;
>> ..
>> > +static int iommu_resume(struct sys_device *dev)
>> > +{
>> ..
>> > +	if (!vtd_enabled)
>> > +		return 0;
>> 
>> Hmm. Why do this?
>> 
>> Wouldn't it be much more logical to only register the 
>> iommu_sysdev if the thing is enabled, rather than having an 
>> odd flag that gets tested at runtime?
>
>The sysdev_class_register() could be done straight in 
>intel_iommu_init(), because that gets called by pci_iommu_init() 
>which is an fs_initcall() - so all the sysdev facilities should 
>be up and running already.

That was my original concern. I'll remove the vtd_enabled flag and
register device_iommu in intel_iommu_init() in an updated patch.

Thanks.

-Fenghua

