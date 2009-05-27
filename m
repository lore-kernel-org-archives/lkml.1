Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbZE0Bq4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbZE0Bq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 21:46:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752563AbZE0Bqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 21:46:49 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:60854 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZE0Bqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 21:46:48 -0400
Message-Id: <200905270146.n4R1kjes036867@www262.sakura.ne.jp>
Subject: Re: [2.6.30-rcX] Some ftrace debug option is consuming memory?
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 27 May 2009 10:46:45 +0900
References: <200905250533.n4P5XGx6042820@www262.sakura.ne.jp> <alpine.DEB.2.00.0905261518550.26705@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0905261518550.26705@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 26052009 #2038151, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> > I was running a VM with 1024MB of RAM.
> > 
> > I changed it to 512MB of RAM, and now I'm experiencing out of memory error.
> 
> How many virtual CPUs do you have configured?
> 
I assigned 2 virtual CPUs.
But this error occurs even with 1 virtual CPU.

> > 2.6.29.4 can boot with 512MB of RAM.
> > 2.6.30-rc1 and later cannot boot with 512MB of RAM if some debug options are
> > enabled.
> 
> Did 29.4 have tracing enabled and still worked?
> 
Yes.
Config (with all tracing options enabled) is at http://I-love.SAKURA.ne.jp/tmp/config-2.6.29.4-ok
Full log is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.29.4-ok-512MB.txt



> > < # CONFIG_IRQSOFF_TRACER is not set
> > < # CONFIG_SYSPROF_TRACER is not set
> > < # CONFIG_SCHED_TRACER is not set
> 
> Can you also disable the above three and see if you still see problems?
> 
I disabled the above three.

  # diff config-2.6.30-rc7-ng .config
  4c4
  < # Mon May 25 13:28:39 2009
  ---
  > # Wed May 27 10:11:09 2009
  1528d1527
  < CONFIG_TRACER_MAX_TRACE=y
  1539,1541c1538,1540
  < CONFIG_IRQSOFF_TRACER=y
  < CONFIG_SYSPROF_TRACER=y
  < CONFIG_SCHED_TRACER=y
  ---
  > # CONFIG_IRQSOFF_TRACER is not set
  > # CONFIG_SYSPROF_TRACER is not set
  > # CONFIG_SCHED_TRACER is not set

But I'm still seeing the problem.
Full log which cannot boot is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc7-ng-512MB.txt
Full log which can boot is at http://I-love.SAKURA.ne.jp/tmp/dmesg-2.6.30-rc7-ng-1024MB.txt

Regards.
