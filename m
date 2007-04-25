Return-Path: <linux-kernel-owner+w=401wt.eu-S1423300AbXDYImY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423300AbXDYImY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 04:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423301AbXDYImX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 04:42:23 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:50529 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423300AbXDYImW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 04:42:22 -0400
Date: Wed, 25 Apr 2007 10:42:20 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Big reserved mappings on x86_64
Message-ID: <Pine.LNX.4.61.0704251035480.19711@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,


I noticed that on x86_64, the VSZ indicator (`ps u $$`) is quite high, 
compared to i386 or sparc64.

10:32 ichi:~ > ps u $$ # i686
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
jengelh   4950  0.2  0.2   4776  2112 pts/4    Ss   10:32   0:00 -bash
10:36 sun:~ > ps u $$ # sparc64
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
jengelh  17842  0.0  0.0   6320  1960 pts/0    Ss   10:36   0:00 -bash
10:36 opteron:~ > ps u $$ # x86_64
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
jengelh   4403  0.0  0.2  23808  2632 pts/3    Ss   10:27   0:00 -bash

I actually took a look at `pmap $$`, which reveals that a lot of shared 
libraries map 2044K or 2048K unreadable-unwritable-private 
mappings...for _what_ purpose?

10:37 opteron:~ > pmap $$
4403: bash
START       SIZE     RSS   DIRTY PERM MAPPING
2ae6cca70000    212K    172K      0K r-xp /lib64/libreadline.so.5.2
2ae6ccaa5000   2044K      0K      0K ---p /lib64/libreadline.so.5.2 <--
2ae6ccca4000      4K      4K      4K r--p /lib64/libreadline.so.5.2
2ae6ccca5000     28K     28K     28K rw-p /lib64/libreadline.so.5.2
2ae6cccac000      8K      8K      8K rw-p [anon]
2ae6cccae000     28K     16K      0K r-xp /lib64/libhistory.so.5.2
2ae6cccb5000   2048K      0K      0K ---p /lib64/libhistory.so.5.2 <--
2ae6cceb5000      8K      8K      8K rw-p /lib64/libhistory.so.5.2
2ae6cceb7000    320K    208K      0K r-xp /lib64/libncurses.so.5.5
2ae6ccf07000   2048K      0K      0K ---p /lib64/libncurses.so.5.5 <--
2ae6cd107000     48K     48K     48K r--p /lib64/libncurses.so.5.5
2ae6cd113000     28K     28K     28K rw-p /lib64/libncurses.so.5.5
[...]

What could these ominous mappings be? Does anyone else see that - 
perhaps someone with x86_64 && !(opensuse 10.2)?


Jan
-- 
