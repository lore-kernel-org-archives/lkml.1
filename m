Return-Path: <linux-kernel-owner+w=401wt.eu-S1752402Ab0AUFmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab0AUFmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 00:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318Ab0AUFmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 00:42:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:60289 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752233Ab0AUFmL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 00:42:11 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Z0BAmhANZ2E9ngX16uDMgfNwfFUyuIC0pmlB9SD
	9ynXT5pfVA3TLu
Subject: perf top: losing events?
From: Mike Galbraith <efault@gmx.de>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jan 2010 06:42:08 +0100
Message-Id: <1264052528.26323.13.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.73999999999999999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings Arnaldo,

------------------------------------------------------------------------------------------------------------------------------
   PerfTop:     670 irqs/sec  kernel:14.6% [1000Hz cycles],  (all, cpu: 3)
------------------------------------------------------------------------------------------------------------------------------

             samples  pcnt function            DSO
             _______ _____ ___________________ ________________________________________________________________

            12535.00 82.1% main                /root/bin/pert
              302.00  2.0% clear_page_c        [kernel.kallsyms]
              169.00  1.1% _int_malloc         /lib64/libc-2.9.so
              168.00  1.1% page_fault          [kernel.kallsyms]
              138.00  0.9% yylex               /usr/local/src/kernel/linux-2.6.33.git/scripts/genksyms/genksyms
              121.00  0.8% __GI_memset         /lib64/libc-2.9.so
              117.00  0.8% copy_page_c         [kernel.kallsyms]
               96.00  0.6% _raw_spin_lock      [kernel.kallsyms]
               79.00  0.5% use_config          /usr/local/src/kernel/linux-2.6.33.git/scripts/basic/fixdep

If only 100% userland hog (pert) is running, I see the expected 1KHz
irqs/sec.  As soon as I start a kbuild with it, irqs/sec drops, though
NMIs are indeed happening at 1KHz.

Bisection points to 5b2bb75 perf top: Support userspace symbols too.

	-Mike

