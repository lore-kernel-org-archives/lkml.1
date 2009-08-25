Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbZHYP6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbZHYP6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 11:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbZHYP6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 11:58:17 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:34010 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127AbZHYP6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:58:16 -0400
Message-ID: <4A940A11.2040706@petalogix.com>
Date: Tue, 25 Aug 2009 17:58:09 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>,
       oberpar@linux.vnet.ibm.com,
       "subrata@linux.vnet.ibm.com" <subrata@linux.vnet.ibm.com>
Subject: Gcov and lcov
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I am trying to run gcov to see source code coverage.

First of all there should be DEBUG_FS instead of DEBUG in documentation.
diff --git a/Documentation/gcov.txt b/Documentation/gcov.txt
index 40ec633..e7ca647 100644
--- a/Documentation/gcov.txt
+++ b/Documentation/gcov.txt
@@ -47,7 +47,7 @@ Possible uses:
 
 Configure the kernel with:
 
-        CONFIG_DEBUGFS=y
+        CONFIG_DEBUG_FS=y
         CONFIG_GCOV_KERNEL=y
 

I am missing any option to be possible to stop capture coveradge data.
I am running in on Microblaze and it takes me a lot of time to grap all
gcda data from debugfs.

I can't run gcov on Microblaze that's why I have to run option b in doc
"gcov is run on the BUILD machine"


I copied gcda to kernel source code and currently I am able to generate
statistic for every file.
That copy I have to do because I need to connect counters value with
source file

[root@monstr linux-monstr_eu-commit]# mb-linux-gcov -o
arch/microblaze/kernel/ heartbeat.c
File 'arch/microblaze/kernel/heartbeat.c'
Lines executed:100.00% of 24
arch/microblaze/kernel/heartbeat.c:creating 'heartbeat.c.gcov'

File
'/home/projects/xils/_full/software/linux-monstr_eu-commit/arch/microblaze/include/asm/io.h'
Lines executed:100.00% of 3
/home/projects/xils/_full/software/linux-monstr_eu-commit/arch/microblaze/include/asm/io.h:creating
'io.h.gcov'


And content of that file

[root@monstr linux-monstr_eu-commit]# cat heartbeat.c.gcov
        -:    0:Source:arch/microblaze/kernel/heartbeat.c
        -:    0:Graph:arch/microblaze/kernel/heartbeat.gcno
        -:    0:Data:arch/microblaze/kernel/heartbeat.gcda
        -:    0:Runs:0
        -:    0:Programs:0
        -:    1:/*
        -:    2: * Copyright (C) 2007-2009 Michal Simek <monstr@monstr.eu>
        -:    3: * Copyright (C) 2007-2009 PetaLogix
        -:    4: * Copyright (C) 2006 Atmark Techno, Inc.
        -:    5: *
        -:    6: * This file is subject to the terms and conditions of
the GNU General Public
        -:    7: * License. See the file "COPYING" in the main directory
of this archive
        -:    8: * for more details.
        -:    9: */
        -:   10:
        -:   11:#include <linux/sched.h>
        -:   12:#include <linux/io.h>
        -:   13:
        -:   14:#include <asm/setup.h>
        -:   15:#include <asm/page.h>
        -:   16:#include <asm/prom.h>
        -:   17:
        -:   18:static unsigned int base_addr;
        -:   19:
        -:   20:void heartbeat(void)
    69918:   21:{
        -:   22:        static unsigned int cnt, period, dist;
        -:   23:
    69918:   24:        if (base_addr) {
    71379:   25:                if (cnt == 0 || cnt == dist)
     1461:   26:                        out_be32(base_addr, 1);
    68457:   27:                else if (cnt == 7 || cnt == dist + 7)
     1460:   28:                        out_be32(base_addr, 0);
        -:   29:
    69918:   30:                if (++cnt > period) {
      730:   31:                        cnt = 0;
        -:   32:                        /*
        -:   33:                         * The hyperbolic function below
modifies the heartbeat
        -:   34:                         * period length in dependency of t
....



Then I would like to use lcov and generate html sites. This could be
possible but I haven't found
a way how to do it.

I used lcov --capture --directory . --output-file out

There is this mishmash in version string
/home/projects/xils/_full/software/linux-monstr_eu-commit/kernel/spinlock.gcno:version
'401*', prefer '401p'
/home/projects/xils/_full/software/linux-monstr_eu-commit/kernel/spinlock.gcda:version
'401*', prefer version '401p'

and then genhtml out which end with fault because my out file contain
wrong patches where is part of path repeated.
arch/microblaze/kernel/arch/microblaze/kernel

It is a little bit mess but I hope that you understand what I mean. If
not please let me know.
Can you give me any hint how to do it?

Thanks,
Michal



-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

