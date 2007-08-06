Return-Path: <linux-kernel-owner+w=401wt.eu-S933401AbXHFNbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401AbXHFNbY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 09:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933107AbXHFNW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 09:22:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:53825 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933094AbXHFNWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 09:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,224,1183359600"; 
   d="scan'208";a="114143926"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Date: Mon, 6 Aug 2007 21:22:46 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC2437517@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <20070806090210.GA15329@atrey.karlin.mff.cuni.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATH 0/1] Kexec jump - v2 - the first step to kexec based hibernation
Thread-Index: AcfYCHzv5YzKK5XmSsW0YN+vu3WsaAAI2r8g
From: "Huang, Ying" <ying.huang@intel.com>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, <nigel@nigel.suspend2.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>,
       "Alan Stern" <stern@rowland.harvard.edu>,
       "Andrew Morton" <akpm@linux-foundation.org>, <david@lang.hm>,
       <linux-kernel@vger.kernel.org>, <linux-pm@lists.linux-foundation.org>,
       "Kexec Mailing List" <kexec@lists.infradead.org>
X-OriginalArrivalTime: 06 Aug 2007 13:22:49.0316 (UTC) FILETIME=[E27A1240:01C7D82C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Pavel Machek [mailto:pavel@ucw.cz]
>> > Did the trick, I got the kernel to load, and it even attempted
>> > exec... but I got doublefault (or what is it?)
>> >
>> > Int 6: ... EIP: c4739906. Address is in reserve_bootmem_core.
>> >
>> > Do I have to disable ACPI completely? I tried with acpi=off,
>> > nosmp... but problem does not seem device related.
>>
>> It seems that the problem has nothing to do with device or ACPI. Can
you
>> do a normal kexec? That is:
>>
>> kexec -l <...>
>> kexec -e
>>
>> or
>>
>> kexec -p <...>
>> ALT-SysRq-c to trigger a crash dump.
>
>...that was indeed a problem. I can do successful kexec, as long as I
>load bzImage (and not vmlinux). (Both kernels 2.6.22 and
>2.6.23-rc2-git). Problem is, I can only load bzImage using -l, attempt
>to load bzImage using -p results in
>
>"Could not find a free area of memory of 9000 bytes"
>locate_hole failed
>
>. Any ideas?

The Kexec-tools 1.101 can not deal with bzImage with "-p" properly. So
vmlinux must be used with "-p". And the tricks previous mentioned must
be used for normal kexec -p too. The example command line is as follow:

kexec -p --args-linux vmlinux --append="root=/dev/<xxx> ..."

Best Regards,
Huang Ying
