Return-Path: <linux-kernel-owner+w=401wt.eu-S1752877AbXLCRlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877AbXLCRlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 12:41:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXLCRkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 12:40:55 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:56648 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751439AbXLCRkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 12:40:55 -0500
Date: Mon, 3 Dec 2007 20:41:13 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] fix the long standing exec vs kill race
Message-ID: <20071203174113.GA2674@tv-sign.ru>
References: <20071202151454.GA13180@tv-sign.ru> <alpine.LFD.0.9999.0712030829240.8458@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712030829240.8458@woody.linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Linus Torvalds wrote:
> 
> On Sun, 2 Dec 2007, Oleg Nesterov wrote:
> >
> > Depends on
> > 	[PATCH] __group_complete_signal: fix coredump with group stop race
> > 	http://marc.info/?l=linux-kernel&m=119653436116036
> > 
> > Needs review and testing.
> > 
> > Please comment, I think at least the idea is promising.
> 
> It looks clean and sane to me, but I'm currently more worried about 
> 2.6.24, and even the first patch this depends on (coredump/stop race) 
> makes me a bit nervous since all these things tend to have some rather 
> subtle interactions with other parts that depended on the exact semantics 
> of all the signal issues.
> 
> So my gut feel - considering that none of the problems involved here are 
> exactly new - is that this is good material for early in the 2.6.25 cycle.
> 
> But I think the whole series looks ok, and if people press me and convince 
> me it's (a) well tested and (b) needed early, then I guess it can be 
> pushed into 2.6.24.

No, no, I don't think this should be pushed into 2.6.24 (even the first patch).

These problems are very old afaics, and nobody complained so far.

Even if correct, this needs more testing. I don't think this can break exec
or coredump in some "obvious" way, but I'm afraid this can introduce new
races / corner cases.

<offtopic>

I hope that with the new meaning of ->group_exit_task we can re-introduce the
"coredump signal "freezes" the thread group at sender's side" property, but we
need some hack to do this. OTOH, it was always a hack.

</offtopic>

Oleg.

