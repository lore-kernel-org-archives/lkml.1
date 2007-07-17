Return-Path: <linux-kernel-owner+w=401wt.eu-S1758921AbXGQMg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921AbXGQMg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669AbXGQMgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:36:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56871 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbXGQMgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:36:47 -0400
Date: Tue, 17 Jul 2007 14:36:10 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alexey Dobriyan <adobriyan@sw.ru>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, devel@openvz.org,
       Thomas Gleixner <tglx@linutronix.de>, stable@kernel.org
Subject: Re: [PATCH] Fix leaks on
	/proc/{*/sched,sched_debug,timer_list,timer_stats}
Message-ID: <20070717123511.GB17657@elte.hu>
References: <20070717122511.GD25083@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717122511.GD25083@localhost.sw.ru>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Alexey Dobriyan <adobriyan@sw.ru> wrote:

> On every open/close one struct seq_operations leaks.
> Kudos to /proc/slab_allocators.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>

ouch ...

Acked-by: Ingo Molnar <mingo@elte.hu>

-stable material too, as far as timer_info/stats goes.

> -       .release        = seq_release,
> +       .release        = single_release,

i think seq_release() definitely needs to grow a WARN_ON() if it's being 
used on an inode that was opened via single_open(). This bug is so 
easily committed, and nothing but a small leak reminds us on it.

	Ingo
