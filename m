Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZGNQmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZGNQmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:42:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbZGNQmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:42:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47298 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754800AbZGNQmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:42:50 -0400
Date: Tue, 14 Jul 2009 09:42:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kaber@trash.net
Subject: Re: [patch 1/3] net: serialize hrtimer callback in sched_cbq
In-Reply-To: <1247588890.7500.186.camel@twins>
Message-ID: <alpine.LFD.2.01.0907140940440.13838@localhost.localdomain>
References: <20090709215606.526259917@linutronix.de>  <20090712.135555.207096388.davem@davemloft.net>  <alpine.LFD.2.00.0907141040350.2777@localhost.localdomain>  <20090714.090055.56906831.davem@davemloft.net> <1247588890.7500.186.camel@twins>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Jul 2009, Peter Zijlstra wrote:
> 
> Linus really hated the softirq mode, which is what prompted me to change
> that.
> 
> Now, it might be he only hated the particular interface and the
> resulting code, but I think to remember he simply thought the whole
> thing daft.

Yes. And I hated the bugs it had. 

Don't make something as core as timers any more complicated. Don't take 
locks in timers and then complain about deadlocks. If your locking is 
broken, don't make the core timers be idiotically broken.

Because it was. The code was a total mess to follow, and had bugs.

		Linus
