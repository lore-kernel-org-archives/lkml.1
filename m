Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbXDHSbG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbXDHSbG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:31:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXDHSbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:31:06 -0400
Received: from [212.12.190.168] ([212.12.190.168]:34360 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751643AbXDHSbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:31:05 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: Re: SD scheduler testing hitch
Date: Sun, 8 Apr 2007 21:34:43 +0300
User-Agent: KMail/1.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704082134.43029.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith wrote:
> On Sat, 2007-04-07 at 19:17 +0200, Mike Galbraith wrote:
> > I lowered the time to 500us, and ran at nice -10.. it starves tenpercent
> > here every time.  (ran as taskset -c 1 nice -n -10 ./fairtest)  The
> > starving 10% duty cycle task has trouble getting 1% CPU.
>
> Hmm.  Playing with it some more today, it still happens, but it's not
> very repeatable.  Something is odd.  I wonder if any SD using readers
> will try it.

Tried it on mainline 2.6.20.3.
It's not easily repeatable, but it's got the same problem.

top - 21:21:45 up 27 min,  0 users,  load average: 0.80, 0.43, 0.20
Tasks:  45 total,   3 running,  42 sleeping,   0 stopped,   0 zombie
Cpu(s):  24.3% user,   0.5% system,   0.0% nice,  75.0% idle,   0.2% IO-wait
Mem:    499488k total,    27352k used,   472136k free,     1996k buffers
Swap:  1020088k total,        0k used,  1020088k free,     9160k cached

  PID  PR  NI  VIRT  RES  SHR SWAP nFLT nDRT WCHAN     S %CPU    TIME+  Command 
  688  25   0  1804  412  352 1392    0    0 rest_init R 94.7   2:37.01 fairtest
  689  15   0  1804  264  204 1540    0    0 rest_init R  0.0   0:00.79 fairtest
    1  15   0  1440  500  444  940   15    0 rest_init S  0.0   0:00.73 init    


Thanks!

--
Al

