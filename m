Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYGCOg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYGCOg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 10:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753092AbYGCOgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 10:36:50 -0400
Received: from fallback.mail.elte.hu ([157.181.151.13]:45852 "EHLO
	fallback.mail.elte.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344AbYGCOgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 10:36:49 -0400
Date: Thu, 3 Jul 2008 12:01:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Barry Kasindorf <barry.kasindorf@amd.com>, linux-kernel@vger.kernel.org,
       Robert Richter <robert.richter@amd.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Stephane Eranian <eranian@gmail.com>, Jason Yeh <jason.yeh@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Markus Metzger <markus.t.metzger@intel.com>
Subject: Re: [PATCH 1/3] AMD Family10h+ IBS support for oProfile driver:
	Setup routines
Message-ID: <20080703100106.GA16792@elte.hu>
References: <20080609175030.2844.77365.sendpatchset@localhost.localdomain> <20080703092052.GA5548@elte.hu> <20080703023702.6968880a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080703023702.6968880a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
