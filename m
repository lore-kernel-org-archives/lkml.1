Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbZBYJC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbZBYJC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757106AbZBYJCF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:02:05 -0500
Received: from mga03.intel.com ([143.182.124.21]:20746 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbZBYJCC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:02:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,264,1233561600"; 
   d="scan'208";a="114179583"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Nathan Lynch <ntl@pobox.com>, Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "srostedt@redhat.com" <srostedt@redhat.com>
Date: Wed, 25 Feb 2009 09:01:50 +0000
Subject: RE: [patch 1/6] x86, ftrace, hw-branch-tracer: support hotplug cpus
Thread-Topic: [patch 1/6] x86, ftrace, hw-branch-tracer: support hotplug cpus
Thread-Index: AcmWyWNMrn0D4Y0iSmCKeD3WP/LL7wAXORRQ
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E4A4C1E88@irsmsx504.ger.corp.intel.com>
References: <20090119102653.A18774@sedona.ch.intel.com>
 <20090224193622.GA26734@elte.hu> <20090224154623.0758d692@thinkcentre.lan>
In-Reply-To: <20090224154623.0758d692@thinkcentre.lan>
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
>From: Nathan Lynch [mailto:ntl@pobox.com]
>Sent: Tuesday, February 24, 2009 10:46 PM
>To: Ingo Molnar
>Cc: Metzger, Markus T; linux-kernel@vger.kernel.org; tglx@linutronix.de; hpa@zytor.com;
>markus.t.metzger@gmail.com; srostedt@redhat.com
>Subject: Re: [patch 1/6] x86, ftrace, hw-branch-tracer: support hotplug cpus
>
>On Tue, 24 Feb 2009 20:36:22 +0100
>Ingo Molnar <mingo@elte.hu> wrote:
>
>>
>> * Markus Metzger <markus.t.metzger@intel.com> wrote:
>>
>> > Support hotplug cpus.
>>
>> > +static int __cpuinit bts_hotcpu_handler(struct notifier_block *nfb,
>> > +				     unsigned long action, void *hcpu)
>> > +{
>> > +	unsigned int cpu = (unsigned long)hcpu;
>> > +
>> > +	mutex_lock(&bts_tracer_mutex);
>>
>> This is buggy: CPU hotplug handlers must not sleep (they are
>> called with irqs disabled)
>
>I don't think that is the case; the cpu notifier chains are "raw", not
>atomic, and the cpu hotplug core doesn't disable irqs while processing
>the chains afaict.  And there are several current examples of cpu
>hotplug callbacks performing sleeping operations (slab and slub,
>page_alloc, probably many others).

The hotplug code uses mutexes around raw_notifier_call_chain() calls in
all but one case:
  For CPU_STARTING_FROZEN, the caller has interrupts disabled.

I guess I could check the notification reason before grabbing the lock
in the handler.

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

