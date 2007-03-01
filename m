Return-Path: <linux-kernel-owner+w=401wt.eu-S933238AbXCALWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933238AbXCALWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 06:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbXCALWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 06:22:17 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56031 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933238AbXCALWQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 06:22:16 -0500
Date: Thu, 1 Mar 2007 14:20:19 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070301112017.GB27381@2ka.mipt.ru>
References: <Pine.LNX.4.64.0702260938450.12485@woody.linux-foundation.org> <20070301095402.GA14603@elte.hu> <20070301105928.GA15709@2ka.mipt.ru> <200703011214.45144.dada1@cosmosbay.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <200703011214.45144.dada1@cosmosbay.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (2ka.mipt.ru [0.0.0.0]); Thu, 01 Mar 2007 14:20:59 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 12:14:44PM +0100, Eric Dumazet (dada1@cosmosbay.com) wrote:
> On Thursday 01 March 2007 11:59, Evgeniy Polyakov wrote:
> 
> > Yes, it is about 98-100% in both cases.
> > I've just re-run tests on my amd64 test machine without debug options:
> >
> > epoll		4794.23
> > kevent		6468.95
> >
> 
> It would be valuable if you could post oprofile results (CPU_CLK_UNHALTED) for 
> both tests.

I can't - oprofile does not work on this x86_64 machine:

#opcontrol --setup --vmlinux=/home/s0mbre/aWork/git/linux-2.6.kevent/vmlinux
# opcontrol --start
Using default event: CPU_CLK_UNHALTED:100000:0:1:1
/usr/bin/opcontrol: line 994: /dev/oprofile/0/enabled: No such file or
directory
/usr/bin/opcontrol: line 994: /dev/oprofile/0/event: No such file or
directory
/usr/bin/opcontrol: line 994: /dev/oprofile/0/count: No such file or
directory
/usr/bin/opcontrol: line 994: /dev/oprofile/0/kernel: No such file or
directory
/usr/bin/opcontrol: line 994: /dev/oprofile/0/user: No such file or
directory
/usr/bin/opcontrol: line 994: /dev/oprofile/0/unit_mask: No such file or
directory

# ls -l /dev/oprofile/
total 0
drwxr-xr-x 1 root root 0 2007-03-01 09:41 1
drwxr-xr-x 1 root root 0 2007-03-01 09:41 2
drwxr-xr-x 1 root root 0 2007-03-01 09:41 3
-rw-r--r-- 1 root root 0 2007-03-01 09:41 backtrace_depth
-rw-r--r-- 1 root root 0 2007-03-01 09:41 buffer
-rw-r--r-- 1 root root 0 2007-03-01 09:41 buffer_size
-rw-r--r-- 1 root root 0 2007-03-01 09:41 buffer_watershed
-rw-r--r-- 1 root root 0 2007-03-01 09:41 cpu_buffer_size
-rw-r--r-- 1 root root 0 2007-03-01 09:41 cpu_type
-rw-rw-rw- 1 root root 0 2007-03-01 09:41 dump
-rw-r--r-- 1 root root 0 2007-03-01 09:41 enable
-rw-r--r-- 1 root root 0 2007-03-01 09:41 pointer_size
drwxr-xr-x 1 root root 0 2007-03-01 09:41 stats

> Thank you

-- 
	Evgeniy Polyakov
