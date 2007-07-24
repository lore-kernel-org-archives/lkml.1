Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbXGXOAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbXGXOAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 10:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbXGXOAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 10:00:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:31340 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbXGXOAK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 10:00:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,574,1175497200"; 
   d="scan'208";a="109331229"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Tue, 24 Jul 2007 22:00:04 +0800
Message-ID: <9D7649D18729DE4BB2BD7B494F7FEDC236CF66@pdsmsx415.ccr.corp.intel.com>
In-Reply-To: <200707151249.26148.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Thread-Index: AcfGzL1SyZBkItdgQLaxf3fOlZwe7QHLOEpQ
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Pavel Machek" <pavel@ucw.cz>, <nigel@nigel.suspend2.net>,
       "Jeremy Maitin-Shepard" <jbms@cmu.edu>, <linux-kernel@vger.kernel.org>,
       <linux-pm@lists.linux-foundation.org>,
       "Kexec Mailing List" <kexec@lists.infradead.org>
X-OriginalArrivalTime: 24 Jul 2007 14:00:06.0690 (UTC) FILETIME=[F0AF8020:01C7CDFA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>This is not the point.  There are memory regions that you should not
_restore_,
>because that will cause harm.
>
>> On x86_64, there is another usage of nosave during processing E820
>> memory map. But I don't know why the memory region other than
E820_RAM
>> are marked as nosave. I think only the memory region of type E820_RAM
>> will be thought of normal memory, others will be thought as reserved.
Is
>> it sufficient just to check whether the page is reserved?
>
>No, it's not.

The "/proc/iomem" records information of all memory regions including
"normal RAM" and all kinds of reserved regions, which is backed by
iomem_resource. On x86_64, it is initialized in the exact same way as
nosave region initialization.

I think maybe we can replace the "nosave region" concepts with
"iomem_resource" (maybe need some enhancement).

Best Regards,
Huang Ying
