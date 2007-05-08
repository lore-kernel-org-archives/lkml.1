Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbXEHNPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbXEHNPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 09:15:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966235AbXEHNPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 09:15:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:8745 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246AbXEHNPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 09:15:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,505,1170662400"; 
   d="scan'208";a="240693492"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] x86-64 highres/dyntick support
Date: Tue, 8 May 2007 06:15:38 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F55DF147@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070508095130.GY3505@sequoia.sous-sol.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86-64 highres/dyntick support
thread-index: AceRVnp9mgh9k/FsTDWjqUbumgbdAgAHFDxQ
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Chris Wright" <chrisw@sous-sol.org>,
       "Thomas Gleixner" <tglx@linutronix.de>
CC: "LKML" <linux-kernel@vger.kernel.org>, "john stultz" <johnstul@us.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Arjan van de Ven" <arjan@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>
X-OriginalArrivalTime: 08 May 2007 13:15:38.0568 (UTC) FILETIME=[F88DA480:01C79172]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Chris Wright [mailto:chrisw@sous-sol.org] 
>Sent: Tuesday, May 08, 2007 2:52 AM
>To: Thomas Gleixner
>Cc: Chris Wright; LKML; Pallipadi, Venkatesh; john stultz; 
>Ingo Molnar; Arjan van de Ven; Steven Rostedt; Andi Kleen; 
>Andrew Morton
>Subject: Re: [PATCH] x86-64 highres/dyntick support
>
>* Thomas Gleixner (tglx@linutronix.de) wrote:
>> On Tue, 2007-05-08 at 02:39 -0700, Chris Wright wrote:
>> 
>> > OK, looks very similar all things considered.  One thing I 
>didn't do
>> > was fix lapic timer calibration (was hoping you'd do that 
>part, and you
>> > did ;-)  I've noticed that something has changed and I'm 
>seeing irq0
>> > handled on cpu3 (4 cpu system), where it used to be on 
>cpu0 as expected.
>> 
>> Strange, irq balancing ?
>
>That's what I was wondering, although i have same setup for 32-bit
>and it behaves as expected with cpu0 taking hpet or pit on irq0
>and lapic timer picked up on the other 3 cpus.
>

Yes. Looks like irq balancing issue. On i386 I see irq has flag
IRQF_NOBALANCING, but x86-64 does not have this flag. Can you add that
and check whether that makes any difference.

Thanks,
Venki
