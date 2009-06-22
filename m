Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbZFVLvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbZFVLvx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZFVLvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:51:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751142AbZFVLvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:51:43 -0400
Date: Mon, 22 Jun 2009 13:51:31 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: I.4 - Controlling group multiplexing
Message-ID: <20090622115131.GE24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 4/ Controlling group multiplexing
>
> Although multiplexing is exposed to users via the timing
> information, events may not necessarily be grouped at random by
> tools. Groups may not be ordered at random either.
>
> I know of tools which craft the sequence of groups carefully such
> that related events are in neighboring groups such that they
> measure similar parts of the execution. This way, you can mitigate
> the fluctuations introduced by multiplexing. In other words, some
> tools may want to control the order in which groups are scheduled
> on the PMU.
>
> You mentioned that groups are multiplexed in creation order. But
> which creation order? As far as I know, multiple distinct tools
> may be attaching to the same thread at the same time and their
> groups may be interleaved in the list. Therefore, I believe
> 'creation order' refers to the global group creation order which
> is only visible to the kernel. Each tool may see a different
> order. Let's take an example.
>
> Tool A creates group G1, G2, G3 and attaches them to thread T0. At
> the same time tool B creates group G4, G5. The actual global order
> may be: G1, G4, G2, G5, G3. This is what the kernel is going to
> multiplex. Each group will be multiplexed in the right order from
> the point of view of each tool. But there will be gaps. It would
> be nice to have a way to ensure that the sequence is either: G1,
> G2, G3, G4, G5 or G4, G5, G1, G2, G3. In other words, avoid the
> interleaving.

Since its all sampling, what is the statistical relevance of
scheduling groups back to back when interleaved with other groups?

I appreciate people might be wanting this, but is that wanting
justified?

That is, A1 A2 B1 B2 vs A1 B1 A2 B2, what statistically relevant
feature does one have over the other, esp. since the RR interval is
outside of programm control.
