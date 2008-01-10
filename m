Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbYAJRwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbYAJRwx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 12:52:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbYAJRwq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 12:52:46 -0500
Received: from mga03.intel.com ([143.182.124.21]:39303 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270AbYAJRwo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 12:52:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,267,1196668800"; 
   d="scan'208";a="363638452"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
Date: Thu, 10 Jan 2008 09:31:39 -0800
Message-ID: <924EFEDD5F540B4284297C4DC59F3DEE5A2710@orsmsx423.amr.corp.intel.com>
In-Reply-To: <Pine.LNX.4.58.0801100936320.6420@gandalf.stny.rr.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
Thread-Index: AchTl9erSnnjP4yoRk27EGwGeDS9SwAFlSfw
References: <1199759244.26343.35.camel@localhost.localdomain> <20080108033329.GI2998@bingen.suse.de> <1199911330.975.3.camel@localhost.localdomain> <1199916725.975.6.camel@localhost.localdomain> <20080110134539.GD5886@elte.hu> <Pine.LNX.4.58.0801100936320.6420@gandalf.stny.rr.com>
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Brown, Len" <len.brown@intel.com>, "Adam Belay" <abelay@novell.com>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>, "Andi Kleen" <ak@suse.de>
X-OriginalArrivalTime: 10 Jan 2008 17:30:49.0705 (UTC) FILETIME=[8ABBFD90:01C853AE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: linux-kernel-owner@vger.kernel.org 
>[mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Steven Rostedt
>Sent: Thursday, January 10, 2008 6:44 AM
>To: Ingo Molnar
>Cc: LKML; Linus Torvalds; Andrew Morton; Thomas Gleixner; 
>Brown, Len; Pallipadi, Venkatesh; Adam Belay; Peter Zijlstra; 
>Andi Kleen
>Subject: Re: [PATCH] Kick CPUS that might be sleeping in cpus_idle_wait
>
>
>
>On Thu, 10 Jan 2008, Ingo Molnar wrote:
>> > FYI, I just hit this hang on 2.6.24-rc6 without any extra 
>patches. So,
>> > unless 2.6.24-rc7 did anything to fix this issue, this is a high
>> > priority bug (IMHO).
>>
>> i'm wondering why this only triggered now. Is this something new in
>> 2.6.24?
>
>It only triggeres with the switching of the idle governors. 
>And not just
>one, you need to switch twice. The first loading of a governor does not
>call cpu_idle_wait, but the second one does. NO_HZ must also 
>be enabled,
>plus this needs to happen when no events or threads are 
>scheduled to run
>on a CPU, which limits this to boot up.
>
>Also, this only seems to happen on my 2x2 (4way) and only once 
>in a while.
>
>I'm surprised that I'm the only one so far to report it. I can 
>boot up the
>2.6.23 kernel on this box to see if it also hangs sometimes. But, as I
>said, it may take several hundreds of tries to see it.


With 2.6.23, you can try compiling acpi processor.ko as a module and
doing insmod and rmmod in a loop. That should call cpu_idle_wait very
frequently.

Thanks,
Venki
