Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbZKPP4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbZKPP4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 10:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZKPP4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 10:56:09 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52151 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbZKPP4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 10:56:07 -0500
Date: Mon, 16 Nov 2009 15:56:06 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jean Delvare <khali@linux-fr.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Leon Woestenberg <leon.woestenberg@gmail.com>,
       linux-i2c@vger.kernel.org, rt-users <linux-rt-users@vger.kernel.org>,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: yield() in i2c non-happy paths hits BUG under -rt patch
Message-ID: <20091116155606.GC29479@sirena.org.uk>
References: <c384c5ea0911071101u7415d37o2611c542e5fae309@mail.gmail.com> <20091107210147.3e754278@hyperion.delvare> <4AF7148C.9090706@thebigcorporation.com> <20091112211255.09cd884a@hyperion.delvare> <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911132139560.24119@localhost.localdomain>
X-Cookie: Stay away from hurricanes for a while.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 11:03:39PM +0100, Thomas Gleixner wrote:

> Q: Why put people yield() into their code ?
> A: Because:
>    - it is less nasty than busy waiting for a long time
>    - it works better

...

> I can see the idea of using yield() to let other tasks making progress
> in situations where the hardware is a design failure as well,
> e.g. bitbang devices. But if we have to deal with hardware which is
> crap by design yield() is the worst of all answers simply due to its
> horrible semantics.

What other options are there available for the first case (which is
often why things work better with the use of yield) that don't involve
sleeps, or is the idea that in situations like this drivers should
always sleep?
