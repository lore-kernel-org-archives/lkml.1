Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYGMNe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYGMNe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 09:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754233AbYGMNeN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 09:34:13 -0400
Received: from mail4.aster.pl ([212.76.33.58]:15995 "EHLO mail4.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbYGMNeL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 09:34:11 -0400
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2.6.25.10] pm_qos_params: change spinlock to rwlock
Date: Sun, 13 Jul 2008 15:05:25 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, mgross@linux.intel.com, mingo@elte.hu,
       tglx@timesys.com
References: <200807130119.19663.jozwicki@aster.pl> <20080713012816.8c136efa.akpm@linux-foundation.org>
In-Reply-To: <20080713012816.8c136efa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807131505.25990.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sunday, 13 of July 2008 10:28:16 Andrew Morton napisał(a):
> On Sun, 13 Jul 2008 01:19:19 +0200 "Jakub W. Jozwicki" <jozwicki@aster.pl> 
wrote:
> > Concurrent calls to pm_qos_requirement shouldn't block each other. This
> > patch changes spinlock to rwlock and fixes issues with PREEMPT_RT.
>
> "fixes issues" is nowhere near an adequate description.
>
> Please provide complete descriptions for kernel patches.  That includes
> describing the mysterious "issue" in full!
>
> Thanks.

[  114.647010] BUG: sleeping function called from invalid context swapper(0) 
at kernel/rtmutex.c:742
[  114.647010] in_atomic():1 [00000001], irqs_disabled():0
[  114.647010] Pid: 0, comm: swapper Not tainted 2.6.25.10-rtXXX #10
[  114.647010]  [<c0120fc4>] __might_sleep+0xf1/0xf8
[  114.647010]  [<c045499c>] __rt_spin_lock+0x24/0x61
[  114.647010]  [<c04549e1>] rt_spin_lock+0x8/0xa
[  114.647010]  [<c013ec8d>] pm_qos_requirement+0x10/0x29
[  114.647010]  [<c038ef36>] menu_select+0x5d/0x7f
[  114.647010]  [<c038e4d8>] cpuidle_idle_call+0x47/0x9b
[  114.647010]  [<c038e491>] ? cpuidle_idle_call+0x0/0x9b
[  114.647010]  [<c01060ff>] cpu_idle+0xaf/0x106
[  114.647010]  [<c0441c87>] rest_init+0x67/0x69
[  114.647010]  =======================
[  115.649517] BUG: sleeping function called from invalid context swapper(0) 
at kernel/rtmutex.c:742
[  115.649517] in_atomic():1 [00000001], irqs_disabled():0
[  115.649517] Pid: 0, comm: swapper Not tainted 2.6.25.10-rtXXX #10
[  115.649517]  [<c0120fc4>] __might_sleep+0xf1/0xf8
[  115.649517]  [<c045499c>] __rt_spin_lock+0x24/0x61
[  115.649517]  [<c04549e1>] rt_spin_lock+0x8/0xa
[  115.649517]  [<c013ec8d>] pm_qos_requirement+0x10/0x29
[  115.649517]  [<c038ef36>] menu_select+0x5d/0x7f
[  115.649517]  [<c038e4d8>] cpuidle_idle_call+0x47/0x9b
[  115.649517]  [<c038e491>] ? cpuidle_idle_call+0x0/0x9b
[  115.649517]  [<c01060ff>] cpu_idle+0xaf/0x106
[  115.649517]  [<c0441c87>] rest_init+0x67/0x69
[  115.649517]  =======================
[  116.650040] BUG: sleeping function called from invalid context swapper(0) 
at kernel/rtmutex.c:742
[  116.650040] in_atomic():1 [00000001], irqs_disabled():0
[  116.650040] Pid: 0, comm: swapper Not tainted 2.6.25.10-rtXXX #10
[  116.650040]  [<c0120fc4>] __might_sleep+0xf1/0xf8
[  116.650040]  [<c045499c>] __rt_spin_lock+0x24/0x61
[  116.650040]  [<c04549e1>] rt_spin_lock+0x8/0xa
[  116.650040]  [<c013ec8d>] pm_qos_requirement+0x10/0x29
[  116.650040]  [<c038ef36>] menu_select+0x5d/0x7f
[  116.650040]  [<c038e4d8>] cpuidle_idle_call+0x47/0x9b
[  116.650040]  [<c038e491>] ? cpuidle_idle_call+0x0/0x9b
[  116.650040]  [<c01060ff>] cpu_idle+0xaf/0x106
[  116.650040]  [<c0441c87>] rest_init+0x67/0x69
[  116.650040]  =======================

