Return-Path: <linux-kernel-owner+w=401wt.eu-S1761437AbYBTBzK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761437AbYBTBzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 20:55:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756710AbYBTBy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 20:54:57 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41265 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756431AbYBTByz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 20:54:55 -0500
Date: Tue, 19 Feb 2008 19:54:49 -0600
From: Paul Jackson <pj@sgi.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, marcelo@kvack.org, daniel.spang@gmail.com,
       riel@redhat.com, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, a1426z@gawab.com,
       jonathan@jonmasters.org, zlynx@acm.org
Subject: Re: [PATCH 0/8][for -mm] mem_notify v6
Message-Id: <20080219195449.29ef9d1a.pj@sgi.com>
In-Reply-To: <20080219222828.GB28786@elf.ucw.cz>
References: <2f11576a0802090719i3c08a41aj38504e854edbfeac@mail.gmail.com>
	<20080217084906.e1990b11.pj@sgi.com>
	<20080219145108.7E96.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20080219090008.bb6cbe2f.pj@sgi.com>
	<20080219222828.GB28786@elf.ucw.cz>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel, responding to pj:
> > There is not much my customers HPC jobs can do with notification before
> > swap.  Their jobs either have the main memory they need to perform the
> > requested calculations with the desired performance, or their job is
> > useless and should be killed.  Unlike the applications you describe,
> > my customers jobs have no way, once running, to adapt to less
> > memory.
> 
> Sounds like a job for memory limits (ulimit?), not for OOM
> notification, right?

Er eh -- which one?

The only one I see that might help keep a multi-threaded job
using various kinds of memory on multiple nodes confined could
be the resident set size (RLIMIT_RSS; ulimit -m).  So far as
I can tell, that one is a pure no-op in Linux.

Here's the bash list of all available ulimit (setrlimit) options:

              -a     All current limits are reported
              -c     The maximum size of core files created
              -d     The maximum size of a process's data segment
              -e     The maximum scheduling priority ("nice")
              -f     The maximum size of files written by the shell and its children
              -i     The maximum number of pending signals
              -l     The maximum size that may be locked into memory
              -m     The maximum resident set size
              -n     The maximum number of open file descriptors (most systems do not allow this value to be set)
              -p     The pipe size in 512-byte blocks (this may not be set)
              -q     The maximum number of bytes in POSIX message queues
              -r     The maximum real-time scheduling priority
              -s     The maximum stack size
              -t     The maximum amount of cpu time in seconds
              -u     The maximum number of processes available to a single user
              -v     The maximum amount of virtual memory available to the shell
              -x     The maximum number of file locks

Did I miss seeing one that would be useful?

Actually, given the chronic problem we've had over the years accounting
for how much memory in total (including text, data, stack, mapped
files, locked pages, kernel memory structures that an application is
using many of, ...  I'd be suprised if any such ulimit existed that
actually worked for this purpose (confining an HPC jobs to using almost
exactly all the memory available to it, but no more.)

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
