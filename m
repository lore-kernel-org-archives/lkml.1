Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbYBJTir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbYBJTir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:38:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYBJTiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:38:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56935 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbYBJTiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:38:22 -0500
Date: Sun, 10 Feb 2008 20:34:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Ray Lee <ray-lk@madrabbit.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [git pull] kgdb light, v5
Message-ID: <20080210193455.GA18067@elte.hu>
References: <20080210071304.GA3788@elte.hu> <20080210104709.GB10790@uranus.ravnborg.org> <20080210163603.GB28201@elte.hu> <2c0942db0802100930y5338e545k808d996f9a19bac@mail.gmail.com> <47AF483E.10905@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AF483E.10905@web.de>
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

> [This still runs fine here, but sharp eyes are always welcome!]
> 
> Cleanup of the way kgdb
>  - accesses unsafe memory via probe_kernel_*
>  - converts to/from hex representation
>  - passes errors due to such accesses around
> 
> At this chance I also fix kgdb_ebin2mem, which was broken /wrt escape 
> sequence handling.

great! Applied. The kgdb memory accesses look _much_ cleaner now, and 
it's a significant simplification as well:

   2 files changed, 109 insertions(+), 244 deletions(-)

the uaccess.h macros look a bit ugly now (it all got inherited from the 
existing [and ancient] probe_kernel_address() macro) and because we now 
touch it materially anyway, we might as well do it right?

	Ingo
