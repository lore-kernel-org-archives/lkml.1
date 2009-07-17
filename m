Return-Path: <linux-kernel-owner+w=401wt.eu-S1758004AbZGQXd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758004AbZGQXd7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 19:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755128AbZGQXd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 19:33:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46706 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754836AbZGQXd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 19:33:58 -0400
Date: Fri, 17 Jul 2009 19:33:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Noah Watkins <jayhawk@soe.ucsc.edu>
cc: LKML <linux-kernel@vger.kernel.org>, srostedt@redhat.com
Subject: Re: [ANNOUNCE][RFC] trace-cmd - command line reader for ftrace
In-Reply-To: <20090717174523.GA14502@martini>
Message-ID: <alpine.DEB.2.00.0907171932170.9337@gandalf.stny.rr.com>
References: <alpine.DEB.2.00.0907171009050.9337@gandalf.stny.rr.com> <20090717174523.GA14502@martini>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Jul 2009, Noah Watkins wrote:

> root@martini:~/Projects/trace-cmd# ./trace-cmd record -p function_graph ls /bin
>   plugin function_graph
> bash	 bzip2recover  dash		     dumpkeys	 gunzip     login
> <... directory listing pruned ...>
> ntfs-3g.probe	rm	  stty	      uname	       zforce
> *** glibc detected *** ./trace-cmd: malloc(): memory corruption (fast):

Was this on the trace-cmd record or report? If it was the record, do not 
use function_graph with "optimize_for_size", there's a known issue on
x86_32 with that option that gcc breaks the function graph tracer.

Try one of the other trace plugins, and if you still have issues, let
me know. Also, I just updated the code, because I found a bug in the 
reporting on 32bit archs.

-- Steve



> 0x09c70038 ***
> ======= Backtrace: =========
> /lib/tls/i686/cmov/libc.so.6[0xb7efa604]
> /lib/tls/i686/cmov/libc.so.6[0xb7efd5b6]
> /lib/tls/i686/cmov/libc.so.6(__libc_malloc+0x95)[0xb7efe9c5]
> ./trace-cmd[0x804948a]
> ./trace-cmd[0x804963f]
> ./trace-cmd[0x804b06e]
> ./trace-cmd[0x804b84f]
> /lib/tls/i686/cmov/libc.so.6(__libc_start_main+0xe5)[0xb7ea1775]
> ./trace-cmd[0x8049191]
> ======= Memory map: ========
> 08048000-08054000 r-xp 00000000 08:08 62598
> /home/nwatkins/Projects/trace-cmd/trace-cmd
> 08054000-08055000 r--p 0000b000 08:08 62598
> /home/nwatkins/Projects/trace-cmd/trace-cmd
> 08055000-08056000 rw-p 0000c000 08:08 62598
> /home/nwatkins/Projects/trace-cmd/trace-cmd
> 09c70000-09c91000 rw-p 00000000 00:00 0          [heap]
> b7d00000-b7d21000 rw-p 00000000 00:00 0 
> b7d21000-b7e00000 ---p 00000000 00:00 0 
> b7e8a000-b7e8b000 rw-p 00000000 00:00 0 
> b7e8b000-b7fe7000 r-xp 00000000 08:07 6174       /lib/tls/i686/cmov/libc-2.9.so
> b7fe7000-b7fe8000 ---p 0015c000 08:07 6174       /lib/tls/i686/cmov/libc-2.9.so
> b7fe8000-b7fea000 r--p 0015c000 08:07 6174       /lib/tls/i686/cmov/libc-2.9.so
> b7fea000-b7feb000 rw-p 0015e000 08:07 6174       /lib/tls/i686/cmov/libc-2.9.so
> b7feb000-b7fee000 rw-p 00000000 00:00 0 
> b7ff2000-b7fff000 r-xp 00000000 08:07 2596       /lib/libgcc_s.so.1
> b7fff000-b8000000 r--p 0000c000 08:07 2596       /lib/libgcc_s.so.1
> b8000000-b8001000 rw-p 0000d000 08:07 2596       /lib/libgcc_s.so.1
> b8001000-b8004000 rw-p 00000000 00:00 0 
> b8004000-b8005000 r-xp 00000000 00:00 0          [vdso]
> b8005000-b8021000 r-xp 00000000 08:07 2554       /lib/ld-2.9.so
> b8021000-b8022000 r--p 0001b000 08:07 2554       /lib/ld-2.9.so
> b8022000-b8023000 rw-p 0001c000 08:07 2554       /lib/ld-2.9.so
> bfb81000-bfb96000 rw-p 00000000 00:00 0          [stack]
> Aborted
> root@martini:~/Projects/trace-cmd# 
> 
> 
