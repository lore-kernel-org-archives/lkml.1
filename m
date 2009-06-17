Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbZFQIo0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbZFQIo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 04:44:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757780AbZFQIoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 04:44:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:43176 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756545AbZFQIoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 04:44:16 -0400
Message-ID: <4A38ACB5.90009@kernel.org>
Date: Wed, 17 Jun 2009 17:43:33 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Hugh Dickins <hugh.dickins@tiscali.co.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       paulus@samba.org, acme@redhat.com, efault@gmx.de, npiggin@suse.de,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [tip:perfcounters/core] x86: Add NMI types for kmap_atomic
References: <1245080486.6800.561.camel@laptop>	 <1245089065.13761.19316.camel@twins> <20090615181555.GA11248@elte.hu>	 <1245089943.13761.19334.camel@twins> <20090615182549.GD11248@elte.hu>	 <1245090608.13761.19349.camel@twins> <20090615184217.GG11248@elte.hu>	 <1245091674.6741.180.camel@laptop> <20090615185259.GK11248@elte.hu>	 <1245092433.6741.201.camel@laptop> <20090616081348.GC16229@elte.hu>	 <Pine.LNX.4.64.0906161312440.552@sister.anvils> <1245225518.13761.21617.camel@twins>
In-Reply-To: <1245225518.13761.21617.camel@twins>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 17 Jun 2009 08:43:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Peter Zijlstra wrote:
> On Tue, 2009-06-16 at 13:38 +0100, Hugh Dickins wrote:
>> Something else to throw in: what if they were not just atomic,
>> but also replaced the current sleeping kmaps? i.e. a task context
>> carries around its own stack of these.
> 
> I actually did that once, but it means the task needs to be cpu-affine,
> because fixmaps have different addresses between cpus. And disabling
> migration for tasks has subtle side-effects so I dropped that again.
> 
> However, I recently considered the possiblity of putting the fixmaps in
> the new per-cpu address space so that we might use the %gs segment to
> normalize the fixmap addresses between the cpus.
> 
> This would allow full preemptible kmaps (yay for -rt).
> 
> However I suspect it might greatly complicate kmaps for the !i386 world.

Other archs are in the process of conversion so once that is complete,
there's no reason this should be more difficult but it means that
kmapped addresses should be accessed differently from regular ones
which we can't do.  :-(

Thanks.

-- 
tejun
