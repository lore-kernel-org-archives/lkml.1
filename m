Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715AbZLOEsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715AbZLOEsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 23:48:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756505AbZLOEsE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 23:48:04 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:44191 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755616AbZLOEsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 23:48:01 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v4.2
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com>
References: <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0912142025090.29243@chino.kir.corp.google.com>
Message-Id: <20091215134319.CDD3.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 15 Dec 2009 13:47:54 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> >     I'm now preparing more counters for mm's statistics. It's better to
> >     wait  and to see what we can do more. And other patches for total
> >     oom-killer improvement is under development.
> > 
> >     And, there is a compatibility problem.
> >     As David says, this may break some crazy software which uses
> >     fake_numa+cpuset+oom_killer+oom_adj for resource controlling.
> >    (even if I recommend them to use memcg rather than crazy tricks...)
> >     
> 
> That's not at all what I said.  I said using total_vm as a baseline allows 
> users to define when a process is to be considered "rogue," that is, using 
> more memory than expected.  Using rss would be inappropriate since it is 
> highly dynamic and depends on the state of the VM at the time of oom, 
> which userspace cannot possibly keep updated.
> 
> You consistently ignore that point: the power of /proc/pid/oom_adj to 
> influence when a process, such as a memory leaker, is to be considered as 
> a high priority for an oom kill.  It has absolutely nothing to do with 
> fake NUMA, cpusets, or memcg.

To compare vsz is only meaningful when the same program are compared.
But oom killer don't. To compare vsz between another program DONT detect
any memory leak.


> 
> >     2 ideas which I can think of now are..
> >     1) add sysctl_oom_calc_on_committed_memory 
> >        If this is set, use vm-size instead of rss.
> > 
> 
> I would agree only if the oom killer used total_vm as a the default, it is 
> long-standing and allows for the aforementioned capability that you lose 
> with rss.  I have no problem with the added sysctl to use rss as the 
> baseline when enabled.

Probably, nobody agree you. your opinion don't solve original issue.
kernel developer can't ignore bug report.


> 
> >     2) add /proc/<pid>/oom_guard_size
> >        This allows users to specify "valid/expected size" of a task.
> >        When
> >        #echo 10M > /proc/<pid>/oom_guard_size
> >        At OOM calculation, 10Mbytes is subtracted from rss size.
> >        (The best way is to estimate this automatically from vm_size..but...)
> 
> Expected rss is almost impossible to tune for cpusets that have a highly 
> dynamic set of mems, let alone without containment.



