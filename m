Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZGCO2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZGCO2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbZGCO2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:28:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:62095 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbZGCO2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:28:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,342,1243839600"; 
   d="scan'208";a="529973609"
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Dave Jones <davej@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
       "kernel-testers@vger.kernel.org" <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dave Young <hidave.darkstar@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Thomas Renninger <trenn@suse.de>
Date: Fri, 3 Jul 2009 07:31:12 -0700
Subject: RE: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
Thread-Topic: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
Thread-Index: Acn7qyIPwRczQhuMSsy7beQIMILLMwAP3Rjg
Message-ID: <7E82351C108FA840AB1866AC776AEC4669BFF052@orsmsx505.amr.corp.intel.com>
References: <20090703000829.735976000@intel.com>
 <20090703065427.GA32687@elte.hu>
In-Reply-To: <20090703065427.GA32687@elte.hu>
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
>Sent: Thursday, July 02, 2009 11:54 PM
>To: Pallipadi, Venkatesh
>Cc: Dave Jones; linux-kernel@vger.kernel.org; 
>cpufreq@vger.kernel.org; kernel-testers@vger.kernel.org; 
>Rafael J. Wysocki; Dave Young; Pekka Enberg; Mathieu 
>Desnoyers; Thomas Renninger
>Subject: Re: [patch 0/4] Take care of cpufreq lockdep issues (take 2)
>
>
>* venkatesh.pallipadi@intel.com <venkatesh.pallipadi@intel.com> wrote:
>
>> Since recent chanegs to ondemand and conservative governor, there 
>> have been multiple reports of lockdep issues in cpufreq. Patch 
>> series takes care of these problems.
>> 
>> This is the next attempt following the one here, which was not a 
>> complete fix. 
>> http://lkml.indiana.edu/hypermail/linux/kernel/0906.3/01073.html
>> 
>> I am currently running some stress tests to make sure there are no 
>> issues with these patches. But, wanted to send them out for 
>> review/comments/testing before I head out for the long weekend.
>> 
>> If this patchset seems sane, the first patch in the patchset 
>> should also get into 30.stable.
>
>Btw., FYI, because my test-systems were frequently triggering those 
>bugs, i kept testing the following series from you and Mathieu in 
>-tip:
>
> ecf8b04: cpufreq: Define dbs_mutex purpose and cleanup its 
>usage conservative gov
> b08c597: cpufreq: Define dbs_mutex purpose and cleanup its usage
> 0807e30: cpufreq: remove rwsem lock from CPUFREQ_GOV_STOP 
>call (second call site)
>
>So that fix-series, while probably not complete (given that you sent 
>a v2 series), worked well in practice and gets my:
>
> Tested-by: Ingo Molnar <mingo@elte.hu>
>
>Is the delta between this (tested) series and your v2 version 
>significant? If not it might make sense to shape it as a delta patch 
>to the v1 series, if that looks clean enough - to preserve testing 
>results.
>

Thanks for testing. That earlier version even though it took care
of lockdep complaints, did not address all the race conditions properly.
The delta is significant as I had to change the approach compared
to first patchset. So, diff will not be very clean.

Thanks,
Venki