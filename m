Return-Path: <linux-kernel-owner+w=401wt.eu-S1759994AbYBGAkr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994AbYBGAkr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:40:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933139AbYBGANw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:13:52 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38347 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144AbYBGANt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 19:13:49 -0500
Date: Thu, 7 Feb 2008 01:13:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Jason Wessel <jason.wessel@windriver.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] KGDB: Major refactoring
Message-ID: <20080207001336.GA22986@elte.hu>
References: <47A8F275.9090901@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A8F275.9090901@web.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Jan Kiszka <jan.kiszka@web.de> wrote:

> As most changes are tightly coupled, this refactoring patch for
> KGDB_8250 as well as the core and the new KGDBOC driver comes as a
> single chunk. The changes are:
>  - Reorganized configuration: I/O drivers can be independently
>    configured as module or built-in
>  - Dynamic reconfiguration for KGDB_8250 (just like for KGDBOC)
>  - Reworked KGDB_8250 configuration string format
>  - attachwait removed, arming the debugger via assigning an I/O driver
>    implies "attachwait"
>  - Cleaned up I/O driver managment of the core
>  - Matured the various boot-up, configure, unconfigure code paths for
>    both I/O drivers
>  - IRQ vs. KGDB_CONSOLE-output SMP race fixed for KGDB_8250
>  - Reduced and cleaned up hooks into serial_core/8250
>  - Kconfig cleanups

great stuff! I've picked these cleanups up into x86.git. (will pick up 
Jason's commits too)

Could you try something else too perhaps, which would be way useful for 
me: to add a sysctl flag (or something like that) to change kgdboc to 
accept a Ctrl-C and break into kgdb mode? [this means a simple Ctrl-C on 
a kgdboc line would break into KGDB as well - but that would be an 
acceptable price.] Right now kgdboc just hangs when gdb attaches - i 
have to generate a SysRq sequence via a terminal emulator to break it 
into KGDB mode.

This would make kgdboc way more practical without having to resort to a 
protocol splitting proxy, etc.

	Ingo
