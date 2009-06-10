Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbZFJNX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbZFJNX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755749AbZFJNXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:23:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:55962 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbZFJNXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:23:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,341,1241420400"; 
   d="scan'208";a="420485019"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Date: Wed, 10 Jun 2009 14:22:40 +0100
Subject: RE: [tip:tracing/core] x86, bts: reenable ptrace branch trace
	support
Thread-Topic: [tip:tracing/core] x86, bts: reenable ptrace branch trace
	support
Thread-Index: Acnpyiap/omPA/1VRNWDsVXyrlv40gAArXOg
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EBBC651E2@irsmsx504.ger.corp.intel.com>
References: <20090424094448.A30216@sedona.ch.intel.com>
 <tip-7e0bfad24d85de7cf2202a7b0ce51de11a077b21@git.kernel.org>
 <1244637843.13761.11786.camel@twins> <20090610125108.GA13506@elte.hu>
In-Reply-To: <20090610125108.GA13506@elte.hu>
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
>Sent: Wednesday, June 10, 2009 2:51 PM
>To: Peter Zijlstra
>Cc: mingo@redhat.com; hpa@zytor.com; linux-kernel@vger.kernel.org; Metzger, Markus T;
>tglx@linutronix.de; oleg@redhat.com; linux-tip-commits@vger.kernel.org
>Subject: Re: [tip:tracing/core] x86, bts: reenable ptrace branch trace support
>
>
>* Peter Zijlstra <peterz@infradead.org> wrote:
>
>> On Thu, 2009-05-07 at 09:25 +0000, tip-bot for Markus Metzger wrote:
>> > Commit-ID:  7e0bfad24d85de7cf2202a7b0ce51de11a077b21
>> > Gitweb:     http://git.kernel.org/tip/7e0bfad24d85de7cf2202a7b0ce51de11a077b21
>> > Author:     Markus Metzger <markus.t.metzger@intel.com>
>> > AuthorDate: Fri, 24 Apr 2009 09:44:48 +0200
>> > Committer:  Ingo Molnar <mingo@elte.hu>
>> > CommitDate: Fri, 24 Apr 2009 10:18:51 +0200
>> >
>> > x86, bts: reenable ptrace branch trace support
>> >
>> > The races found by Oleg Nesterov have been fixed.
>> >
>> > Reenable branch trace support.
>> >
>> > Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
>> > Acked-by: Oleg Nesterov <oleg@redhat.com>
>> > LKML-Reference: <20090424094448.A30216@sedona.ch.intel.com>
>> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
>>
>> OK, this whole BTS thing worries me because it seems to expose too
>> much of the Intel Debug Store thingy to the outside world.
>>
>> The thing is, once we do PEBS from inside the kernel, we'll have
>> to share the debug store, and the way this thing sets it up isn't
>> really going to work.
>>
>> So what I'd like to see is having this debug store removed from
>> the interface and abstracted away as cpu resource -- a single page
>> when in use should suffice I think.
>>
>> If you want to expose a buffer to userspace, use the regular
>> mmap() interface and fill those pages from the DS interrupt
>> handler.
>
>hm, that makes sense indeed. We are in the merge window now -
>Markus, what's your suggestion?

The Debug Store interface is completely in-kernel. It does not expose
anything to the outside world.

What we expose is a ptrace interface for branch tracing.
That this is built on top of Debug Store is completely hidden.
The Debug Store interface may be changed without impacting the
user-visible part at any time.

I do think that a ptrace interface makes sense since debuggers are the
targeted users for branch tracing.

I don't see why we should not merge the fixes now and then rework the
in-kernel parts as needed for supporting PEBS.


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

