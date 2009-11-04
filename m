Return-Path: <linux-kernel-owner+w=401wt.eu-S932924AbZKDVpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924AbZKDVpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 16:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbZKDVl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 16:41:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:53725 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932701AbZKDVl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 16:41:57 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18qBB1OciAqiDUqPZ/uetFme8NicjqeSyN+XVN5wz
	V7CszH8NLvF71c
Subject: Re: [tip:sched/core] sched: Check for an idle shared cache in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: arjan@infradead.org
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stable@kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
In-Reply-To: <1257367035.9923.3.camel@marge.simson.net>
References: <1256654138.17752.7.camel@marge.simson.net>
	 <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
	 <1257367035.9923.3.camel@marge.simson.net>
Content-Type: text/plain
Date: Wed, 04 Nov 2009 22:41:57 +0100
Message-Id: <1257370917.11327.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5600000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-04 at 21:37 +0100, Mike Galbraith wrote:
> On Wed, 2009-11-04 at 19:33 +0000, tip-bot for Mike Galbraith wrote:
> > Commit-ID:  a1f84a3ab8e002159498814eaa7e48c33752b04b
> > Gitweb:     http://git.kernel.org/tip/a1f84a3ab8e002159498814eaa7e48c33752b04b
> > Author:     Mike Galbraith <efault@gmx.de>
> > AuthorDate: Tue, 27 Oct 2009 15:35:38 +0100
> > Committer:  Ingo Molnar <mingo@elte.hu>
> > CommitDate: Wed, 4 Nov 2009 18:46:22 +0100
> > 
> > sched: Check for an idle shared cache in select_task_rq_fair()
> > 
> > When waking affine, check for an idle shared cache, and if
> > found, wake to that CPU/sibling instead of the waker's CPU.
> 
> This one still wants some work.  It's not playing well with 1b9508f.

Still does want some work (on the tail), but those numbers were from a
failed experiment kernel, not d995f1d.  Below are the correct numbers.

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

v2.6.32-rc6-1796-gd995f1d
             10745.30   19684.71   36367.25   35890.25   34598.08   33672.37   32327.99   28744.09   25393.00
             10549.41   19747.85   36778.96   36410.58   35531.90   34292.03   32603.66   29487.77   25351.09
             10678.30   19944.74   36789.44   36403.78   35523.40   34267.10   32659.60   29359.59   25751.93
avg          10657.67   19792.43   36645.21   36234.87   35217.79   34077.16   32530.41   29197.15   25498.67
vs c5bb4b1      1.017      1.014      1.017      1.009      1.008      1.006      1.005       1.004      .994

Lost the tail gain, gained peak.  Drink one, spill one, give one away.

	-Mike

