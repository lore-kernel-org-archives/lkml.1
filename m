Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbZKZRW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbZKZRW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 12:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759229AbZKZRW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 12:22:58 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43677 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758960AbZKZRW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 12:22:58 -0500
Subject: RE: [regression bisect -next] BUG: using smp_processor_id() in
 preemptible [00000000] code: rmmod
From: Peter Zijlstra <peterz@infradead.org>
To: "Leyendecker, Robert" <Robert.Leyendecker@lsi.com>
Cc: Eric Paris <eparis@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "efault@gmx.de" <efault@gmx.de>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <8C8865ED624BB94F8FE50259E2B5C5B304593DAB99@palmail03.lsi.com>
References: <1256784158.2848.8.camel@dhcp231-106.rdu.redhat.com>
	 <8C8865ED624BB94F8FE50259E2B5C5B304593DAB99@palmail03.lsi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 26 Nov 2009 18:22:41 +0100
Message-ID: <1259256161.31676.292.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 12:09 -0500, Leyendecker, Robert wrote:
> 
> I have same oops (different cause-vector). Details here
> http://lkml.org/lkml/2009/11/23/548

Which is an -rt kernel and very likely totally unrelated.

> Can anyone tell me if they are related and/or recommend any
> work-arounds or troubleshooting steps?
> 
> Could this be related to scheduler trying to reschedule a task/thread
> on other proc

No, the warning says you try to get the current cpu number when the code
in question is in no way tied to a particular cpu, therefore the cpu
number obtained is totally useless.

>  and possibly a false alarm? 

Most likely not.

Look at your particular source-tree and try to fine the
smp_processor_id() call that triggers this, then look what it needs the
cpu number for and fix the code so that it makes sense ;-)

> Nov 23 17:24:15 localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: smash/3062
> Nov 23 17:24:15 localhost kernel: caller is __schedule+0x93/0x7d4
> Nov 23 17:24:15 localhost kernel: Pid: 3062, comm: smash Not tainted 2.6.31.6-rt19 #1
> Nov 23 17:24:15 localhost kernel: Call Trace:
> Nov 23 17:24:15 localhost kernel: [<c06dc3df>] ? printk+0xf/0x18
> Nov 23 17:24:15 localhost kernel: [<c05499a6>] debug_smp_processor_id+0xa6/0xbc
> Nov 23 17:24:15 localhost kernel: [<c06dc70e>] __schedule+0x93/0x7d4
> Nov 23 17:24:15 localhost kernel: [<c046621f>] ? audit_syscall_exit+0xfa/0x10f
> Nov 23 17:24:15 localhost kernel: [<c040a955>] ? syscall_trace_leave+0xc8/0xef
> Nov 23 17:24:15 localhost kernel: [<c040338a>] work_resched+0x5/0x19
> Nov 23 17:24:15 localhost kernel: __ratelimit: 6 callbacks suppressed


