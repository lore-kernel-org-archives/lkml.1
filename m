Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYEQSi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYEQSi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 14:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbYEQSiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 14:38:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570AbYEQSiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 14:38:21 -0400
Date: Sat, 17 May 2008 11:37:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alistair John Strachan <alistair@devzero.co.uk>
cc: Jens Axboe <jens.axboe@oracle.com>, xfs@oss.sgi.com,
       Neil Brown <neilb@suse.de>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: XFS/md/blkdev warning (was Re: Linux 2.6.26-rc2)
In-Reply-To: <200805171922.56272.alistair@devzero.co.uk>
Message-ID: <alpine.LFD.1.10.0805171131000.3020@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805120731480.3188@woody.linux-foundation.org> <alpine.LFD.1.10.0805120933310.3019@woody.linux-foundation.org> <20080512164920.GE16217@kernel.dk> <200805171922.56272.alistair@devzero.co.uk>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2008, Alistair John Strachan wrote:
>
> My guess is that when the kernel runs out of MemFree and starts reclaiming the 
> cache, something is deadlocking somewhere. Just doing a:
> 
> cat /dev/zero >/path/to/file

Do this on the console (and having a serial console or working netconsole 
is a wonderful thing to log it, because otherwise it will generally just 
scroll off the screen), and trigger SysRQ-w. That dumps all blocked tasks 
to the screen.

You may need to do

	echo 1 > /proc/sys/kernel/sysrq 

before that to enable it.

(Or if you have some things still running because they haevn't hit the 
lock that causes the deadlock, you can try

	echo w > /proc/sysrq-trigger

rather than the key combination).

			Linus
