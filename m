Return-Path: <linux-kernel-owner+w=401wt.eu-S1423372AbXBJAGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423372AbXBJAGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423376AbXBJAGa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:06:30 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:57295 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423372AbXBJAG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:06:29 -0500
Message-ID: <45CD0C07.5060601@cosmosbay.com>
Date: Sat, 10 Feb 2007 01:04:23 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
References: <patchbomb.1170193181@tetsuo.zabbo.net> <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 10 Feb 2007 01:04:33 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds a écrit :
> Ok, here's another entry in this discussion.

> 
>  - IF the system call blocks, we call the architecture-specific 
>    "schedule_async()" function before we even get any scheduler locks, and 
>    it can just do a fork() at that time, and let the *child* return to the 
>    original user space. The process that already started doing the system 
>    call will just continue to do the system call.


Well, I guess if the original program was mono-threaded, and syscall used 
fget_light(), we might have a problem here if the child try a close(). So you 
may have to disable fget_light() magic if async call is the originator of the 
syscall.

Eric
