Return-Path: <linux-kernel-owner+w=401wt.eu-S1946168AbXBBXhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946168AbXBBXhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 18:37:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946171AbXBBXhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 18:37:14 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:2814 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946169AbXBBXhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 18:37:12 -0500
X-AuthUser: davidel@xmailserver.org
Date: Fri, 2 Feb 2007 15:37:09 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070202222110.GA1212@elte.hu>
Message-ID: <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202222110.GA1212@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Ingo Molnar wrote:

> in fact an app could also /trigger/ the execution of a syscall in a 
> different context - to create parallelism artificially - without any 
> blocking event. So we could do:
> 
>   cookie1 = sys_async(sys_read, params);
>   cookie2 = sys_async(sys_write, params);
> 
>   [ ... calculation loop ... ]
> 
>   wait_on_async_syscall(cookie1);
>   wait_on_async_syscall(cookie2);
> 
> or something like that. Without user-space having to create threads 
> itself, etc. So basically, we'd make kernel threads more useful, and 
> we'd make threading safer - by only letting syscalls thread.

Since I still think that the many-thousands potential async operations 
coming from network sockets are better handled with a classical event 
machanism [1], and since smooth integration of new async syscall into the 
standard POSIX infrastructure is IMO a huge win, I think we need to have a 
"bridge" to allow async completions being detectable through a pollable 
(by the mean of select/poll/epoll whatever) device.
In that way you can handle async operations with the best mechanism that 
is fit for them, and gather them in a single async scheduler.



[1] Unless you really want to have thousands of kthreads/fibrils lingering 
    on the system.



- Davide


