Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbXE2V6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbXE2V6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 17:58:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXE2V6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 17:58:47 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:42693 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbXE2V6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 17:58:46 -0400
X-Greylist: delayed 1868 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 May 2007 17:58:46 EDT
Date: Tue, 29 May 2007 14:27:19 -0700
From: Zach Brown <zach.brown@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Syslets, Threadlets, generic AIO support, v6
Message-ID: <20070529212718.GH7875@mami.zabbo.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm pleased to announce the availability of version 6 of the syslet subsystem.
Ingo and I agreed that I'll handle syslet releases while he's busy with CFS.  I
copied the cc: list from Ingo's v5 announcement.  If you'd like to be dropped
(or added), please let me know.

The v6 patch series against 2.6.21 can be downloaded from:

  http://oss.oracle.com/~zab/syslets/v6/

Example applications and previous syslet releases can be found at:

 http://people.redhat.com/~mingo/syslet-patches/
  
The syslet subsystem aims to provide user-space with an efficient interface for
managing the asynchronus submission and completion of existing system calls.

The only changes since v5 are small changes that I made to support the
experimental aio patch described below.

My syslet subsystem todo list is as follows, in no particular order:

 - replace WARN_ON() calls with error handling or avoidance
 - split the x86_64-async.patch into more specific patches
 - investigate integration with ptrace
 - investigate rare ./syslet-test cpu spinning
 - provide distro kernel rpms and documentation for developers
 - compat design problems, still? http://lkml.org/lkml/2007/3/7/523

Included in this patch series is an experimental patch which reworks fs/aio.c
to reuse the syslet subsystem to process iocb requests from user space.  The
intent of this work is to simplify the code and broaden aio functionality.  

Many issues need to be addressed before this aio work could be merged:

 - support cancellation by sending signals to async_threads 
 - figure out what to do about signals from handlers, like SIGXFSZ
 - verify that heavy loads do not consume excessive cpu or memory 
 - concurrent dio writes
 - cfq gets confused, share io_context amongst threads?
 - restrict allowed operations like .aio_{r,w} methods used to

More details on this work in progress can be found in the patch.

Any and all feedback is welcome and encouraged!

 - z
