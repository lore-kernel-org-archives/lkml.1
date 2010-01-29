Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102Ab0A2QLh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab0A2QLh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 11:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755838Ab0A2QLW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 11:11:22 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54937 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754036Ab0A2QLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 11:11:20 -0500
Message-ID: <f8c9aca9c98db8ae7df3ac2d7ac8d922.squirrel@webmail-b.css.fujitsu.com>
Date: Sat, 30 Jan 2010 01:11:17 +0900 (JST)
Subject: Re: [PATCH v3] oom-kill: add lowmem usage aware oom kill handling
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: vedran.furac@gmail.com,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>, rientjes@google.com,
       minchan.kim@gmail.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> off by default. Problem is that it breaks java and some other stuff that
>> allocates much more memory than it needs. Very quickly Committed_AS hits
>> CommitLimit and one cannot allocate any more while there is plenty of
>> memory still unused.
>
> So how about you go and have a complain at the people who are causing
> your problem, rather than the kernel.
>
Alan, please allow me to talk about my concern.

At first, I think all OOM-killer are bad and there are no chance
to implement innocent, good OOM-Killer. The best way we can do is
"never cause OOM-Kill". But we're human being, OOM-Killer can happen
by _mistake_....

For example, a customer runs 1000+ process of Oracle without using
HugeTLB and the total size of page table goes up to 10GByes. Hahaha.
(Of course, We asked him  to use Hugetlb ;) We can't ask him to
 use overcommit memory if much proprietaty applications runs on it.)

So, I believe there is a cirtial situation OOM-Killer has to run even
if it's bad. Even in corner case.
Now, in OOM situaion, sshd or X-server or some task launcher is killed at
first if oom_adj is not tweaked. IIUC, OOM-Killer is for giving a chance
to administrator to recover his system, safe reboot. But if sshd/X is
kiiled, this is no help.

My first purpose was to prevent killing some daemons or task launchers.
The first patch was nacked ;).

On that way, I tried to add lowmem counting because it was also
my concern. This was nacked ;(

I stop this because of my personal reason. For my enviroment,
panic_on_oom=1 works enough well.For Vedran's, overcommit memory will work
well. But oom-killer kills very bad process if not tweaked.
So, I think some improvement should be done.

And we have memcg even if it's called as ugly workaround.
Sorry for all the noise.

Bye,
-Kame







