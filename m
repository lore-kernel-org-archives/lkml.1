Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbXDZA5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbXDZA5i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 20:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753943AbXDZA5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 20:57:38 -0400
Received: from mail36.syd.optusnet.com.au ([211.29.133.76]:43712 "EHLO
	mail36.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753805AbXDZA5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 20:57:37 -0400
From: Con Kolivas <kernel@kolivas.org>
To: Ingo Molnar <mingo@elte.hu>, ck@vds.kolivas.org
Subject: SD renice recommendation was: Re: [REPORT] cfs-v4 vs sd-0.44
Date: Thu, 26 Apr 2007 10:51:11 +1000
User-Agent: KMail/1.9.5
Cc: Peter Williams <pwil3058@bigpond.net.au>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Juliusz Chroboczek <jch@pps.jussieu.fr>,
       ck list <ck@vds.kolivas.org>, Bill Davidsen <davidsen@tmr.com>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       caglar@pardus.org.tr, Gene Heskett <gene.heskett@gmail.com>
References: <200704220959.34978.kernel@kolivas.org> <462DA1E8.9080201@bigpond.net.au> <20070424063633.GA17257@elte.hu>
In-Reply-To: <20070424063633.GA17257@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704261051.13072.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 April 2007 16:36, Ingo Molnar wrote:

> So, my point is, the nice level of X for desktop users should not be set
> lower than a low limit suggested by that particular scheduler's author.
> That limit is scheduler-specific. Con i think recommends a nice level of
> -1 for X when using SD [Con, can you confirm?], while my tests show that
> if you want you can go as low as -10 under CFS, without any bad
> side-effects. (-19 was a bit too much)

Nice 0 as a default for X, but if renicing, nice -10 as the lower limit for X 
on SD. The reason for that on SD is that the priority of freshly woken up 
tasks (ie not fully cpu bound) for both nice 0 and nice -10 will still be the 
same at PRIO 1 (see the prio_matrix). Therefore, there will _not_ be 
preemption of the nice 0 task and a context switch _unless_ it is already cpu 
bound and has consumed a certain number of cycles and has been demoted. 
Contrary to popular belief, it is not universal that a less niced task will 
preempt its more niced counterpart and depends entirely on implementation of 
nice. Yes it is true that context switch rate will go up with a reniced X 
because the conditions that lead to preemption are more likely to be met, but 
it is definitely not every single wakeup of the reniced X.

Alas, again, I am forced to spend as little time as possible at the pc for my 
health, so expect _very few_ responses via email from me. Luckily SD is in 
pretty fine shape with version 0.46.

-- 
-ck
