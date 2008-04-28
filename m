Return-Path: <linux-kernel-owner+w=401wt.eu-S933924AbYD1MtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924AbYD1MtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 08:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765698AbYD1Ms7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 08:48:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765485AbYD1Ms7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 08:48:59 -0400
Date: Mon, 28 Apr 2008 14:48:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 0/2] Immediate Values - jump patching update
Message-ID: <20080428124833.GE27997@elte.hu>
References: <20080428033415.303000651@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428033415.303000651@polymtl.ca>
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

> Hi Ingo,
> 
> Here is the update to the jump patching optimization taking care of 
> Peter's comments about register liveliness and instruction re-use by 
> gcc optimizations. A good thing : it actually simplifies the code. 
> Unfortunately, it adds 3 bytes to the instructions in i-cache because 
> I now have to use a 5-bytes mov instruction so I can replace it with a 
> 5-bytes jump. Therefore, 9 bytes are added to rather small functions 
> (5-bytes mov + 2-bytes test + 2 bytes conditional branch) and 13 bytes 
> are added to larger functions which needs a 6 bytes conditional branch 
> at the branch site.
> 
> Instead of having to execute a sequence of nop, nop and jump, we now 
> only have to execute the near jump, which jumps either at the address 
> following the conditional branch or at the target address of the 
> conditional branch, depending on the immediate value variable state.
> 
> Thanks to Peter for the review.

thanks Mathieu, i've queued them up for more testing. Your previous 
queue already looked good here so i pushed it out into sched-devel.git 
as you probably noticed.

Sidenote, without trying to bikeshed paint this issue too much: are we 
absolutely sure that (on modern CPU architectures) such a short jump is 
better than just 2-3 NOPs in a sequence? It's a minor (sub-cycle) detail 
in any case.

	Ingo
