Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab0BRJga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:36:30 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:44052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab0BRJg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:36:29 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1264740107.20211.53.camel@pasglop>
References: <1264740107.20211.53.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 10:36:15 +0100
Message-ID: <1266485775.6539.6.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 15:41 +1100, Benjamin Herrenschmidt wrote:
> Hi Ingo !
> 
> Johannes and I see this on our quad G5s... it -could- be similar to
> one reported a short while ago by Xiaotian Feng <xtfeng@gmail.com>
> under the subject [2.6.33-rc4] sysfs lockdep warnings on cpu hotplug.
>  
> Basically, the machine deadlocks right after printing the following
> when doing a shutdown:
> 
> halt/4071 is trying to acquire lock:
>  (s_active){++++.+}, at: [<c0000000001ef868>]
> .sysfs_addrm_finish+0x58/0xc0
> 
> but task is already holding lock:
>  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>]
> .lock_policy_rwsem_write+0x84/0xf4
> 
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:

This is still happening with -rc8. Any news?

johannes

