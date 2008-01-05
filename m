Return-Path: <linux-kernel-owner+w=401wt.eu-S1757047AbYAETfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047AbYAETfc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:35:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756364AbYAETfZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:35:25 -0500
Received: from japan.chezphil.org ([77.240.5.4]:5794 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbYAETfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:35:24 -0500
To: "Andreas Schwab" <schwab@suse.de>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>
Date: Sat, 05 Jan 2008 19:35:09 +0000
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <1199561709625@dmwebmail.japan.chezphil.org>
In-Reply-To: <je3atcjd1v.fsf@sykes.suse.de>
References: <je3atcjd1v.fsf@sykes.suse.de>
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
>> Andreas Schwab wrote:
>>> "Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:
>>>> However, there's a lot of code and I know that there are bugs in it.  I
>>>> just want to focus on the kernel-related issue that the strace fragment
>>>> that I posted brings up:  even if my user code gets completely screwed up
>>>> (corrupts its stack, runs out of FDs/VM/threads etc), I don't think that I
>>>> should see in the strace output that accept() has returned
>>>> ERESTARTSYS.
>>>
>>> strace always sees the raw return value, before the signal handler is
>>> executed and before the check for syscall restart is done.
>>
>> Yes, but I should see the real final return value in another strace output
>> line before I see that thread doing something else.  Correct?
>
> No.  As far as strace is concerned the syscall has finished.  Since it
> isn't restarted, you won't see it again in the trace.

Sorry for being dense, but what is the implication of your comment 
"Since it isn't restarted" ?  Are you saying that the kernel isn't 
going to restart it and will have converted it to EINTR and returned 
that to user-space, and that this modified return value is not reported 
by strace?


Phil.




