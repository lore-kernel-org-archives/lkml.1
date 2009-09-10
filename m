Return-Path: <linux-kernel-owner+w=401wt.eu-S1754503AbZIJU6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503AbZIJU6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbZIJU6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:58:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49379 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754440AbZIJU6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:58:30 -0400
Date: Thu, 10 Sep 2009 13:57:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiao Guangrong <ericxiao.gr@gmail.com>
Cc: jirislaby@gmail.com, rjw@sisk.pl, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, npiggin@suse.de, hpa@zytor.com,
       xiaoguangrong@cn.fujitsu.com, peterz@infradead.org,
       rusty@rustcorp.com.au, mingo@elte.hu, jens.axboe@oracle.com
Subject: Re: [-mm] warning during suspend [was: suspend race -mm regression]
Message-Id: <20090910135745.61de2be6.akpm@linux-foundation.org>
In-Reply-To: <4AA278A1.2090107@gmail.com>
References: <1249980093-16319-1-git-send-email-jirislaby@gmail.com>
	<4A81E073.5080703@gmail.com>
	<4A9B9C1C.9020506@gmail.com>
	<200908312132.10904.rjw@sisk.pl>
	<4AA0FEBF.7040104@gmail.com>
	<4AA19520.3070708@gmail.com>
	<4AA19668.5080909@gmail.com>
	<4AA25C11.9050209@gmail.com>
	<4AA278A1.2090107@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Sep 2009 22:41:37 +0800
Xiao Guangrong <ericxiao.gr@gmail.com> wrote:

> Jiri Slaby ______:
> > On 09/05/2009 12:36 AM, Jiri Slaby wrote:
> >> On 09/05/2009 12:30 AM, Jiri Slaby wrote:
> >>> WARNING: at kernel/smp.c:124
> >>> __generic_smp_call_function_interrupt+0xfd/0x110()
> >>> Hardware name: To Be Filled By O.E.M.
> >>> Modules linked in: nfs lockd auth_rpcgss sunrpc ath5k ath
> >>> Pid: 3423, comm: pm-suspend Not tainted 2.6.31-rc8-mm1_64 #762
> >>> Call Trace:
> >>>  [<ffffffff8103fc48>] warn_slowpath_common+0x78/0xb0
> >>>  [<ffffffff8103fc8f>] warn_slowpath_null+0xf/0x20
> >>>  [<ffffffff8106950d>] __generic_smp_call_function_interrupt+0xfd/0x110
> >>>  [<ffffffff8106956a>] hotplug_cfd+0x4a/0xa0
> >>>  [<ffffffff81434e47>] notifier_call_chain+0x47/0x90
> >>>  [<ffffffff8105b311>] raw_notifier_call_chain+0x11/0x20
> >>>  [<ffffffff8141ece0>] _cpu_down+0x150/0x2d0
> >> It's the CPU_DEAD notifier:
> >> ffffffff8141ecd0:       48 83 ce 07             or     $0x7,%rsi
> >> ffffffff8141ecd4:       48 c7 c7 08 ff 5d 81    mov
> >> $0xffffffff815dff08,%rdi
> >> ffffffff8141ecdb:       e8 20 c6 c3 ff          callq  ffffffff8105b300
> >> <raw_notifier_call_chain>
> >> ffffffff8141ece0:       3d 02 80 00 00          cmp    $0x8002,%eax
> > 
> > And it's due to:
> > generic-ipi-fix-the-race-between-generic_smp_call_function_-and-hotplug_cfd.patch
> > 
> 
> I think it has collision between my patch and below patch:
> 
> Commit-ID:  269c861baa2fe7c114c3bc7831292758d29eb336
> Gitweb:     http://git.kernel.org/tip/269c861baa2fe7c114c3bc7831292758d29eb336
> Author:     Suresh Siddha <suresh.b.siddha@intel.com>
> AuthorDate: Wed, 19 Aug 2009 18:05:35 -0700
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 21 Aug 2009 16:25:43 -0700
> 
> generic-ipi: Allow cpus not yet online to call smp_call_function with irqs disabled
> 
> My patch is merged at -mm tree, but this patch is base on -tip tree later, so it has this
> problem
> 
> Suresh, what your opinion?
> 

Suresh appears to be hiding.

Could you please propose a fix for this issue?
