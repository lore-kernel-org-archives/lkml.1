Return-Path: <linux-kernel-owner+w=401wt.eu-S1757062AbZIQPp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbZIQPp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 11:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZIQPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 11:45:27 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:54270 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753632AbZIQPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 11:45:26 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANP2sUqrR7PE/2dsb2JhbADGaYhQAZA1BYQc
X-IronPort-AV: E=Sophos;i="4.44,404,1249257600"; 
   d="scan'208";a="243270425"
From: Roland Dreier <rdreier@cisco.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	<adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	<1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 17 Sep 2009 08:45:29 -0700
In-Reply-To: <adazl8td35u.fsf@cisco.com> (Roland Dreier's message of "Thu, 17
	Sep 2009 08:03:25 -0700")
Message-ID: <adatyz1d17q.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 17 Sep 2009 15:45:29.0444 (UTC) FILETIME=[E206B240:01CA37AD]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > > > Hmm, or are you saying you can only get 1 event per registered range and
 > > > allocate the thing on registration? That'd need some registration limit
 > > > to avoid DoS scenarios.
 > > 
 > > Yes, that's what I do.  You're right, I should add a limit... although
 > > their are lots of ways for userspace to consume arbitrary amounts of
 > > kernel resources already.
 > 
 > I'd be good to work at reducing that number, not adding to it ;-)

Yes, definitely.  I'll add a quick ummunotify module parameter that
limits the number of registrations per process.

 > But yeah, I currently don't see a very nice match to perf counters.

OK.  It would be nice to tie into something more general, but I think I
agree -- perf counters are missing the filtering and the "no lost
events" that ummunotify does have.  And I'm not sure it's worth messing
up the perf counters design just to jam one more not totally related
thing in.

 - R.
