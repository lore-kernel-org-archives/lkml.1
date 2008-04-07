Return-Path: <linux-kernel-owner+w=401wt.eu-S1756808AbYDGFbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756808AbYDGFbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 01:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbYDGFb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 01:31:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:16160 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975AbYDGFb2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 01:31:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,616,1199692800"; 
   d="scan'208";a="546749723"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Date: Sun, 6 Apr 2008 22:31:17 -0700
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEED0F279@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20080406205610.GA4647@localhost.ift.unesp.br>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Thread-Index: AciYKSyM1qS1zAgqT4qHLVjxmzbFnQARpwRg
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.AOB.6GW9HB@albercik> <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com> <20080404011053.GA21254@localhost.ift.unesp.br> <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com> <20080404114756.GA3890@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0EB77@orsmsx423.amr.corp.intel.com> <20080404155155.GA6578@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com> <20080406205610.GA4647@localhost.ift.unesp.br>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: "Ray Lee" <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Soeren Sonnenburg" <kernel@nn7.de>
X-OriginalArrivalTime: 07 Apr 2008 05:29:08.0453 (UTC) FILETIME=[4D874950:01C89870]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Carlos R. Mafra [mailto:crmafra2@gmail.com] 
>Sent: Sunday, April 06, 2008 1:56 PM
>To: Pallipadi, Venkatesh
>Cc: Ray Lee; Rafael J. Wysocki; Linux Kernel Mailing List; 
>Soeren Sonnenburg
>Subject: Re: 2.6.25-current-git hangs on boot unless 
>CONFIG_CPU_IDLE=n-Apple
>
>On Fri  4.Apr'08 at 13:41:45 -0700, Pallipadi, Venkatesh wrote:
>> [...]
>> >>> >I've uploaded the picture where it hangs, it is in the very 
>> >>beginning
>> >>> >of the boot process:
>> >>> >
>> >>> >http://www.ift.unesp.br/users/crmafra/dsc04673.jpg
>> >>> 
>> >>> 
>> >>> Can you try the latest git and see whether this still is 
>a problem?
>> >>
>> >>I've just updated to latest git, but it may take some time for it 
>> >>to happen again (the first 3 boots were okay). Last time 
>it happened
>> >>with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
>> >>
>> >>Do you have reasons to believe this issue was fixed since then?
>> >
>> >Yes. I think the patch here should have fixed the problem....
>> >Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4
>> >
>> 
>> Hmmmm.... Looking at latest git,
>> The above patch is not yet in git. Can you please apply the 
>above patch
>> and see whether do you still see the problem.....
>
>I applied Venkatesh's patch from the link above on top of 
>v2.6.25-rc8-139-ge315c12, but my laptop hung at the 11th boot with the
>same state show here:
>http://www.ift.unesp.br/users/crmafra/dsc04673.jpg
>
>I waited 3'30" but the boot process never resumed, so I pressed
>the power button.
>
>Any further patches I might try?

Carlos,

Hmm. So, we still have some bug hidden in there..
As this is similar to 10117, we should probably track this there.
10093 is a different cpuidle specific bug looks like, as it happens at a
different place while switching between governors.

Can you attach your kernel config, acpidump output and dmesg when kernel
boots ok to that bugzilla.
Also, if you can please try processor.max_cstate=2 boot option and see
whether you still can reproduce the problem. If you can, then try
processor.max_cstate=1. For this boot option to work, you have to have
ACPI_PROCESSOR built into your kernel (and should not be a module).

One more qn. Did you see this problem witj 2.6.24 as well or is this
something that you started seeing only recently?

Thanks,
VEnki
