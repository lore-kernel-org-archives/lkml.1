Return-Path: <linux-kernel-owner+w=401wt.eu-S1761060AbZBYLtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761060AbZBYLtn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 06:49:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752979AbZBYLtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 06:49:35 -0500
Received: from mga14.intel.com ([143.182.124.37]:10448 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbZBYLte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 06:49:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,264,1233561600"; 
   d="scan'208";a="114219579"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 25 Feb 2009 11:49:19 +0000
Subject: RE: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
	convert bts-tracer mutex to a spinlock
Thread-Topic: [tip:tracing/hw-branch-tracing] tracing/hw-branch-tracing:
	convert bts-tracer mutex to a spinlock
Thread-Index: AcmXPp8t7PrY/rYEQ1OtLfBfEtt0LQAABDIg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A4C2006@irsmsx504.ger.corp.intel.com>
References: <tip-2d542cf34264ac92e9e7ac55c0b096b066d569d2@kernel.org>
 <928CFBE8E7CB0040959E56B4EA41A77E4A4C1EF6@irsmsx504.ger.corp.intel.com>
 <20090225095814.GC12352@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A4C1F31@irsmsx504.ger.corp.intel.com>
 <20090225111116.GB15453@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77E4A4C1FE3@irsmsx504.ger.corp.intel.com>
 <20090225114542.GA14279@elte.hu>
In-Reply-To: <20090225114542.GA14279@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: Ingo Molnar [mailto:mingo@elte.hu]
>Sent: Wednesday, February 25, 2009 12:46 PM
>To: Metzger, Markus T


>> I suggested to use get/put_online_cpus() instead of the lock.
>>
>> The hotplug code waits until the cpu_hotplug.refcount is zero
>> and it holds the cpu_hotplug.lock during hotplug operations
>> (see cpu_hotplug_begin/done()).
>>
>> In turn, get_online_cpus() needs to grab the cpu_hotplug.lock
>> to increment the cpu_hotplug.refcount.
>>
>> Thus, we will use the cpu_hotplug.lock instead of our own lock.
>
>... which, if you use it in the exact same spots as now still
>does a potential sleep with irqs disabled => bad.

We don't need to get_online_cpus() in the hotplug handler;
actually, we must not.


>We might be able to not take the hotplug lock in the affected
>codepath, but we should really not expand on the use of that
>lock and should make this code self-sufficient.

You're right. An own spinlock is definitely safer and much
easier to understand.


thanks and regards,
markus.

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

