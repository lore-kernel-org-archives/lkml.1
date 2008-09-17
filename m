Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYIQNzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYIQNzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYIQNzd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:55:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:35492 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751366AbYIQNzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:55:33 -0400
Message-ID: <48D10C43.90605@windriver.com>
Date: Wed, 17 Sep 2008 08:55:15 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Denis Joseph Barrow <D.Barow@option.com>
CC: "Amit S. Kale" <amitkale@linsyssoft.com>,
       Tom Rini <trini@kernel.crashing.org>, David Grothe <dave@gcom.com>,
       Tigran Aivazian <tigran@sco.com>, linux-kernel@vger.kernel.org
Subject: Re: getting false SIGTRAP breakpoints in kernel i.e. kernel hung
 unless gdb remotely attached on x86 & cont is issued
References: <48D10A70.8050202@option.com>
In-Reply-To: <48D10A70.8050202@option.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2008 13:55:07.0670 (UTC) FILETIME=[FE5D6B60:01C918CC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Joseph Barrow wrote:
> Hi ladies/gentlemen,
> The kernel I'm running gdb with is 2.6.27-rc4
> The false sigtrap is occuring in ia32_sysenter_target in arch/x86/kernel/entry_32.S:303
> when gdb is stepped from the user process as described below
>
>   

Your example does not indicate how or why you setup kgdb.  kgdb can be
compiled into the kernel, but it should not have any effect what so ever
unless it is configured for use because it will not register to receive
any of the breakpoint or single stepping traps.

Perhaps there is more to the description of your problem?

Jason.

> To reproduce
> compile kernel with kgdb support 
> compile my randsleep program attached using the .mk script
> as root
> attach randsleep to an idle serial port e.g. /dev/ttyS0 by typing
> randsleep /dev/ttyS0
> from another bash shell type
> ps -aux | grep randsleep
>
> gdb ./randsleep
> attach <pid of randsleep>
>
> You should get messages from gdb like
> Attaching to program: /home/djbarrow/devel2/randsleep/randsleep, process 6397
> Reading symbols from /lib/tls/i686/cmov/libc.so.6...done.
> Loaded symbols for /lib/tls/i686/cmov/libc.so.6
> Reading symbols from /lib/ld-linux.so.2...done.
> Loaded symbols for /lib/ld-linux.so.2
> 0xb7fda430 in __kernel_vsyscall ()
>
> Now type step.
>
> The machine is now hung until gdb attaches remotely.
>
>
>   

