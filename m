Return-Path: <linux-kernel-owner+w=401wt.eu-S1759146AbXIZNf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759146AbXIZNf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 09:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754321AbXIZNfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 09:35:16 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:38251 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753361AbXIZNfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 09:35:14 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch/backport] CFS scheduler, -v22, for v2.6.23-rc8, v2.6.22.8, v2.6.21.7, v2.6.20.20
Date: Wed, 26 Sep 2007 16:33:22 +0300
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linux-kernel@vger.kernel.org
References: <20070926111357.GA10655@elte.hu>
In-Reply-To: <20070926111357.GA10655@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200709261633.24283.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

26 Eyl 2007 Çar tarihinde, Ingo Molnar şunları yazmıştı: 
> By popular demand, here is release -v22 of the CFS scheduler. It is a
> full backport of the latest & greatest sched-devel.git code to
> v2.6.23-rc8, v2.6.22.8, v2.6.21.7 and v2.6.20.20. The patches can be
> downloaded from the usual place:
>
>     http://people.redhat.com/mingo/cfs-scheduler/
>
> This is the first time the development version of the scheduler has been
> fed back into the stable backport series, so there's many changes since
> v20.5:

Compilation [against 2.6.20.20] fails with

buildfarm linux-2.6.20 # make
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  CC      kernel/sched.o
In file included from kernel/sched.c:850:
kernel/sched_fair.c:49: error: sysctl_sched_nr_latency causes a section type 
conflict
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

@kernel/sched_fair.c
-const_debug unsigned int sysctl_sched_nr_latency __read_mostly = 20;
+const_debug unsigned int sysctl_sched_nr_latency = 20;

seems solve that issue but i'm not sure this is the right thing to do or 
not :)

Cheers
-- 
S.Çağlar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in house!
