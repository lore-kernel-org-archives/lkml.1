Return-Path: <linux-kernel-owner+w=401wt.eu-S933483AbXBEVgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933483AbXBEVgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:36:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933480AbXBEVgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:36:24 -0500
Received: from outpost.ds9a.nl ([213.244.168.210]:53448 "EHLO outpost.ds9a.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933475AbXBEVgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:36:22 -0500
Date: Mon, 5 Feb 2007 22:36:19 +0100
From: bert hubert <bert.hubert@netherlabs.nl>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070205213618.GA30923@outpost.ds9a.nl>
Mail-Followup-To: bert hubert <bert.hubert@netherlabs.nl>,
	Davide Libenzi <davidel@xmailserver.org>,
	Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Zach Brown <zach.brown@oracle.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
	Benjamin LaHaise <bcrl@kvack.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net> <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu> <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org> <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org> <20070202222110.GA1212@elte.hu> <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702021525370.5219@alien.or.mcafeemobile.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 02, 2007 at 03:37:09PM -0800, Davide Libenzi wrote:

> Since I still think that the many-thousands potential async operations 
> coming from network sockets are better handled with a classical event 
> machanism [1], and since smooth integration of new async syscall into the 
> standard POSIX infrastructure is IMO a huge win, I think we need to have a 
> "bridge" to allow async completions being detectable through a pollable 
> (by the mean of select/poll/epoll whatever) device.

> [1] Unless you really want to have thousands of kthreads/fibrils lingering 
>     on the system.

>From my end as an application developer, yes please. Either make it
perfectly ok to have thousands of outstanding asynchronous system calls (I
work with thousands of separate sockets), or allow me to select/poll/epoll
on the "async fd".

Alternatively, something like SIGIO ('SIGASYS'?) might be considered, but,
well, the fd might be easier.

In fact, perhaps the communication channel might simply *be* an fd. Queueing
up syscalls sounds remarkably like sending datagrams. 

	Bert

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
