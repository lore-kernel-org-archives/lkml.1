Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983AbZFVL5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbZFVL5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751729AbZFVL5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:57:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42464 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866AbZFVL5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:57:22 -0400
Date: Mon, 22 Jun 2009 13:57:03 +0200
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
Subject: Re: II.1 - Fixed counters on Intel
Message-ID: <20090622115703.GM24366@elte.hu>
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

> II/ X86 comments
>
>  1/ Fixed counters on Intel
>
> You cannot simply fall back to generic counters if you cannot find
> a fixed counter. There are model-specific bugs, for instance
> UNHALTED_REFERENCE_CYCLES (0x013c), does not measure the same
> thing on Nehalem when it is used in fixed counter 2 or a generic
> counter. The same is true on Core.

This could be handled via a model specific quirk, if the erratum is
serious enough.

> You cannot simply look at the event field code to determine
> whether this is an event supported by a fixed counters. You must
> look at the other fields such as edge, invert, cnt-mask. If those
> are present then you have to fall back to using a generic counter
> as fixed counters only support priv level filtering. As indicated
> above, though, programming UNHALTED_REFERENCE_CYCLES on a generic
> counter does not count the same thing, therefore you need to fail
> if filters other than priv levels are present on this event.

Agreed, we'll fix this.
