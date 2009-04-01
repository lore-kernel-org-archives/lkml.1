Return-Path: <linux-kernel-owner+w=401wt.eu-S1759484AbZDAMoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484AbZDAMoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759482AbZDAMoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:44:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:49244 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757933AbZDAMoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:44:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,306,1235980800"; 
   d="scan'208";a="677803480"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>
Date: Wed, 1 Apr 2009 13:43:26 +0100
Subject: RE: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Thread-Topic: [patch 3/21] x86, bts: wait until traced task has been
	scheduled out
Thread-Index: Acmyvt0R+xcMM6pLSXOryf87tbkbLgACClaA
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E926D537D@irsmsx504.ger.corp.intel.com>
References: <20090331145947.A12565@sedona.ch.intel.com>
 <20090401001729.GC28228@redhat.com> <20090401114140.GB23678@elte.hu>
In-Reply-To: <20090401114140.GB23678@elte.hu>
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
>Sent: Wednesday, April 01, 2009 1:42 PM
>To: Oleg Nesterov; Peter Zijlstra


>* Oleg Nesterov <oleg@redhat.com> wrote:
>
>> On 03/31, Markus Metzger wrote:
>> >
>> > +static void wait_to_unschedule(struct task_struct *task)
>> > +{
>> > +	unsigned long nvcsw;
>> > +	unsigned long nivcsw;
>> > +
>> > +	if (!task)
>> > +		return;
>> > +
>> > +	if (task == current)
>> > +		return;
>> > +
>> > +	nvcsw  = task->nvcsw;
>> > +	nivcsw = task->nivcsw;
>> > +	for (;;) {
>> > +		if (!task_is_running(task))
>> > +			break;
>> > +		/*
>> > +		 * The switch count is incremented before the actual
>> > +		 * context switch. We thus wait for two switches to be
>> > +		 * sure at least one completed.
>> > +		 */
>> > +		if ((task->nvcsw - nvcsw) > 1)
>> > +			break;
>> > +		if ((task->nivcsw - nivcsw) > 1)
>> > +			break;
>> > +
>> > +		schedule();
>>
>> schedule() is a nop here. We can wait unpredictably long...
>>
>> Ingo, do have have any ideas to improve this helper?
>
>hm, there's a similar looking existing facility:
>wait_task_inactive(). Have i missed some subtle detail that makes it
>inappropriate for use here?


wait_task_inactive() waits until the task is no longer TASK_RUNNING.

I need to wait until the task has been scheduled out at least once.


regards,
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

