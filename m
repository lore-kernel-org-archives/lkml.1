Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbXKDX2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbXKDX2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 18:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbXKDX20
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 18:28:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33013 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbXKDX2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 18:28:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: nigel@suspend2.net
Subject: Re: PID namespaces break initrd+hibernate combination?
Date: Mon, 5 Nov 2007 00:45:24 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       "suspend2-devel" <suspend2-devel@lists.suspend2.net>
References: <200711050936.36615.nigel@nigel.suspend2.net>
In-Reply-To: <200711050936.36615.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711050045.24876.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 4 of November 2007, Nigel Cunningham wrote:
> Hi all.
> 
> Please excuse me if this has already been answered. I'm not currently subscribed to LKML.
> 
> I've just been preparing a new tux-on-ice release against Linus' current tree, and encountered a failure to freeze pid 1 when seeking to resume, using an initrd:
> 
> [   74.192734] Freezing of tasks failed after 19.99 seconds (1 tasks refusing to freeze):
> [   74.193502]   task                        PC stack   pid father
> [   74.193504] swapper       S ffff810002023030  4968     1      0
> [   74.193512]  ffff81000203fdb0 0000000000000046 ffff810002023040 ffff810003249140
> [   74.194296]  ffff81000203fd80 ffffffff803150a1 ffff81000203fdb0 ffff810002023180
> [   74.195087]  ffff810002023030 0000000000000004 0000000000000001 0000000000000001
> [   74.195860] Call Trace:
> [   74.196123]  [<ffffffff803150a1>] security_task_wait+0x11/0x20
> [   74.196692]  [<ffffffff802320cd>] do_wait+0x51d/0xda0
> [   74.197187]  [<ffffffff802292f0>] default_wake_function+0x0/0x10
> [   74.197772]  [<ffffffff8023297c>] sys_wait4+0x2c/0x30
> [   74.198264]  [<ffffffff805f4bb5>] initrd_load+0x175/0x370
> [   74.198794]  [<ffffffff805f211f>] prepare_namespace+0x8f/0x1d0
> [   74.199362]  [<ffffffff805f174d>] kernel_init+0x1ad/0x2b0
> [   74.199889]  [<ffffffff8047e526>] _spin_unlock_irq+0x26/0x60
> [   74.200439]  [<ffffffff8022afc7>] finish_task_switch+0x67/0xc0
> [   74.201008]  [<ffffffff8020c548>] child_rip+0xa/0x12
> [   74.201494]  [<ffffffff80364770>] acpi_os_acquire_lock+0x9/0xb
> [   74.202063]  [<ffffffff805f15a0>] kernel_init+0x0/0x2b0
> [   74.202570]  [<ffffffff8020c53e>] child_rip+0x0/0x12
> 
> I believe it might be related to pid namespaces, but am not completely sure yet (will do a git bisect if needs be).
> 
> So, then, I'm writing to ask: Is this a known issue? Is there any fix already available that I've not found in my googling?

Not known to me and I haven't tried the PID namespaces yet.

Greetings,
Rafael
