Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbZKMIfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbZKMIfl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 03:35:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZKMIff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 03:35:35 -0500
Received: from stinky.trash.net ([213.144.137.162]:44740 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZKMIfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 03:35:34 -0500
Message-ID: <4AFD1A58.6090201@trash.net>
Date: Fri, 13 Nov 2009 09:35:36 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "Yin, Kangkai" <kangkai.yin@intel.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_log: fix sleeping function called from
 invalid context in seq_show()
References: <20091113063640.GA29012@localhost>
In-Reply-To: <20091113063640.GA29012@localhost>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> [  171.925285] BUG: sleeping function called from invalid context at kernel/mutex.c:280
> [  171.925296] in_atomic(): 1, irqs_disabled(): 0, pid: 671, name: grep
> [  171.925306] 2 locks held by grep/671:
> [  171.925312]  #0:  (&p->lock){+.+.+.}, at: [<c10b8acd>] seq_read+0x25/0x36c
> [  171.925340]  #1:  (rcu_read_lock){.+.+..}, at: [<c1391dac>] seq_start+0x0/0x44
> [  171.925372] Pid: 671, comm: grep Not tainted 2.6.31.6-4-netbook #3
> [  171.925380] Call Trace:
> [  171.925398]  [<c105104e>] ? __debug_show_held_locks+0x1e/0x20
> [  171.925414]  [<c10264ac>] __might_sleep+0xfb/0x102
> [  171.925430]  [<c1461521>] mutex_lock_nested+0x1c/0x2ad
> [  171.925444]  [<c1391c9e>] seq_show+0x74/0x127
> [  171.925456]  [<c10b8c5c>] seq_read+0x1b4/0x36c
> [  171.925469]  [<c10b8aa8>] ? seq_read+0x0/0x36c
> [  171.925483]  [<c10d5c8e>] proc_reg_read+0x60/0x74
> [  171.925496]  [<c10d5c2e>] ? proc_reg_read+0x0/0x74
> [  171.925510]  [<c10a4468>] vfs_read+0x87/0x110
> [  171.925523]  [<c10a458a>] sys_read+0x3b/0x60
> [  171.925538]  [<c1002a49>] syscall_call+0x7/0xb
> 
> Fix it by replacing RCU with nf_log_mutex.

Applied, thanks.
