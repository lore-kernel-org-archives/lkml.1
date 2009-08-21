Return-Path: <linux-kernel-owner+w=401wt.eu-S932650AbZHUUwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650AbZHUUwD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:52:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932480AbZHUUwC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:52:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51487 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932318AbZHUUwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:52:01 -0400
Date: Fri, 21 Aug 2009 16:52:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20090821203949.GD15439@elte.hu>
Message-ID: <alpine.DEB.2.00.0908211641130.30182@gandalf.stny.rr.com>
References: <20090821143525.GH11098@elte.hu> <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com> <20090821145406.GA3659@elte.hu> <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com> <alpine.DEB.2.00.0908211204490.30182@gandalf.stny.rr.com>
 <20090821162822.GA20898@elte.hu> <alpine.DEB.2.00.0908211253080.30182@gandalf.stny.rr.com> <20090821195131.GE5356@elte.hu> <alpine.DEB.2.00.0908211601000.30182@gandalf.stny.rr.com> <alpine.DEB.2.00.0908211631420.30182@gandalf.stny.rr.com>
 <20090821203949.GD15439@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Aug 2009, Ingo Molnar wrote:
> 
> ah - indeed, i forgot that it bases its decision off /proc/config, 
> if available, right?

Here's the list in order of seach:

1. local .config file  (in tree root)
2. /proc/config.gz
3. /boot/config-`uname -r`
4. /boot/vmlinuz-`uname -r` (extracts .config if configured in)
5. vmlinux (local built vmlinux if .config is configured in)
6. /lib/modules/`uname -r`/kernel/kernel/configs.ko
7. kernel/configs.ko
8. kernel/configs.o

I originally had /proc/config.gz but Andi Kleen correctly pointed out that 
it would be more intuitive if we use the local .config first. This would 
be something that I myself would expect. If you don't want the local 
.config used, then simply delete it.

> 
> Fair enough - forget my suggestion. It's good as-is.

Great!

Thanks,

-- Steve

