Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbYGFX0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbYGFX0c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 19:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756941AbYGFX0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 19:26:25 -0400
Received: from c-71-205-80-56.hsd1.mi.comcast.net ([71.205.80.56]:45621 "EHLO
	monolith.glofar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbYGFX0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 19:26:24 -0400
X-Greylist: delayed 4277 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jul 2008 19:26:24 EDT
Date: Sun, 6 Jul 2008 14:00:22 -0400 (EDT)
From: George Glover <hyperborean@comcast.net>
To: linux-kernel@vger.kernel.org
Subject: Runtime accounting bug?
Message-ID: <alpine.LNX.1.00.0807061330000.21901@monolith>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I run two copies (dual processor system) of "mprime" from the GIMPS 
project. After a while running (weeks?) the cumulative runtime reported by 
top increments faster than real time, then after a while (unknown how long) 
the value increments normally again.  Then, maybe something overflows - but 
runtime accounting stops entirely even though the process is in the run state.

(mprime is a cpu-bound low priority process like seti@home and friends.)

I presently have a stuck process and a one that should soon start to 
increment faster than possible.

I have verified that the "stuck" process is indeed running since it continues
to generate output.

Here is the "stuck" process:

cat /proc/4126/stat; sleep 5;  cat /proc/4126/stat
4126 (mprime) R 2984 4126 2984 34819 4126 4202496 16530 0 4 0 2124505930 661087 0 0 39 19 1 0 8442861 21483520 3733 4294967295 134512640 138881564 3220348480 3220345732 135248565 0 0 0 16386 0 0 0 17 1 0 0 0 0 0
4126 (mprime) R 2984 4126 2984 34819 4126 4202496 16530 0 4 0 2124505930 661087 0 0 39 19 1 0 8442861 21483520 3733 4294967295 134512640 138881564 3220348480 3220345736 135241038 0 0 0 16386 0 0 0 17 1 0 0 0 0 0


Here is the other process started more recently:

cat /proc/18312/stat; sleep 5;  cat /proc/18312/stat
18312 (mprime) R 2969 18312 2969 34818 18312 4202496 7657 0 1 0 140549087 660363 0 0 39 19 1 0 346388363 35483648 7152 4294967295 134512640 138881564 3221166480 3221163732 135246526 0 0 0 16386 0 0 0 17 1 0 0 0 0 0
18312 (mprime) R 2969 18312 2969 34818 18312 4202496 7657 0 1 0 140549510 660364 0 0 39 19 1 0 346388363 35483648 7152 4294967295 134512640 138881564 3221166480 3221163740 135280398 0 0 0 16386 0 0 0 17 1 0 0 0 0 0


Top output sorted by cpu time:

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+    TIME COMMAND
  4126 zed       39  19 20980  14m  968 R    0  0.4 354194:30  5903h mprime
18312 zed       39  19 34652  27m  952 R   84  0.8  23544:49 392,24 mprime


uptime:
12:50:47 up 60 days, 18:58, 25 users,  load average: 2.20, 2.21, 2.26

cat /proc/version
Linux version 2.6.25.1 (root@(none)) (gcc version 4.1.2) #3 SMP PREEMPT Tue
May 6 01:53:17 EDT 2008

The machine is a dual processor 1.2Ghz Athlon MP system.  It's generally 
problem free with maybe 1 bit error a year reported from the ecc ram.

As the problem takes so long to repeat I do not know how to approach it. 
It has also been present for the past few kernels, since 2.6.23 if I 
recall.

Anyone have any thoughts? It seems more cosmetic than critical.

George

