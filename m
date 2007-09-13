Return-Path: <linux-kernel-owner+w=401wt.eu-S1764055AbXIMFkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764055AbXIMFkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 01:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751166AbXIMFkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 01:40:07 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:24857 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849AbXIMFkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 01:40:05 -0400
Date: Wed, 12 Sep 2007 22:21:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: crashme fault
Message-Id: <20070912222151.70d1fc7d.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I run almost-daily kernel testing.  I haven't seen 'crashme' cause a
kernel fault until today, and now I've seen it twice on 2.6.23-rc6-git2,
x86_64.  After the first fault, I ran 'crashme' about 10 more times
to get the second fault (usually for 10 minutes, one time for 30
minutes).

[This is gjc-crashme, not Dave's scrashme replacement:
http://people.delphiforums.com/gjc/crashme.html]

There is very little helpful info.  RIP is strange, e.g.: 000000000051b446
The call stack is not printed.  No kernel symbols are printed,
even though I have CONFIG_KALLSYMS{_ALL}=y.

Here are the 2 kernel message logs of the faults.
Any ideas/suggestions?  I suppose I will try to log the syscall
parameters that crashme is using.

~~~~~~~~~~~~~~~~~~~~ 1. ~~~~~~~~~~~~~~~~~~~~~~~

[ 7487.208128] Unable to handle kernel paging request at 00000000ff019b53 RIP:
[ 7487.212752]  [<0000000000510eea>]
[ 7487.218537] PGD 10c1a2067 PUD 0
[ 7487.221811] Oops: 0000 [1] SMP
[ 7487.224989] CPU 2
[ 7487.227024] Modules linked in: loop
[ 7487.230550] Pid: 19139, comm: crashme Not tainted 2.6.23-rc6-git2 #1
[ 7487.236896] RIP: 0033:[<0000000000510eea>]  [<0000000000510eea>]
[ 7487.242925] RSP: 002b:00007fffc9a8ec10  EFLAGS: 00010e83
[ 7487.248234] RAX: 00000000ffff8c4a RBX: 00000000004014f1 RCX: 00002b20e11c8b37
[ 7487.255361] RDX: 0000000000510ee0 RSI: 0000000000000000 RDI: 000000000000000a
[ 7487.262489] RBP: 00007fffc9a8ec10 R08: 00007fffc9a8eb60 R09: 0000000000000000
[ 7487.269616] R10: 0000000000000008 R11: 0000000000000612 R12: 0000000000000000
[ 7487.276743] R13: 00007fffc9a8ee00 R14: 0000000000000000 R15: 0000000000000000
[ 7487.283871] FS:  00002b20e13676d0(0000) GS:ffff81011fc75840(0000) knlGS:0000000000000000
[ 7487.291952] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7487.297693] CR2: 00000000ff019b53 CR3: 000000005be6b000 CR4: 00000000000006e0
[ 7487.304821] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 7487.311949] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 7487.319076] Process crashme (pid: 19139, threadinfo ffff810106830000, task ffff810102cf5040)
[ 7487.327511]
[ 7487.329009] RIP  [<0000000000510eea>]
[ 7487.332690]  RSP <00007fffc9a8ec10>
[ 7487.336180] CR2: 00000000ff019b53
[ 7487.339810] Kernel panic - not syncing: Fatal exception

~~~~~~~~~~~~~~~~~~~ 2. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[16625.590976] Unable to handle kernel paging request at 00000000ff019f05 RIP: 
[16625.595604]  [<000000000051b446>]
[16625.601397] PGD d9af2067 PUD 0 
[16625.604577] Oops: 0000 [1] SMP 
[16625.607754] CPU 1 
[16625.609789] Modules linked in: loop
[16625.613315] Pid: 23057, comm: crashme Not tainted 2.6.23-rc6-git2 #1
[16625.619662] RIP: 0033:[<000000000051b446>]  [<000000000051b446>]
[16625.625689] RSP: 002b:00007fff7b5851f0  EFLAGS: 00010603
[16625.630998] RAX: 0000000000000000 RBX: 00002b672f63ec00 RCX: 00002b672f6d1b37
[16625.638127] RDX: 0000000000401476 RSI: 0000000000000000 RDI: 000000000000000a
[16625.645254] RBP: 00007fff7b5851f0 R08: 00007fff7b585140 R09: 0000000000000000
[16625.652381] R10: 0000000000000008 R11: 0000000000000612 R12: 0000000000000000
[16625.659508] R13: 00007fff7b5853e0 R14: 0000000000000000 R15: 0000000000000000
[16625.666637] FS:  00002b672f8706d0(0000) GS:ffff81011fc75e40(0000) knlGS:0000000000000000
[16625.674717] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[16625.680458] CR2: 00000000ff019f05 CR3: 00000000d942b000 CR4: 00000000000006e0
[16625.687587] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[16625.694714] DR3: 0000000000000000 DR6: 00000000ffff4ff0 DR7: 0000000000000400
[16625.701841] Process crashme (pid: 23057, threadinfo ffff8100d9bfe000, task ffff81011e83a040)
[16625.710267] 
[16625.711765] RIP  [<000000000051b446>]
[16625.715446]  RSP <00007fff7b5851f0>
[16625.718937] CR2: 00000000ff019f05
[16625.722553] Kernel panic - not syncing: Fatal exception


---
~Randy
