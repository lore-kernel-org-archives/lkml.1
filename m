Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbYEEM3P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbYEEM3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 08:29:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753664AbYEEM3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 08:29:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35047 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbYEEM27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 08:28:59 -0400
Date: Mon, 5 May 2008 14:28:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: System call instrumentation
Message-ID: <20080505122835.GA1523@elte.hu>
References: <20080504134838.GA21487@Krystal> <20080505065559.GD3350@elte.hu> <20080505105915.GA26444@Krystal> <20080505111029.GA9948@elte.hu> <20080505113057.GA28070@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505113057.GA28070@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Ideally, I'd like to have this kind of high-level information :
> 
> event name : kernel syscall
> syscall name : open
> arg1 (%s) : "somefile"    <-----
> arg2 (%d) : flags
> arg3 (%d) : mode
> 
> However, "somefile" has to be read from userspace. With the protection 
> involved, it would cause a performance impact to read it a second time 
> rather than tracing the string once it's been copied to kernel-space.

performance is a secondary issue here, and copies are fast anyway _if_ 
someone wants to trace a syscall. (because the first copy brings the 
cacheline into the cache, subsequent copies are almost for free compared 
to the first copy)

	Ingo
