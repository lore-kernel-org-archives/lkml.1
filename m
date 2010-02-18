Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733Ab0BRRBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 12:01:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab0BRRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 12:01:39 -0500
Subject: Re: Stupid futex question - 2.6.33-rc7-mmotm0210
From: Peter Zijlstra <peterz@infradead.org>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
In-Reply-To: <7380.1266511335@localhost>
References: <10057.1266501862@localhost> <1266503879.26719.702.camel@laptop>
	 <7380.1266511335@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Feb 2010 18:01:26 +0100
Message-ID: <1266512486.26719.856.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-18 at 11:42 -0500, Valdis.Kletnieks@vt.edu wrote:

> 1) should it get killed for RLIMIT_RTTIME because it's been in a futex()
> for multiple seconds? It seems suspicious - docs say a blocking syscall
> resets RTTIME - so if futex() blocks it shouldn't kill, and if it's in the
> kernel for a second without blocking it's a bug too.

sys_futex() shouldn't be taking that long indeed, and if its not caused
by the sysrq interrupt then something funny is going on indeed.

You could poke around in kernel/futex.c:futex_wait() to see where it
thinks its spending it time? There's a single retry loop in there, maybe
instrument that to see if its retrying too many times..

