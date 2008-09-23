Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYIWB1Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYIWB1Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 21:27:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbYIWB1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 21:27:09 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:27398 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754617AbYIWB1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 21:27:07 -0400
X-IronPort-AV: E=Sophos;i="4.32,449,1217808000"; 
   d="scan'208";a="81129269"
From: Roland Dreier <rdreier@cisco.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Martin Bligh <mbligh@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Steven Rostedt <rostedt@goodmis.org>, darren@dvhart.com,
       "Frank Ch. Eigler" <fche@redhat.com>,
       systemtap-ml <systemtap@sources.redhat.com>
Subject: Re: Unified tracing buffer
References: <33307c790809191433w246c0283l55a57c196664ce77@mail.gmail.com>
	<48D7F5E8.3000705@redhat.com>
	<33307c790809221313s3532d851g7239c212bc72fe71@mail.gmail.com>
	<48D81B5F.2030702@redhat.com>
	<33307c790809221616h5e7410f5gc37c262d83722111@mail.gmail.com>
	<48D832B6.3010409@redhat.com>
	<alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>
X-Message-Flag: Warning: May contain useful information
Date: Mon, 22 Sep 2008 18:26:59 -0700
In-Reply-To: <alpine.LFD.1.10.0809221718100.3265@nehalem.linux-foundation.org>
	(Linus Torvalds's message of "Mon, 22 Sep 2008 17:39:29 -0700 (PDT)")
Message-ID: <adaod2f649o.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 23 Sep 2008 01:26:59.0283 (UTC) FILETIME=[7947A230:01C91D1B]
Authentication-Results: sj-dkim-4; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim4002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Because all it tells you is the ordering of the atomic increment, not of 
 > the caller. The atomic increment is not related to all the other ops that 
 > the code that you trace actually does in any shape or form, and so the 
 > ordering of the trace doesn't actually imply anything for the ordering of 
 > the operations you are tracing!

This reminds me of a naive question that occurred to me while we were
discussing this at KS.  Namely, what does "ordering" mean for events?

An example I'm all too familiar with is the lack of ordering of MMIO on
big SGI systems -- if you forget an mmiowb(), then two CPUs taking a
spinlock and doing writel() inside the spinlock and then dropping the
spinlock (which should be enough to "order" things) might see the
writel() reach the final device "out of order" because the write has to
travel through a routed system fabric.

Just like Einstein said, it really seems to me that the order of things
depends on your frame of reference.

 - R.
