Return-Path: <linux-kernel-owner+w=401wt.eu-S1753458AbXC2Nqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbXC2Nqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 09:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbXC2Nqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 09:46:36 -0400
Received: from fwstl1-1.wul.qc.ec.gc.ca ([205.211.132.24]:23870 "EHLO
	ecqcmtlbh.quebec.int.ec.gc.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753458AbXC2Nqf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 09:46:35 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: staircase deadline 0.36 backport 2.6.18.8 and 2.6.19.7
Date: Thu, 29 Mar 2007 09:46:12 -0400
Message-ID: <8E8F647D7835334B985D069AE964A4F7033AB5BA@ECQCMTLMAIL1.quebec.int.ec.gc.ca>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: staircase deadline 0.36 backport 2.6.18.8 and 2.6.19.7
Thread-Index: AcdyCJ0/cum0Z6ixQp27Gjl1KvDCxw==
From: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@EC.GC.CA>
To: "linux list" <linux-kernel@vger.kernel.org>,
       "ck list" <ck@vds.kolivas.org>
Cc: "Con Kolivas" <kernel@kolivas.org>
X-OriginalArrivalTime: 29 Mar 2007 13:46:13.0109 (UTC) FILETIME=[9D806250:01C77208]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Backports of the staircase deadline cpu scheduler for 2.6.18.8 and
2.6.19.7 kernels are available at http://linux-dev.qc.ec.gc.ca/.

Also, Debian Etch 4.0 kernels for both i686 and x86_64 are available.
Fedora Core 6 kernels might also be available later today/tomorrow.

Both patches looks quite stable.  I've been able to fix the 2.6.19
backport by reversing this patch: "[PATCH] move_task_off_dead_cpu()
should be called with disabled ints" (see
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.20.y.git;a=co
mmit;h=054b9108e01ef27e2e6b32b4226abb6024626f06).  I don't know if this
bug (see
http://linux-dev.qc.ec.gc.ca/kernel/debian/etch/x86_64/2.6.19/bug-2.6.19
.7-rsdl-033.jpg) can also affect a Vanilla 2.6.19.7 kernel or even the
actual mainline?  Duno if it would be worth investigating a bit further?

Although, here is a top of a 2.6.19.7 + SD 0.36 patch in action while
building 3 kernels at once and running a glxgears in foreground:
top - 12:39:39 up 17 min,  2 users,  load average: 5.84, 4.37, 2.20
Tasks: 162 total,   5 running, 157 sleeping,   0 stopped,   0 zombie
Cpu0  : 87.0%us, 13.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Cpu1  : 88.4%us, 11.6%sy,  0.0%ni,  0.0%id,  0.0%wa,  0.0%hi,  0.0%si,
0.0%st
Mem:   2059940k total,  1249476k used,   810464k free,   137112k buffers
Swap:  1959888k total,        0k used,  1959888k free,   620552k cached

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
15970 root      33   0 45016  36m 4520 R   18  1.8   0:00.54 cc1
16025 root       1   0 40904  32m 4444 R   18  1.6   0:00.53 cc1
16015 root      33   0 40620  32m 4496 R   17  1.6   0:00.52 cc1
13401 th0ma7     1   0 42356 9420 6700 R    6  0.5   1:16.13 glxgears
16589 root       1   0  3756  400  192 S    1  0.0   0:01.04 faked-sysv
 5012 root       5   0 91208  46m 7200 S    0  2.3   0:11.57 Xorg

Note that my KDE session/firefox/kontact/etc. was still pretty
responsive!

Vincent Fortier
Informatique
Environnement Canada



