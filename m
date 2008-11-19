Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYKSPry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYKSPry (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 10:47:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752805AbYKSPrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 10:47:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:54220 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752645AbYKSPrq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 10:47:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,631,1220252400"; 
   d="scan'208";a="464925486"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "eranian@gmail.com" <eranian@gmail.com>
CC: Markus Metzger <markus.t.metzger@googlemail.com>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 19 Nov 2008 15:47:39 +0000
Subject: RE: debugctl msr
Thread-Topic: debugctl msr
Thread-Index: AclKRq9MHkmkftoHQqKUjTEzXoM12wAEGonw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <491A812D.9010208@gmail.com>
	 <7c86c4470811120210j2ea5ccdcv59a654aadc32ebd2@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
In-Reply-To: <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
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
>From: stephane eranian [mailto:eranian@googlemail.com] 
>Sent: Mittwoch, 19. November 2008 14:00
>To: Metzger, Markus T
>Cc: Markus Metzger; Ingo Molnar; Andi Kleen; Andrew Morton; 
>linux-kernel@vger.kernel.org
>Subject: Re: debugctl msr
>

>I had to hack ds.c some more to make forward progress with PEBS. First
>of all my PEBS code is
>in a kernel module, so all PEBS functions have to be exported.
>Furhtermore, I need a
>ds_get_pebs_thres() and ds_set_pebs_thres() calls.

I'm having a deja vu. We had this discussion before. You reported those
issues and I fixed them. Same for the PEBS size; and Andi Kleen asked
to exclude ds.c from the build instead of guarding the .c file and to
use the mm semaphore in ds_allocate_buffer().

That thread ended in the multiplexing discussion and my fixes never got in.
I'll send a patch covering those problems next week.


Regarding access to the interrupt threshold, we never completed
our discussion.
If we look towards multiplexing, ds.c has to handle interrupts and
copy the trace to the various users - at least for BTS.
I will pull some of the BTS handling from ptrace into ds.c - ds.c needs
to be able to disable BTS recording for overflow handling and we would
not want this knowledge in two different places.

I would add those functions now to proceed with the perfmon2 adaptation
and later remove them again and put overflow handling into ds.c

I'll send a separate patch for those.


>But the one key problem is ds_validate_access(). I had to disable this
>function.

I agree that this is too ptrace centric.

It works fine for the ptrace bts extenstion since ptrace has similar
restrictions, already.

A better choice would be to return an opaque handle.


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

