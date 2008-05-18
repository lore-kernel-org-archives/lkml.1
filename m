Return-Path: <linux-kernel-owner+w=401wt.eu-S1753933AbYERRma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbYERRma (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbYERRmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:42:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39572 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbYERRmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:42:20 -0400
Date: Sun, 18 May 2008 10:40:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Austin Clements <amdragon+kernelbugzilla@mit.edu>,
       Ingo Molnar <mingo@elte.hu>, john stultz <johnstul@us.ibm.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] posix timers: use SIGQUEUE_CANCELLED when the timer
 is destroyed
In-Reply-To: <alpine.LFD.1.10.0805181024050.3020@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0805181038020.3020@woody.linux-foundation.org>
References: <20080517151422.GA9502@tv-sign.ru> <20080517153140.GA9534@tv-sign.ru> <alpine.LFD.1.10.0805171006090.3020@woody.linux-foundation.org> <20080518171543.GA25855@tv-sign.ru> <alpine.LFD.1.10.0805181024050.3020@woody.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 18 May 2008, Linus Torvalds wrote:
> 
> So the rule is that if one bit of a word needs locking, then they *all* 
> do.

Side note: the alternative, of course, is to just use the atomic bit 
operations. They aren't generally much (if at all) faster than locking + 
doing the operation + unlocking, but they can avoid lock contention, so 
if you do a lot of bit ops that need no other locking than the setting and 
clearing (possibly with testing), then they are the right choice.

For signals, we obviously need other locking, so the atomic bit ops are a 
waste of time (doing *both* locking for other reasons *and* atomic bitops 
is obviously much slower than either).

		Linus
