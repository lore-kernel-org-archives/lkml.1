Return-Path: <linux-kernel-owner+w=401wt.eu-S1161616AbXDYGlU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161616AbXDYGlU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 02:41:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161618AbXDYGlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 02:41:19 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33471 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161616AbXDYGlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 02:41:18 -0400
Date: Tue, 24 Apr 2007 23:41:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc7-mm1 + sysfs patch -- RTNL: assertion failed at
 net/ipv6/addrconf.c (2123)
Message-Id: <20070424234115.6c6bc7c3.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0704242335n637b1b5cwd027a3d253820f91@mail.gmail.com>
References: <a44ae5cd0704242335n637b1b5cwd027a3d253820f91@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007 23:35:37 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:

> And then this:
> [  278.835674] RTNL: assertion failed at net/ipv6/addrconf.c (2123)
> [  278.835684]  [<c0104e0f>] show_trace_log_lvl+0x1a/0x30
> [  278.835701]  [<c0105a26>] show_trace+0x12/0x14
> [  278.835713]  [<c0105ab3>] dump_stack+0x16/0x18
> [  278.835723]  [<f95c660a>] addrconf_notify+0x5dd/0x7d0 [ipv6]
> [  278.835795]  [<c0125572>] notifier_call_chain+0x2b/0x4a
> [  278.835809]  [<c01255be>] __raw_notifier_call_chain+0x19/0x1f
> [  278.835822]  [<c01255de>] raw_notifier_call_chain+0x1a/0x1c
> [  278.835834]  [<c025041e>] netdev_state_change+0x23/0x35
> [  278.835849]  [<c0258e76>] rtnl_setlink+0x34f/0x3ef
> [  278.835861]  [<c025845e>] rtnetlink_rcv_msg+0x198/0x1b2
> [  278.835873]  [<c025f4b3>] netlink_run_queue+0x6f/0xe1
> [  278.835885]  [<c0258277>] rtnetlink_rcv+0x29/0x44
> [  278.835896]  [<c025f82c>] netlink_data_ready+0x15/0x55
> [  278.835907]  [<c025e877>] netlink_sendskb+0x22/0x53
> [  278.835918]  [<c025f1f0>] netlink_unicast+0x1bb/0x1d5
> [  278.835929]  [<c025f80b>] netlink_sendmsg+0x246/0x252
> [  278.835940]  [<c02472e6>] sock_sendmsg+0xcc/0xe5
> [  278.835951]  [<c0247beb>] sys_sendto+0xcc/0xec
> [  278.835961]  [<c0247c41>] sys_send+0x36/0x38
> [  278.835971]  [<c02483f6>] sys_socketcall+0x13e/0x241
> [  278.835982]  [<c0103e66>] sysenter_past_esp+0x5f/0x99
> [  278.835993]  =======================

yes, that's the one I mentioned in the release notes.  It appears
to be harmless.

Dave has identified some fishiness in the netlink code which
might have caused this.
