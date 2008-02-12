Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbYBLN7B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbYBLN7B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:59:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759019AbYBLN6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:58:52 -0500
Received: from mail.windriver.com ([147.11.1.11]:40065 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758790AbYBLN6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:58:51 -0500
Message-ID: <47B1A626.8000605@windriver.com>
Date: Tue, 12 Feb 2008 07:59:02 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] kgdb-light -v10
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212131813.GA614@ska.dandreoli.com>
In-Reply-To: <20080212131813.GA614@ska.dandreoli.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2008 13:58:38.0463 (UTC) FILETIME=[5DF460F0:01C86D7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Domenico Andreoli wrote:
> Hi,
>
> On Tue, Feb 12, 2008 at 12:27:47PM +0100, Ingo Molnar wrote:
>   
>> this is kgdb-light, version -v10 (against Linus-latest), and can be 
>> pulled from:
>>
>>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-kgdb.git
>>
>> shortlog, diffstat and full patch can be found further below.
>>     
>
>   I am just trying to play with this, I am not able to make it work.
> Assume I am able with git, I use it every day on my software, then I
> am correctly tracking and building your branch on git.kernel.org.
>
> My config has both KGDB and KGDB_SERIAL_CONSOLE. kernel command line
> has kgdbwait kgdboc=ttyS0,115200. linux console is not on serial but if
> do not enable KGDB_SERIAL_CONSOLE I am then unable to hit SysRq+g. If
> instead I use linux serial console, gdb messes with getty and things
> quickly get worse.
>
> 1. at boot, kernel waits for a gdb connection
> 2. gdb connection is established from another box
> 3. gdb breaks in
> 4. hit continue at gdb prompt
> 5. target box returns to life. everything looks ok (it is 2.6.25-rc1!)
> 6. SysRq+h on the target correctly shows the help on the console
> 7. SysRq+g on the target, it prints "SysRq : GDB" and hangs forever
> 8. gdb on the host does not break in
>
> is really that simple, am i overlooking anything? thank you.
>
> regards,
> Domenico
>
>   
I doubt the .config you posted was the one you used, because there were
no KGDB options specified at all.

If you want to be using your vga device as the console that is ok. You
can still activate the sysrq with running the command: echo g >
/proc/sysrq-trigger

You might consider doing "set debug remote 1" in the gdb session if you
want to see what is going on. After the continue, the next time you
break in with the debugger it should send $T.........etc which is a stop
packet.

Jason.
