Return-Path: <linux-kernel-owner+w=401wt.eu-S1752324AbZLHJVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbZLHJVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 04:21:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751440AbZLHJVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 04:21:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45334 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbZLHJVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 04:21:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Cong Wang <amwang@redhat.com>
Subject: Re: [RFC Patch] getrusage: fill ru_ixrss, ru_idrss and ru_isrss fields
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       Jiri Pirko <jpirko@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Oleg Nesterov <oleg@redhat.com>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B1E13C8.70704@redhat.com>
References: <20091208173730.B5C3.A69D9226@jp.fujitsu.com> <4B1E13C8.70704@redhat.com>
Message-Id: <20091208181117.B5C9.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  8 Dec 2009 18:21:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> KOSAKI Motohiro wrote:
> > 	The next three fields, the subject of this patch, are named ru_XXrss:
> > 	though the 80-column comment omits to say "resident set" before "size",
> > 	I believe they'd be expected to account (subdivided) resident set sizes?
> > 
> > 
> > your calculation is not rss nor not integral.
> > 
> 
> Hmm, I misunderstood rss here. Does it mean the memory stayed in
> physical mem? i.e. not swapped out.

Yes.

Plus, 'integral' mean "tick * rss". but in dyntick environment, per tick statistics is not
so easy nor low cost.

> So, if I want to get those rss statistics, I have to add some more
> mm_counter by myself? I only find file_rss and anon_rss in mm_struct.

Hmm..
I doubt nobody use such statistics. if nobody explain real world usage, I oppose to add
new counter overhead.



