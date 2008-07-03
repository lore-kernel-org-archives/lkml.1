Return-Path: <linux-kernel-owner+w=401wt.eu-S1752355AbYGCPhZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbYGCPhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 11:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbYGCPhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 11:37:10 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:16910 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbYGCPhI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 11:37:08 -0400
X-BigFish: VPS-40(zfe0i6f5iz542N1432R98dR7efV1805Mzzzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K3FSP1-04-XG8-01
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver:Setup routines
Date: Thu, 3 Jul 2008 11:36:42 -0400
Message-ID: <6096959DEF5C9447A6BF80BDC7EB9EDC08650AB3@SBOSEXMB1.amd.com>
In-Reply-To: <20080703100106.GA16792@elte.hu>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver:Setup routines
Thread-Index: Acjc88U2PbZD5iVQR9elebWm907svAALl9ng
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain> <20080703092052.GA5548@elte.hu> <20080703023702.6968880a.akpm@linux-foundation.org> <20080703100106.GA16792@elte.hu>
From: "Kasindorf, Barry" <Barry.Kasindorf@amd.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, "Richter, Robert" <rrichter@elbe.amd.com>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Stephane Eranian" <eranian@gmail.com>,
       "Yeh, Jason" <jason.yeh@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Markus Metzger" <markus.t.metzger@intel.com>
X-OriginalArrivalTime: 03 Jul 2008 15:36:44.0055 (UTC) FILETIME=[98B2F270:01C8DD22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have re-worked the IBS patchset and will break it into smaller pieces
and re-submit it RSN.
I will rebase it against -mm or Linux-next whichever is best. I need
Robert's AMD Family10h EPCI patches for this to build so that has to
already be there in whichever tree I use.
This patchset does interact with Jason's multiplexing changes but we can
work that out.
-Barry


-----Original Message-----
From: Ingo Molnar [mailto:mingo@elte.hu] 
Sent: Thursday, July 03, 2008 6:01 AM
To: Andrew Morton
Cc: Kasindorf, Barry; linux-kernel@vger.kernel.org; Richter, Robert; the
arch/x86 maintainers; Stephane Eranian; Yeh, Jason; Arjan van de Ven;
Markus Metzger
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile
driver:Setup routines


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 3 Jul 2008 11:20:52 +0200 Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 1) please rebase your patches ontop of -mm, which carries the 
> > oprofile multiplexing cleanups and enhancements already which 
> > heavily interact with your patchset.
> 
> I dropped those.  Because it's obvious that significant changes are to

> be made.  So I guess working against linux-next is appropriate for 
> this change.

hm, okay. All the pending oprofile enhancements are nice in principle 
and there's like 3-4 oprofile topics that we should really start 
reviewing, integrating and testing:

- the gist of the perfmon2 changes which make oprofile work across
  context-switches. Oprofile should have done this from the get go.

- the oprofile syscall enhancements from perfmon2 for lightning-fast
  profiling feedback.

- oprofile multiplexing: makes hw counter constraints largely invisible.
  Should have been done years ago.

- new hw support like this IBS patch but it would also be nice to see
  BTS/PEBS support perhaps.

- [ personally i'd love to see /debug/oprofile/prof.txt that would do
    user-space-less parsing of oprofile data and would in essence 
    replace readprofile for all practical purposes. (while still being 
    as simple and self-contained as readprofile) Full in-kernel 
    generation of human-readable text output. This would be the thing
    that would bring oprofile a lot closer to the average kernel 
    developer IMO. (Also, various knobs under /debug/oprofile/* to
    configure oprofile details on the fly, without any userspace 
    dependencies.) ]

- [ oprofile .config driven in-kernel self-tests. Right now we notice it

    quite late when it breaks. If we do /debug/oprofile/ that would be a

    great step towards that. ]

tip/x86/oprofile (which already has some smaller changes) could host 
them, if there's interest. It would be renamed to tip/oprofile or so, 
kept separate and exported separately for import into -mm and/or 
linux-next - not mixed into x86 and other -tip bits.

v2.6.28 stuff at the earliest, obviously.

	Ingo


