Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYI0Ewk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYI0Ewk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 00:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYI0Ewc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 00:52:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:37758 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbYI0Ewc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 00:52:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,318,1220252400"; 
   d="scan'208";a="341159553"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "akataria@vmware.com" <akataria@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Date: Fri, 26 Sep 2008 21:52:26 -0700
Subject: RE: Use CPUID to communicate with the hypervisor.
Thread-Topic: Use CPUID to communicate with the hypervisor.
Thread-Index: AckgRKduvtgtfnISSUq97JyT2CDOugACzTOA
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A1571841FE@orsmsx505.amr.corp.intel.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48DD799C.3070706@zytor.com> <1222475403.29886.57.camel@alok-dev1>
 <48DD7F1A.4060703@zytor.com>
 <0B53E02A2965CE4F9ADB38B34501A3A15718417A@orsmsx505.amr.corp.intel.com>
 <48DD92AA.4050900@zytor.com>
In-Reply-To: <48DD92AA.4050900@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m8R4qldq020226

On 9/26/2008 6:55:54 PM, H. Peter Anvin wrote:
> Nakajima, Jun wrote:
> > > >
> > > Agreed.  However, that's obviously beyond our immediate control.
> >
> > Well, actually it's under full control of the Linux community
> > because the _kernel_ defines such virtual or semi-hardware features.
> > I'm not sure if that particular value (0x40000010) is proper, but we
> > should be able to pick reasonable ones/ranges.
> >
>
> Uhm, no, they're defined by the _hypervisor_.
>
>         -hpa

Obviously the hypervisor implements such features, and the features available/exposed are up to the hypervisor. My point is that the kernel community can define such generic hypervisor features for Linux because the Linux kernel code needs to be modified anyway. Otherwise, each VMM vender could start changing the kernel in a random fashion. Or nothing happens...

Today each hypervisor already defines and implements such features (or API), and they would need some kind of translation layer to support such Linux hypervisor features (if defined) or they just need to write code.

Having said that,
+       if (cpu_has_hypervisor) {
+               max_cpuid_leaf = cpuid_eax(HYPERVISOR_INFO_LEAF);
+               if (max_cpuid_leaf >= HYPERVISOR_TIMING_LEAF) {
+                       tsc_khz = cpuid_eax(HYPERVISOR_TIMING_LEAF);
+                       printk(KERN_INFO
+                               "TSC frequency read from hypervisor\n");
+                       return tsc_khz;

To have more flexibility and extendability in terms of "supported/unsupported", I think we should use the bitmap first to detect the features as the native does. For example, some hypervisor does not want to implement HYPERVISOR_TIMING_LEAF, but want to implement something higher one (which could be defined in the future).


             .
Jun Nakajima | Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
