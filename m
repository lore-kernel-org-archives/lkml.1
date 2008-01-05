Return-Path: <linux-kernel-owner+w=401wt.eu-S1756642AbYAESSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642AbYAESSk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 13:18:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbYAESSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 13:18:31 -0500
Received: from japan.chezphil.org ([77.240.5.4]:3677 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbYAESSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:18:30 -0500
To: "Andreas Schwab" <schwab@suse.de>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>
Date: Sat, 05 Jan 2008 18:18:25 +0000
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <1199557105493@dmwebmail.japan.chezphil.org>
In-Reply-To: <jed4sgjkhh.fsf@sykes.suse.de>
References: <jed4sgjkhh.fsf@sykes.suse.de>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> "Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:
>
>> However, there's a lot of code and I know that there are bugs in it.  I
>> just want to focus on the kernel-related issue that the strace fragment
>> that I posted brings up:  even if my user code gets completely screwed up
>> (corrupts its stack, runs out of FDs/VM/threads etc), I don't think that I
>> should see in the strace output that accept() has returned
>> ERESTARTSYS.
>
> strace always sees the raw return value, before the signal handler is
> executed and before the check for syscall restart is done.

Yes, but I should see the real final return value in another strace 
output line before I see that thread doing something else.  Correct?  
Here's the strace output again.  Look at what thread 11079 does:

[pid 11079] accept(3,  <unfinished ...>
[pid 11093] restart_syscall(<... resuming interrupted call ...>
<unfinished ...>
[pid  8799] --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
[pid 11079] <... accept resumed> 0xbfdaa73c, [16]) = ? ERESTARTSYS (To
be restarted)
[pid  8799] read(6,  <unfinished ...>
[pid 11079] fcntl64(-512, F_SETFD, FD_CLOEXEC) = -1 EBADF (Bad file descriptor)

strace reports accept() returning ERESTARTSYS, and the next thing we 
see from that thread is the call to fcntl(), which is the next thing 
that my code does.

Phil.




