Return-Path: <linux-kernel-owner+w=401wt.eu-S932846AbXBERNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846AbXBERNa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 12:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932918AbXBERN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 12:13:29 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:59340 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932846AbXBERN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 12:13:28 -0500
In-Reply-To: <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EDD3B5A9-9EAB-4E0A-BE1F-3B73C3870DC8@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Date: Mon, 5 Feb 2007 12:12:59 -0500
To: Davide Libenzi <davidel@xmailserver.org>
X-Mailer: Apple Mail (2.752.3)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Since I still think that the many-thousands potential async operations
> coming from network sockets are better handled with a classical event
> machanism [1], and since smooth integration of new async syscall  
> into the
> standard POSIX infrastructure is IMO a huge win, I think we need to  
> have a
> "bridge" to allow async completions being detectable through a  
> pollable
> (by the mean of select/poll/epoll whatever) device.

Ugh, I'd rather not if we don't have to.

It seems like you could get this behaviour from issuing a poll/select 
(really?)/epoll as one of the async calls to complete.  (And you  
mention this in a later email? :))

Part of my thinking on this is that we might want it to be really  
trivial to create and wait on groups of ops.. maybe as a context.   
One of the things posix AIO wants is the notion of submitting and  
waiting on a group of ops as a "list".  That sounds like we might be  
able to implement it by issuing ops against a context, created as  
part of the submission, and then waiting for it to drain.

Being able to wait on that with file->poll() obviously requires  
juggling file-> associations which sounds like more weight than we  
might want.  Or it'd be optional and we'd get more moving parts and  
divergent paths to test.

So, sure, it's possible and not terribly difficult, but I'd rather  
avoid it if people can be convinced to get the same behaviour by  
issuing an async instance of their favourite readiness syscall.

- z
