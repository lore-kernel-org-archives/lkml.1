Return-Path: <linux-kernel-owner+w=401wt.eu-S1754773AbZI3RGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773AbZI3RGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754651AbZI3RGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:06:30 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:59357 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754447AbZI3RG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:06:29 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=pass (signature verified [TEST]) header.i=rdreier@cisco.com
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAE8tw0qrR7PE/2dsb2JhbADBFYhbAZAMBoQngjI
X-IronPort-AV: E=Sophos;i="4.44,481,1249257600"; 
   d="scan'208";a="249166808"
From: Roland Dreier <rdreier@cisco.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pavel Machek <pavel@ucw.cz>, Peter Zijlstra <peterz@infradead.org>,
       linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       general@lists.openfabrics.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: Re: [ofa-general] Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com> <1253187028.8439.2.camel@twins>
	<adafxalejiq.fsf@cisco.com> <adaab0tej5c.fsf@cisco.com>
	<1253198976.14935.27.camel@laptop> <adazl8td35u.fsf@cisco.com>
	<adatyz1d17q.fsf@cisco.com> <20090929171332.GD14405@elf.ucw.cz>
	<20090930094456.GD24621@elte.hu>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 30 Sep 2009 10:06:32 -0700
In-Reply-To: <20090930094456.GD24621@elte.hu> (Ingo Molnar's message of "Wed,
	30 Sep 2009 11:44:56 +0200")
Message-ID: <ada63b0tl9j.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 30 Sep 2009 17:06:32.0692 (UTC) FILETIME=[5C1E3340:01CA41F0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > Performance events filtering is being worked on and now with the proper 
 > non-DoS limit you've added you can lose events too, dont you? So it's 
 > all a question of how much buffering to add - and with perf events too 
 > you can buffer arbitrary large amount of events.

No, the idea for non-DoS for ummunotify is that we would limit the
number of regions the application can register; so an application might
hit the limit up front but no runtime loss of events once a region was
registered successfully.

 > I think this could be done in a simpler, less limited, more generic, 
 > more useful form by using some variation of perf events.
 > 
 > You should be able to get all that you want by adding two TRACE_EVENT() 
 > tracepoints and using the existing perf event syscall to get the events 
 > to user-space.

Yes, I would like to use perf events too.  Would it be plausible to
create a way for userspace to create a "counter" for each address range
being watched?  Then events would not be lost, because those counters
would become non-zero.

 > Meaning that this:
 >   9 files changed, 1060 insertions(+), 1 deletions(-)

Note that lots/ of the files touched here are in Documentation or are
one-line changes to Makefiles etc.

 - R.
