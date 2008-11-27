Return-Path: <linux-kernel-owner+w=401wt.eu-S1754813AbYK0AIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813AbYK0AIW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 19:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752572AbYK0AIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 19:08:14 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:49475 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbYK0AIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 19:08:13 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 26 Nov 2008 16:08:11 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, ltt-dev@lists.casi.polymtl.ca,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: Re: [ltt-dev] [PATCH] Poll : introduce poll_wait_exclusive() new
 function
In-Reply-To: <20081126111511.GE14826@Krystal>
Message-ID: <alpine.DEB.1.10.0811261559180.11771@alien.or.mcafeemobile.com>
References: <20081124205512.26C1.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20081124121659.GA18987@Krystal> <20081125194700.26EB.KOSAKI.MOTOHIRO@jp.fujitsu.com> <alpine.DEB.1.10.0811251316590.32523@alien.or.mcafeemobile.com> <20081126111511.GE14826@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Mathieu Desnoyers wrote:

> One of the key design rule of LTTng is to do not depend on such
> system-wide data structures, or entity (e.g. single manager thread).
> Everything is per-cpu, and it does scale very well.
> 
> I wonder how badly the approach you propose can scale on large NUMA
> systems, where having to synchronize everything through a single thread
> might become an important point of contention, just due to the cacheline
> bouncing and extra scheduler activity involved.

I dunno the LTT architecture, so I'm staying out of that discussion.
But, if the patch you're trying to push is to avoid thundering herd of so 
many threads waiting on the single file*, you've got the same problem 
right there. You've got at least the spinlock protecting the queue 
where these threads are focusing, whose cacheline is bounced gets bounced 
all over the CPUs.
Do you have any measure of the improvements that such poll_wait_exclusive()
will eventually lead to?



- Davide


