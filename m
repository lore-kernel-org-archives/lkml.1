Return-Path: <linux-kernel-owner+w=401wt.eu-S1757082AbYJGVDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757082AbYJGVDy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751947AbYJGVDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:03:44 -0400
Received: from one.firstfloor.org ([213.235.205.2]:42545 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbYJGVDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:03:43 -0400
Date: Tue, 7 Oct 2008 23:09:47 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, rjw@sisk.pl, dipankar@in.ibm.com,
       tglx@linuxtronix.de
Subject: Re: RCU hang on cpu re-hotplug with 2.6.27rc8
Message-ID: <20081007210947.GP20740@one.firstfloor.org>
References: <20081006141220.GA14160@basil.nowhere.org> <20081006232837.GA1157@basil.nowhere.org> <20081007030822.GC6820@linux.vnet.ibm.com> <20081007071544.GC20740@one.firstfloor.org> <20081007152629.GH6384@linux.vnet.ibm.com> <20081007154939.GN20740@one.firstfloor.org> <20081007163401.GJ6384@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007163401.GJ6384@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2008 at 09:34:01AM -0700, Paul E. McKenney wrote:
> Thank you!  Hmmm, classic RCU, worked just fine in 2.6.27-rc7 with
> Thomas's patch.  I was doing random onlines and offlines in a loop,
> with about 3 seconds between each operation continuously for more than
> ten hours, both x86 and Power.  So could you please try 2.6.27-rc7 with
> Thomas's patch as follows?
> 
> http://www.rdrop.com/users/paulmck/patches/2.6.27-rc7-tglx-timer-1.patch

Same effect. Hung on the first try

bash          D 00000000ffff25c1     0  4755   4742
 ffff88027b127bf8 0000000000000086 ffff88027b127c18 0000000000000296
 ffff88027c80b330 ffff8804be488b90 ffff88027c80b578 0000000300000296
 ffff88027b127c18 ffffffff808cbd18 ffff88002805d600 ffff88027d182098
Call Trace:
 [<ffffffff805c318d>] schedule_timeout+0x22/0xb4
 [<ffffffff8020a029>] ? __switch_to+0x320/0x330
 [<ffffffff8025fa65>] ? cpupri_set+0xc5/0xd8
 [<ffffffff805c2fe7>] wait_for_common+0xcd/0x131
 [<ffffffff8022d297>] ? default_wake_function+0x0/0xf
 [<ffffffff805c30d5>] wait_for_completion+0x18/0x1a
 [<ffffffff8024374b>] synchronize_rcu+0x35/0x3c
 [<ffffffff802437ca>] ? wakeme_after_rcu+0x0/0x12
 [<ffffffff8022e435>] partition_sched_domains+0x9b/0x1dd
 [<ffffffff8022d2c3>] ? wake_up_process+0x10/0x12
 [<ffffffff8022e5a5>] update_sched_domains+0x2e/0x35
 [<ffffffff805c6bb2>] notifier_call_chain+0x33/0x5b
 [<ffffffff80248a29>] __raw_notifier_call_chain+0x9/0xb
 [<ffffffff80248a3a>] raw_notifier_call_chain+0xf/0x11
 [<ffffffff805c06e6>] _cpu_up+0xd3/0x10c
 [<ffffffff805c0776>] cpu_up+0x57/0x67
 [<ffffffff805a4ab7>] store_online+0x4d/0x75
 [<ffffffff803e5d0b>] sysdev_store+0x1b/0x1d
 [<ffffffff802cc49c>] sysfs_write_file+0xe0/0x11c
 [<ffffffff8028ad1d>] vfs_write+0xae/0x137
 [<ffffffff8028b1c6>] sys_write+0x47/0x6f
 [<ffffffff8020b36b>] system_call_fastpath+0x16/0x1b

-Andi

-- 
ak@linux.intel.com
