Return-Path: <linux-kernel-owner+w=401wt.eu-S1751795AbXEYAAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbXEYAAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 20:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbXEYAAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 20:00:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:6846 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbXEYAAN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 20:00:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,575,1170662400"; 
   d="scan'208";a="90298772"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Date: Thu, 24 May 2007 17:00:11 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5EE12ED@scsmsx415.amr.corp.intel.com>
In-Reply-To: <46561E55.7090107@zytor.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Display Intel Dynamic Acceleration feature in /proc/cpuinfo
Thread-Index: AceeWoFcI5gNMFjhTAuDmsDz3PHeBgAA8dSg
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Andi Kleen" <ak@suse.de>, "Dave Jones" <davej@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Brown, Len" <len.brown@intel.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 25 May 2007 00:00:12.0342 (UTC) FILETIME=[AA873D60:01C79E5F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com] 
>Sent: Thursday, May 24, 2007 4:23 PM
>To: Pallipadi, Venkatesh
>Cc: Andi Kleen; Dave Jones; Andrew Morton; Brown, Len; linux-kernel
>Subject: Re: [PATCH] Display Intel Dynamic Acceleration 
>feature in /proc/cpuinfo
>
>Pallipadi, Venkatesh wrote:
>> 
>> Yes. But it only has 3 features defined right now. 2 in EAX 
>and one in
>> ECX. Should I use 2 new words for these bits or just use the software
>> defined bits as in my earlier patch?
>> 
>
>Oh for heaven's sake.  Could you please do the world a favour and shoot
>your CPUID architect?
>
>The real answer depends on how you expect it to grow in the future.
>Intel has a piss-poor record at being consistent in this matter, which
>speaks for a more ad hoc approach, but if there really is a sane growth
>path going forward, then go ahead and define two new words.
>

The way new Intel features are being exposed in CPUID is kind of
changing.
Now we have different CPUID leafs for different kind of features with
each of them growing much slowly.
I mean, there is
monitor-mwait related features in CPUID 5
powermanagement features in CPUID 6 EAX, ECX
Perfmon features in CPUID 10

This does not fit well with the way we use the feature words in Linux.
Probably
it is better to have one new word for new Intel features and add bits
from all
CPUIDs as they come. I will take a look at all the other fields and try
for
a better solution than adding new words for different CPUIDs like above.

Thanks,
Venki
