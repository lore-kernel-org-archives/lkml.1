Return-Path: <linux-kernel-owner+w=401wt.eu-S932466AbZKDUhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932466AbZKDUhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 15:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932356AbZKDUhg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 15:37:36 -0500
Received: from mail.gmx.net ([213.165.64.20]:60413 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932297AbZKDUhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 15:37:35 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19sXGVm/vtsGHL9suScv1u/lFrSmtY2Y2H3Wdys15
	AsRMtoK9DNTugH
Subject: Re: [tip:sched/core] sched: Check for an idle shared cache in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: arjan@infradead.org, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, peterz@infradead.org,
       tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
References: <1256654138.17752.7.camel@marge.simson.net>
	 <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 21:37:15 +0100
Message-Id: <1257367035.9923.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 19:33 +0000, tip-bot for Mike Galbraith wrote:
> Commit-ID:  a1f84a3ab8e002159498814eaa7e48c33752b04b
> Gitweb:     http://git.kernel.org/tip/a1f84a3ab8e002159498814eaa7e48c33752b04b
> Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Tue, 27 Oct 2009 15:35:38 +0100
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 4 Nov 2009 18:46:22 +0100
> 
> sched: Check for an idle shared cache in select_task_rq_fair()
> 
> When waking affine, check for an idle shared cache, and if
> found, wake to that CPU/sibling instead of the waker's CPU.

This one still wants some work.  It's not playing well with 1b9508f.

tip v2.6.32-rc6-1731-gc5bb4b1

mysql+oltp
clients             1          2          4          8         16         32         64        128        256
tip          10447.14   19734.58   36038.18   35776.85   34662.76   33682.30   32256.22   28770.99   25323.23
             10462.61   19580.14   36050.48   35942.63   35054.84   33988.40   32423.89   29259.65   25892.24
             10501.02   19231.27   36007.03   35985.32   35060.79   33945.47   32400.42   29140.84   25716.16
tip avg      10470.25   19515.33   36031.89   35901.60   34926.13   33872.05   32360.17   29057.16   25643.87

tip v2.6.32-rc6-1731-gc5bb4b1 + 1b9508f (Rate-limit newidle)
tip+         10095.64   19989.67   36449.85   35923.98   35024.24   34026.61   32411.75   28965.77   27287.96
             10764.98   19864.03   36632.78   36338.00   35610.52   34439.88   32942.57   29889.18   27426.12
             10734.48   19572.63   36507.90   36236.36   35486.51   34443.86   32938.90   30136.39   27186.61
tip+ avg     10531.70   19808.77   36530.17   36166.11   35373.75   34303.45   32764.40   29663.78   27300.23
                1.005      1.015      1.013      1.007      1.012      1.012      1.012      1.020      1.064

v2.6.32-rc6-1796-gd995f1d (a1f84a3 not playing well with 1b9508f)
             10578.44   19358.96   36184.70   35549.19   34625.40   33658.72   31947.51   27504.11   20400.97
             10610.76   19748.84   36401.08   36021.75   34830.67   33566.52   31989.97   27622.25   21348.00
             10568.87   19600.60   36190.48   35959.96   34805.45   33641.46   32005.30   27591.48   22509.01


