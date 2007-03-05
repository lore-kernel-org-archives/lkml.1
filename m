Return-Path: <linux-kernel-owner+w=401wt.eu-S1752571AbXCEAa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752571AbXCEAa0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 19:30:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752574AbXCEA3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 19:29:52 -0500
Received: from smtp.osdl.org ([65.172.181.24]:53901 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbXCEA32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 19:29:28 -0500
Date: Sun, 4 Mar 2007 16:29:24 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "J.A. =?ISO-8859-1?B?TWFnYWxs824i?= <jamagallon@ono.com>"@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
Message-Id: <20070304162924.a050b270.akpm@linux-foundation.org>
In-Reply-To: <20070305011133.570a9ba8@werewolf-wl>
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>
	<20070305011133.570a9ba8@werewolf-wl>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Mar 2007 01:11:33 +0100 "J.A. Magallón" <jamagallon@ono.com> wrote:

> On Fri, 2 Mar 2007 03:00:26 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc2/2.6.21-rc2-mm1/
> > 
> 
> nfs blocks shutdown and reboot.
> If I try to do 'service nfs stop', the box hangs, no login, no SysRQ-T or P,
> S-U-B works at least.
> 
> Any ideas ?

metoo, thankfully.

[  133.182746] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[  133.183231] NFSD: unable to find recovery directory /var/lib/nfs/v4recovery
[  133.183390] NFSD: starting 90-second grace period
[  149.765128] BUG: soft lockup detected on CPU#0!
[  149.765256]  [<c0120c26>] update_process_times+0x33/0x55
[  149.765396]  [<c012c4af>] tick_periodic+0x4f/0x59
[  149.765516]  [<c012c4c8>] tick_handle_periodic+0xf/0x5f
[  149.765645]  [<c012c4c8>] tick_handle_periodic+0xf/0x5f
[  149.765778]  [<c012c56a>] tick_do_broadcast+0x1f/0x3f
[  149.765903]  [<c012c5b5>] tick_handle_periodic_broadcast+0x1b/0x5b
[  149.766053]  [<c012023b>] run_timer_softirq+0x11/0x12f
[  149.766188]  [<c0106dc6>] timer_interrupt+0x1a/0x20
[  149.766314]  [<c013d8f8>] handle_IRQ_event+0x1a/0x3f
[  149.766449]  [<c013e4cd>] handle_edge_irq+0x9d/0xcc
[  149.766573]  [<c0105ef2>] do_IRQ+0x57/0x71
[  149.766678]  [<c0105ef7>] do_IRQ+0x5c/0x71
[  149.766780]  [<c0105ef7>] do_IRQ+0x5c/0x71
[  149.766889]  [<c01044a3>] common_interrupt+0x23/0x28
[  149.767024]  [<f9009cc3>] svc_close_socket+0x93/0x96 [sunrpc]
[  149.767206]  [<f90086ba>] svc_destroy+0x8a/0xb7 [sunrpc]
[  149.767374]  [<f8cf028a>] lockd+0x1fd/0x20f [lockd]
[  149.767511]  [<c010689f>] do_syscall_trace+0x4c/0xdf
[  149.767640]  [<c0103bfa>] syscall_exit_work+0x12/0x17
[  149.767765]  [<f8cf008d>] lockd+0x0/0x20f [lockd]
[  149.767901]  [<f8cf008d>] lockd+0x0/0x20f [lockd]
[  149.768030]  [<c0104653>] kernel_thread_helper+0x7/0x10
[  149.768165]  =======================

I'll bisect it.
