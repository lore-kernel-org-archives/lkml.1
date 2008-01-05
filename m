Return-Path: <linux-kernel-owner+w=401wt.eu-S1754079AbYAEOYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbYAEOYz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 09:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbYAEOYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 09:24:46 -0500
Received: from japan.chezphil.org ([77.240.5.4]:5984 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbYAEOYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:24:45 -0500
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>, " Frederik Deweerdt" <deweerdt@free.fr>
Date: Sat, 05 Jan 2008 14:24:35 +0000
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <1199543075452@dmwebmail.japan.chezphil.org>
In-Reply-To: <477F6B23.3050108@gmail.com>
References: <477F6B23.3050108@gmail.com>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 01/05/2008 11:31 AM, Jiri Slaby wrote:
>> Do not remove CCed people.
>> 
>> On 01/05/2008 02:38 AM, Phil Endecott wrote:
>>> timezone go and play with http://demos.anyterm.org/bastet/anyterm.html
>>> while I sleep....
>> 
>> Service Temporarily Unavailable

It failed at 0325 GMT thanks to the many of you who played, but 
unfortunately it was an assert somewhere unrelated that failed.  I'll 
start it up again shortly.

> bastet? the tetris in which you always get the worst block you can get at the
> moment :)?

That's the one!  At the time it was the only game that worked with my 
VT100-to-HTML conversion.

> Do you serve the pages by the code which causes the problems?

Yes.

> Could we see more of the server's code, even with multi-threading, which you
> mentioned etc.

It's all here:  https://svn.chezphil.org/anyterm/trunk/daemon/
In particular:  https://svn.chezphil.org/libpbe/trunk/src/Daemon.cc
However, there's a lot of code and I know that there are bugs in it.  I 
just want to focus on the kernel-related issue that the strace fragment 
that I posted brings up:  even if my user code gets completely screwed 
up (corrupts its stack, runs out of FDs/VM/threads etc), I don't think 
that I should see in the strace output that accept() has returned 
ERESTARTSYS.  I should always see accept() returning a legitimate 
result before seeing that thread doing the next syscall.  Right?


Cheers,  Phil.



