Return-Path: <linux-kernel-owner+w=401wt.eu-S1754356AbZITLJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356AbZITLJB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 07:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbZITLJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 07:09:01 -0400
Received: from smtp09.online.nl ([194.134.42.54]:47961 "EHLO smtp09.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZITLJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 07:09:00 -0400
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Sun, 20 Sep 2009 13:09:02 +0200
To: linux-kernel@vger.kernel.org
From: Ro Achterberg <ro@greyhat.nl>
Subject: Fwd: Re: bug/section mismatches on 2.6.31 ?
Cc: sam@ravnborg.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Online-Scanned: by Cloudmark authority (on smtp09.online.nl)
Message-Id: <20090920110903.384901E1B4@smtp09.online.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>Date: Sun, 20 Sep 2009 12:12:50 +0200
>To: Sam Ravnborg <sam@ravnborg.org>
>From: Ro Achterberg <ro@greyhat.nl>
>Subject: Re: bug/section mismatches on 2.6.31 ?
>
>At 00:29 20-9-2009, you wrote:
>>On Sat, Sep 19, 2009 at 11:59:13PM +0200, Ro Achterberg wrote:
>>> Hi all,
>>> 
>>> I'm experiencing a kernel build problem that I haven't seen before. For some reason, make is telling me 'WARNING: modpost: Found 3133 section mismatch(es).' during the process. The currently running kernel is a 2.6.29.4-grsec (custom configuration) on CentOS 5.2. Gcc's version is 4.1.2, which I left untouched. I've built kernels on this machine before, without problems.
>>> 
>>> I've attached a log of 'make CONFIG_DEBUG_SECTION_MISMATCH=y' which is not making a lot of sense to me, which is why I'm forwarding it to you, hoping that you might be able to tell me what I'm doing wrong here or whether perhaps I've encountered a bug here. Any insights would be greatly appreciated!
>>> 
>>
>>Hi Ro.
>>
>>I assume your are trying to build latest kernel.
>>I could not reproduce it here - and from your logs
>>nothing told me what is wrong at your side.
>>
>>What I see is that modpost complain about a reference from .data to .text.
>>And this is ok - so there is nothing to complain about.
>>
>>I see a lot of warnings in your build that I do not see here.
>>You seem to have more warnings enabled than is standard - but I do not see
>>how this happens in your case.
>>kbuild should ignore CFLAGS settings from the environment but maybe we fail
>>to ignore CFLAGS for host programs??
>>
>>First step is to isolate where to look for the issue.
>>Try to run modpost manually:
>>
>>    modpost arch/x86/crypto/aes-x86_64.o
>>
>>
>>Does it generate the same warnigns as seen in your log - I hope so.
>>
>>Then try to run modpost on the same .o file on another machine
>>that does not exhibit this issue.
>>Does the other machine now suddenly show the warnings?
>>
>>In other words is this due to something in the .o file
>>or due to something with modpost?
>>I assume the latter.
>>
>>You could also try to debug modpost a little - try to insert
>>a breakpoint around check_section_mismatch() and see when we trigger
>>a mismatch.
>>That may give you a clue too.
>>[You need to adjust HOSTCFLAGS so -O2 is replaced with -g to do this.
>>See top-level Makefile.
>>
>>        Sam
>
>Hi Sam,
>
>Many thanks for your quick and elaborate response. As you've undoubtedly noticed, I had cc'd Brad Spengler in this, who's been able to tell me that it is in fact grsec causing these section mismatch warnings. According to Brad: 'PaX modifies the modpost script so that we can get statistics on things like how many writable function pointers are in the kernel.  These are considered "section mismatches."  They don't affect the operation of the kernel, or its ability to be compiled.' I'll be confidently placing the server in the colocation rack now.
>
>Take care, Ro 

