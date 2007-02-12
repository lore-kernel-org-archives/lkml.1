Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbXBLQhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbXBLQhW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 11:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964959AbXBLQhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 11:37:22 -0500
Received: from mpemail.mpe.mpg.de ([130.183.137.110]:34525 "EHLO
	mpemail.mpe.mpg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964960AbXBLQhV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 11:37:21 -0500
From: "Martin A. Fink" <fink@mpe.mpg.de>
Organization: MPE
To: linux-kernel@vger.kernel.org
Subject: Re: SATA-performance: Linux vs. FreeBSD
Date: Mon, 12 Feb 2007 17:37:12 +0100
User-Agent: KMail/1.8
References: <200702121502.17130.fink@mpe.mpg.de> <p73abzji9xi.fsf@bingen.suse.de>
In-Reply-To: <p73abzji9xi.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200702121737.12882.fink@mpe.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some more info:

:~> strace -c -T -o trace.out dd if=/dev/zero of=test.txt bs=10MB count=200

200+0 Datensätze ein
200+0 Datensätze aus
2000000000 bytes (2,0 GB) copied, 52,8632 seconds, 37,8 MB/s

test.txt:

% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 93.26    6.845265       33555       204           write
  6.41    0.470283       11757        40        18 open
  0.32    0.023687         116       205           read
  0.00    0.000149           9        16           mmap2
  0.00    0.000119          40         3           munmap
  0.00    0.000081           3        24           close
  0.00    0.000068           6        11           old_mmap
  0.00    0.000064           3        20           fstat64
  0.00    0.000040           4        10           rt_sigaction
  0.00    0.000036          12         3           madvise
  0.00    0.000014           7         2           clock_gettime
  0.00    0.000010           3         3           brk
  0.00    0.000008           8         1           _sysctl
  0.00    0.000007           7         1         1 access
  0.00    0.000006           6         1           mprotect
  0.00    0.000005           5         1           futex
  0.00    0.000004           4         1           uname
  0.00    0.000004           4         1           _llseek
  0.00    0.000003           3         1           rt_sigprocmask
  0.00    0.000003           3         1           getrlimit
  0.00    0.000003           3         1           set_thread_area
  0.00    0.000003           3         1           set_tid_address
------ ----------- ----------- --------- --------- ----------------
100.00    7.339862                   551        19 total

This means, that the CPU is only 7.3 of 52.8 seconds working. This is what one 
can hear: If I run programs where the time they need is the same time as 
strace says, then I have 100% CPU load and the cpu fan starts to blow 
heavily. In the case here, the heat fan does not do anything. It looks like 
the SATA driver simply blocks the CPU while doing whatever...
