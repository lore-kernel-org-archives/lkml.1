Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbZJMGac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbZJMGac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 02:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZJMGab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 02:30:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51448 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755970AbZJMGaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 02:30:30 -0400
Date: Tue, 13 Oct 2009 08:29:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Huang Ying <ying.huang@intel.com>
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] mce-inject: use injected mce only during faked
	handler call
Message-ID: <20091013062939.GA8484@elte.hu>
References: <4AC96391.1060001@jp.fujitsu.com> <1255072482.5228.157.camel@yhuang-dev.sh.intel.com> <4ACEE5E0.3050701@jp.fujitsu.com> <1255074286.5228.163.camel@yhuang-dev.sh.intel.com> <4ACEF4D9.9090600@jp.fujitsu.com> <1255079484.5228.201.camel@yhuang-dev.sh.intel.com> <4AD3E731.7080900@jp.fujitsu.com> <1255404495.6047.298.camel@yhuang-dev.sh.intel.com> <4AD41793.9020400@jp.fujitsu.com> <1255414771.6047.405.camel@yhuang-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255414771.6047.405.camel@yhuang-dev.sh.intel.com>
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


* Huang Ying <ying.huang@intel.com> wrote:

> I have talked with Ingo about this patch. But he has different idea 
> about MCE log ring buffer and he didn't want to merge the patch even 
> as an urgent bug fixes. It seems that another re-post can not convince 
> him.

Correct. The fixes are beyond what we can do in .32 - and for .33 i 
outlined (with a patch) that we should be using not just the ftrace 
ring-buffer (like your patch did) but perf events to expose MCE events.

That brings MCE events to a whole new level of functionality.

Event injection support would be an interesting new addition to 
kernel/perf_event.c: non-MCE user-space wants to inject events as well - 
both to simulate rare events, and to define their own user-space events.

Is there any technical reason why we wouldnt want to take this far 
superior approach?

	Ingo
