Return-Path: <linux-kernel-owner+w=401wt.eu-S1754576AbXHSOSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576AbXHSOSW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 10:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752215AbXHSOSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 10:18:12 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58668 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751255AbXHSOSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 10:18:11 -0400
Date: Sun, 19 Aug 2007 16:17:32 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andreas Schwab <schwab@suse.de>,
       Alan Modra <alan@linuxcare.com.au>,
       David Mosberger-Tang <davidm@hpl.hp.com>
Subject: sched.c: why -fno-omit-frame-pointer?
Message-ID: <20070819141732.GD32595@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/sched.c gets compiled with -fno-omit-frame-pointer, and this was 
already done in kernel 1.0 (sic).

Later, it has been modified to be this way only on some architectures.

It might not be an earthshaking amount, but removing it saves some 
bytes, and there's no visible breakage when running the modified kernel 
on i386.

$ ls -la kernel/sched.o*
-rw-rw-r-- 1 bunk bunk 25600 2007-08-19 16:10 kernel/sched.o
-rw-rw-r-- 1 bunk bunk 26084 2007-08-19 16:03 kernel/sched.o.old
$ size kernel/sched.o*
   text    data     bss     dec     hex filename
  11835     184    2000   14019    36c3 kernel/sched.o
  12321     184    2000   14505    38a9 kernel/sched.o.old
$ 

Is the -fno-omit-frame-pointer still required for some reason, or is 
this a relict that could be removed?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

