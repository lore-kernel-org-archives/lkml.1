Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYG1AyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYG1AyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 20:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756130AbYG1AyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 20:54:09 -0400
Received: from ozlabs.org ([203.10.76.45]:43356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755951AbYG1AyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 20:54:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [git pull] cpus4096 fixes
Date: Mon, 28 Jul 2008 10:53:57 +1000
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Mike Travis <travis@sgi.com>
References: <20080727190601.GA764@elte.hu>
In-Reply-To: <20080727190601.GA764@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281053.58267.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008 05:06:01 Ingo Molnar wrote:
> Linus,
>
> Please pull the latest cpus4096-fixes git tree from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
> cpus4096
>
> this fixes the cpumask_of_cpu API fallout described here:
>
>    http://lkml.org/lkml/2008/7/23/76
>
> ... and the fix is wider than i'd like it to be, so close to -rc1

Sorry, it's wider because you pushed the last stupid Mike patch.  Over my 
(obviously too-polite) objections.  Most of this is reverting that, just 
without actually admitting it.

> - but 
> it's the cleanest one and it has Rusty's ack as well.

Not really.  As authored, I intended it as a bandaid for systems with small 
CPU numbers.  Mike made it always on (tho __initdata on large x86 systems), 
which IMHO is insane (2MB of initdata?).

Mike: I now think the right long-term answer is Linus' dense cpumap idea + a 
convenience allocator for cpumasks.  We sweep the kernel for all on-stack 
vars and replace them with one or the other.  Thoughts?

Rusty.
