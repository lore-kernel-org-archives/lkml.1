Return-Path: <linux-kernel-owner+w=401wt.eu-S1760895AbZATLzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760895AbZATLzc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 06:55:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757200AbZATLzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 06:55:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49469 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757005AbZATLzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 06:55:22 -0500
Date: Tue, 20 Jan 2009 12:55:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       dbrownell@users.sourceforge.net
Subject: Re: 2.6.29-rc1 does not resume on Lenove T61
Message-ID: <20090120115500.GA4442@elte.hu>
References: <c4e36d110901111152o63c4cda0j88f4c89950bd2b90@mail.gmail.com> <b647ffbd0901190841j785172e5n24d29511a2e61332@mail.gmail.com> <20090119164440.GA20754@elte.hu> <200901192025.37711.rjw@sisk.pl> <c4e36d110901191431j62168b4yaf8a4ffdbbe38bea@mail.gmail.com> <20090119234905.GC452@elte.hu> <c4e36d110901200241x487092e9na0cda704de666d2b@mail.gmail.com> <c4e36d110901200348n4009800dyebaf932039babf30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4e36d110901200348n4009800dyebaf932039babf30@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(Cc:-ed Johannes Berg)

* Zdenek Kabelac <zdenek.kabelac@gmail.com> wrote:

> With network enabled - the error is back - thus it might be a bug in 
> ieee80211 stack ??

yes, the crash implicates the ieee80211 stack [ieee80211_stop() in 
net/mac80211/iface.c]:

> general protection fault: 0000 [#1] SMP
> RIP: 0010:[<ffffffff8053ce01>]  [<ffffffff8053ce01>] wait_for_common+0x131/0x190
> Process NetworkManager (pid: 2265, threadinfo ffff88006b508000, task
> Call Trace:
>  [<ffffffff8025a735>] synchronize_rcu+0x35/0x40
>  [<ffffffff8025a620>] ? wakeme_after_rcu+0x0/0x10
>  [<ffffffff8053ce3f>] ? wait_for_common+0x16f/0x190
>  [<ffffffff8024b424>] ? local_bh_enable+0xa4/0x110
>  [<ffffffff804c8ce1>] ? dev_deactivate+0x151/0x1d0
>  [<ffffffff804b750d>] ? dev_close+0x6d/0xd0
>  [<ffffffffa016b042>] ? ieee80211_stop+0x562/0x570 [mac80211]
>  [<ffffffffa016ab59>] ? ieee80211_stop+0x79/0x570 [mac80211]
>  [<ffffffff8053fb5f>] ? _spin_unlock_bh+0x2f/0x40
>  [<ffffffff804c8d3a>] ? dev_deactivate+0x1aa/0x1d0
>  [<ffffffff804b751c>] ? dev_close+0x7c/0xd0
>  [<ffffffff804b70dd>] ? dev_change_flags+0x9d/0x1e0
>  [<ffffffff804c05a5>] ? do_setlink+0x2b5/0x440
>  [<ffffffff8053fb26>] ? _read_unlock+0x26/0x30
>  [<ffffffff804c0905>] ? rtnl_setlink+0x115/0x160
>  [<ffffffff8053dc54>] ? mutex_lock_nested+0x284/0x360
>  [<ffffffff804c187a>] ? rtnetlink_rcv+0x1a/0x40
>  [<ffffffff804c1a2d>] ? rtnetlink_rcv_msg+0x18d/0x240
>  [<ffffffff804c18a0>] ? rtnetlink_rcv_msg+0x0/0x240
>  [<ffffffff804cc879>] ? netlink_rcv_skb+0x89/0xb0
>  [<ffffffff804c1889>] ? rtnetlink_rcv+0x29/0x40
>  [<ffffffff804cc274>] ? netlink_unicast+0x2c4/0x2e0
>  [<ffffffff804ae57e>] ? __alloc_skb+0x6e/0x150
>  [<ffffffff804cc4a4>] ? netlink_sendmsg+0x214/0x310
>  [<ffffffff804a59d7>] ? sock_sendmsg+0x127/0x140
>  [<ffffffff8025d1f0>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff8027222b>] ? lock_release_non_nested+0x9b/0x2e0
>  [<ffffffff802dbd96>] ? fget_light+0x106/0x110
>  [<ffffffff804a6737>] ? move_addr_to_kernel+0x57/0x60
>  [<ffffffff804afa4f>] ? verify_iovec+0x3f/0xe0
>  [<ffffffff804a5b79>] ? sys_sendmsg+0x189/0x320
>  [<ffffffff804a683f>] ? sys_sendto+0xff/0x120
>  [<ffffffff802f4a8a>] ? mntput_no_expire+0x2a/0x170
>  [<ffffffff802dc06a>] ? __fput+0x17a/0x1f0
>  [<ffffffff8026ee5a>] ? trace_hardirqs_on_caller+0x16a/0x1d0
>  [<ffffffff8029232e>] ? audit_syscall_entry+0x17e/0x1a0
>  [<ffffffff8053f6de>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8020c51b>] ? system_call_fastpath+0x16/0x1b

	Ingo
