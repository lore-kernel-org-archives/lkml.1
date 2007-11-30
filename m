Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbXK3Wmn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbXK3Wmn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 17:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbXK3Wm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 17:42:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:61089 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752768AbXK3Wm1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 17:42:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,236,1194249600"; 
   d="scan'208";a="219248780"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Date: Fri, 30 Nov 2007 14:37:46 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE2FAEAF@orsmsx423.amr.corp.intel.com>
In-Reply-To: <20071130142058.816d1693.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: + restore-missing-sysfs-max_cstate-attr.patch added to -mm tree
Thread-Index: Acgzn5T8e8/KH4cCSgWNyjFp3ve8FAAAJW2Q
References: <200711302153.lAULrZ7n026255@imap1.linux-foundation.org><924EFEDD5F540B4284297C4DC59F3DEE2FAE6A@orsmsx423.amr.corp.intel.com> <20071130142058.816d1693.akpm@linux-foundation.org>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <lkml@rtr.ca>, <abelay@novell.com>, <lenb@kernel.org>, <mlord@pobox.com>,
       <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>,
       <linux-acpi@vger.kernel.org>
X-OriginalArrivalTime: 30 Nov 2007 22:37:30.0185 (UTC) FILETIME=[9756AB90:01C833A1]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>On Fri, 30 Nov 2007 14:06:55 -0800
>"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
>
>Please dont go off-list like this.  I put Mark's original 
>mailing list cc's
>back.

Sorry for missing some cc's earlier. I blindly did a reply-all to the
mm-commits mail I got.

>> I will have to Nack this. The reason max_cstate was initentionally
>> removed due to couple of reasons:
>
>It broke userspace without any warning or migration period, afaict.

Yes. That's true. I will have to take the blame for that. It has been
known for a while during cpuidle development. But, it was never
documented as deprecating.
 
>> 1) All in kernel users of max_cstate should rather be using
>> pm_qos/latency interfaces. All such max_cstate usages must already be
>> migrated.
>
>That code isn't merged.

All kernel part is already merged. I mean, there are do drivers that
depend on max_cstate. They use latency_notifier thing today and their
migration to pm_qos part is not merged yet.

>> 2) Supporting max_cstate as a dynamic parameter cleanly is no longer
>> possible in acpi/processor_idle.c as the C-state policy has moved to
>> cpuidle instead. It can be done if it is needed. But, just 
>below patch
>> will not really work with cpuidle.
>> 
>> Selecting max_cstate at boot time as a debug option still 
>works without
>> this patch.
>> 
>> So, just this patch will not get back the functionality with cpuidle.
>> Infact changing it at run time will have no effect. Question 
>however is:
>> Is there a real need to revive this parameter so that user can change
>> max_cstate at run time?
>
>It is not known whether Mark is actually writing to this 
>thing.  Perhaps
>read-only permissions would be a suitable fix?
>

Exporting it as read only should be OK. We also need to know if there
are hard user space dependency on writing to this from userspace.

Thanks,
Venki  
