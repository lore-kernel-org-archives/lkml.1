Return-Path: <linux-kernel-owner+w=401wt.eu-S1760165AbXISPcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760165AbXISPcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 11:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755195AbXISPcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 11:32:25 -0400
Received: from barikada.upol.cz ([158.194.242.200]:38312 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793AbXISPcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 11:32:24 -0400
To: Low Yucheng <ylow@andrew.cmu.edu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
In-Reply-To: <46F0E19D.8000400@andrew.cmu.edu>
References: <46F0E19D.8000400@andrew.cmu.edu>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Wed, 19 Sep 2007 17:47:56 +0200
Message-Id: <E1IY1mO-00067S-7v@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Wed, 19 Sep 2007 04:45:17 -0400
>
> [1.] Summary
> System Freeze on Particular workload with kernel 2.6.22.6
>
> [2.] Description
> System freezes on repeated application of the following command
> for f in *png ; do convert -quality 100 $f `basename $f png`jpg; done
>
> Problem is consistent and repeatable.
> Problem persists when running on a different drive, and also in pure console (no X).
>
> One time, the following error logged in syslog:
> Sep 19 04:22:11 mossnew kernel: [  301.883919] VM: killing process convert
> Sep 19 04:22:11 mossnew kernel: [  301.884382] swap_free: Unused swap offset entry 0000ff00
> Sep 19 04:22:11 mossnew kernel: [  301.884421] swap_free: Unused swap offset entry 00000300
> Sep 19 04:22:11 mossnew kernel: [  301.884456] swap_free: Unused swap offset entry 00000200
> Sep 19 04:22:11 mossnew kernel: [  301.884491] swap_free: Unused swap offset entry 0000ff00
> Sep 19 04:22:11 mossnew kernel: [  301.884527] swap_free: Unused swap offset entry 0000ff00
> Sep 19 04:22:11 mossnew kernel: [  301.884562] swap_free: Unused swap offset entry 00000100
>
> Should not be a RAM problem. RAM has survived 12 hrs of Memtest with no errors.
> Should not be a CPU problem either. I have been running CPU intensive tasks for days.
>
> [3.] Keywords
> freeze, swap_free,VM

Nice bug report, seems like from linux-source/REPORTING-BUGS.
But still:

* no relevant Cc (memory management added)
+ no output of `mount` (because if swap is on some file system, that
  *can* be another problem)
+ no information about amount of memory and its BIOS configuration

FYI, latter two (and much more) is one `dmesg` output. This output,
together with any other kernel information can be gathered by serial or
net consoles:

linux-source/Documentation/serial-console.txt
linux-source/Documentation/networking/netconsole.txt 

If console messages after freeze can be seen in text mode VGA/CRT
also, photos of it somewhere on ftp will be OK.

> [4.] /proc/version
> Linux version 2.6.22.6intelcore2 (root@mossnew) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #1 SMP Sat Sep 15 00:29:00 EDT 2007
>
> [5.] No Oops
>
> [6.] Trigger
> - Create a large number of png images. (a few hundred)
>
> - repeatedly run
> for f in *png ; do convert -quality 100 $f `basename $f png`jpg; done
>
> - This might be subjective, but the freeze seems to show up sooner if there is a CPU heavy
> process running in the background.
>
> [7] Environment
> [7.1] Software /script/ver_linux
>
> Linux mossnew 2.6.22.6intelcore2 #1 SMP Sat Sep 15 00:29:00 EDT 2007 x86_64 GNU/Linux
>
[]
____
