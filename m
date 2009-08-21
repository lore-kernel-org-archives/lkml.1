Return-Path: <linux-kernel-owner+w=401wt.eu-S932467AbZHUQFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467AbZHUQFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932430AbZHUQFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:05:14 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:43119 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbZHUQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:05:13 -0400
Date: Fri, 21 Aug 2009 12:05:13 -0400 (EDT)
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
In-Reply-To: <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0908211204490.30182@gandalf.stny.rr.com>
References: <20090819025634.987354707@goodmis.org> <20090821143525.GH11098@elte.hu> <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com> <20090821145406.GA3659@elte.hu> <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 21 Aug 2009, Steven Rostedt wrote:
> 
> OK, I found the bug. There's a dependency missing.
> 
> $ make localyesconfig
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/basic/docproc
>   HOSTCC  scripts/basic/hash
> using config: '/boot/config-2.6.27.25-78.2.56.fc9.x86_64'
> /bin/sh: line 8: scripts/kconfig/conf: No such file or directory
> make[1]: *** [localyesconfig] Error 127
> make: *** [localyesconfig] Error 2
> 
> Thus the script failed to run. But the sed command that converts the '=m' 
> to '=y' still ran. This gives us a distro config with all modules 
> converted to built in!

Funny that localmodconfig does not have this bug.

-- Steve

