Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbZHUVDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbZHUVDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 17:03:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932640AbZHUVDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 17:03:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:48774 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625AbZHUVDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 17:03:00 -0400
Date: Fri, 21 Aug 2009 23:02:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       Greg KH <greg@kroah.com>, "Luis R. Rodriguez" <mcgrof@gmail.com>,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-ID: <20090821210215.GA26956@elte.hu>
References: <20090821145406.GA3659@elte.hu> <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com> <alpine.DEB.2.00.0908211204490.30182@gandalf.stny.rr.com> <20090821162822.GA20898@elte.hu> <alpine.DEB.2.00.0908211253080.30182@gandalf.stny.rr.com> <20090821195131.GE5356@elte.hu> <alpine.DEB.2.00.0908211601000.30182@gandalf.stny.rr.com> <alpine.DEB.2.00.0908211631420.30182@gandalf.stny.rr.com> <20090821203949.GD15439@elte.hu> <alpine.DEB.2.00.0908211641130.30182@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908211641130.30182@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Fri, 21 Aug 2009, Ingo Molnar wrote:
> > 
> > ah - indeed, i forgot that it bases its decision off /proc/config, 
> > if available, right?
> 
> Here's the list in order of seach:
> 
> 1. local .config file  (in tree root)
> 2. /proc/config.gz
> 3. /boot/config-`uname -r`
> 4. /boot/vmlinuz-`uname -r` (extracts .config if configured in)
> 5. vmlinux (local built vmlinux if .config is configured in)
> 6. /lib/modules/`uname -r`/kernel/kernel/configs.ko
> 7. kernel/configs.ko
> 8. kernel/configs.o
> 
> I originally had /proc/config.gz but Andi Kleen correctly pointed 
> out that it would be more intuitive if we use the local .config 
> first. This would be something that I myself would expect. If you 
> don't want the local .config used, then simply delete it.

Well, but there's already a mechanism to include configs as a 
must-have list: KCONFIG_ALLCONFIG=.config.

	Ingo
