Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbYAETTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbYAETTU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 14:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYAETTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 14:19:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:59062 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756170AbYAETTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 14:19:10 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
Cc: "Jiri Slaby" <jirislaby@gmail.com>, <linux-kernel@vger.kernel.org>,
       "Frederik Deweerdt" <deweerdt@free.fr>
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
References: <jed4sgjkhh.fsf@sykes.suse.de>
	<1199557105493@dmwebmail.japan.chezphil.org>
X-Yow: When this load is DONE I think I'll wash it AGAIN..
Date: Sat, 05 Jan 2008 20:19:08 +0100
In-Reply-To: <1199557105493@dmwebmail.japan.chezphil.org> (Phil Endecott's
	message of "Sat\, 05 Jan 2008 18\:18\:25 +0000")
Message-ID: <je3atcjd1v.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:

> Andreas Schwab wrote:
>> "Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:
>>
>>> However, there's a lot of code and I know that there are bugs in it.  I
>>> just want to focus on the kernel-related issue that the strace fragment
>>> that I posted brings up:  even if my user code gets completely screwed up
>>> (corrupts its stack, runs out of FDs/VM/threads etc), I don't think that I
>>> should see in the strace output that accept() has returned
>>> ERESTARTSYS.
>>
>> strace always sees the raw return value, before the signal handler is
>> executed and before the check for syscall restart is done.
>
> Yes, but I should see the real final return value in another strace output
> line before I see that thread doing something else.  Correct?

No.  As far as strace is concerned the syscall has finished.  Since it
isn't restarted, you won't see it again in the trace.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
