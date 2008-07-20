Return-Path: <linux-kernel-owner+w=401wt.eu-S1756806AbYGTIbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806AbYGTIbo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 04:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYGTIbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 04:31:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52037 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753192AbYGTIbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 04:31:35 -0400
Date: Sun, 20 Jul 2008 10:31:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] fastboot patches series 1
Message-ID: <20080720083126.GB30150@elte.hu>
References: <20080718151524.5ef9e29b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718151524.5ef9e29b@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Arjan van de Ven <arjan@infradead.org> wrote:

> Hi,
> 
> this 3 patch series introduces the concept of "asynchronous initcalls".
> This is a new initcall level (6a) that has the following semantics:
> 1) Level 6a gets run asynchronously from the regular "driver" initcalls
> 2) Level 6a starts after level 5 (fs_initcall). 
> 3) Within the 6a category, the initcalls are processed sequentially;
>    there is no parallelism between them. The parallelism is more
>    like a bottom halve than it is like a softirq this way.
>    This is a nice property since it leads to predictable device ordering
>    while being able to move various pieces out of the critical boot path
> 4) The kernel will synchronize at the end of all initcalls to insure
>    that we don't free initmem until all this is done (trust me, we need
>    this)
> 
> With these 3 patches I managed to shave off 0.4 seconds off my kernel 
> boot (this may sound little, but it's a reduction from 1.9 seconds to 
> a little under 1.5 seconds, which is significant both compared to the 
> kernel boot time as well as the full distro boot time on this box)

nice idea - and i like the way it's done gradually. Most previous 
attempts at "parallel bootup" had the fundamental problem if trying to 
do too much at once.

I've created a tip/fastboot experimental/test topic for this and pushed 
it out. (see the URI below)

It's not integrated into tip/master yet - is the problem reported by 
Simon Arlott understood?

	Ingo

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git fastboot

------------------>
Arjan van de Ven (3):
      fastboot: create a "asynchronous" initlevel
      fastboot: turn the USB hostcontroller initcalls into async initcalls
      fastboot: convert a few non-critical ACPI drivers to async initcalls
