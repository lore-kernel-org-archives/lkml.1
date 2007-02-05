Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613AbXBEAPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613AbXBEAPT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 19:15:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbXBEAPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 19:15:19 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:3646 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbXBEAPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 19:15:18 -0500
X-AuthUser: davidel@xmailserver.org
Date: Sun, 4 Feb 2007 16:15:15 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: bert hubert <bert.hubert@netherlabs.nl>
cc: Zach Brown <zach.brown@oracle.com>, Benjamin LaHaise <bcrl@kvack.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regarding generic AIO, async syscalls precedent + some benchmarks
 by lighttpd
In-Reply-To: <20070204225541.GA18359@outpost.ds9a.nl>
Message-ID: <Pine.LNX.4.64.0702041548480.18633@alien.or.mcafeemobile.com>
References: <20070204225541.GA18359@outpost.ds9a.nl>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 4 Feb 2007, bert hubert wrote:

> >From two comments posted to my "blog"
> http://blog.netherlabs.nl/articles/2007/02/04/a-synchronous-programming
> 
> Excerpted from the diary of Dragonfly BSD,
> http://www.dragonflybsd.org/status/diary.shtml 
> 
>  Remove the asynchronous syscall interface. It was an idea before its time.
>  However, keep the formalization of the syscall arguments structures.
> 
> The original async syscall interface was committed in
> http://leaf.dragonflybsd.org/mailarchive/commits/2004-08/msg00067.html
> 
> Comment by Jan Kneschke, lighttpd developer, noting the lack of and need for
> aio_stat():
> 
>  Reading this article feels like reading the code I wrote in the last days
>  for lighttpd. Even if the network-io was async since the start
>  (non-blocking), the file-io wasn't. Worst of all was the stat() syscall
>  which doesn't have a async interface even in POSIX AIO. So it had to be
>  implemented with threads on our own. At http://www.lighttpd.net/benchmark/
>  you can see the impact of async vs. blocking syscalls.
> 
> Perhaps relevant.

Yes, that is some very interesting data IMO. I did not bench the GUASI 
(userspace async thread library) against AIO, but those numbers show that a 
*userspace* async syscall wrapper interface performs in the ballpark of AIO.
This leads to some hope about the ability to effectively deploy the kernel 
generic async AIO (being it fibril or kthreads based) as low-impact async 
provider for basically anything.



- Davide


