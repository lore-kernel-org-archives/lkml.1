Return-Path: <linux-kernel-owner+w=401wt.eu-S1758426AbYJMWBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426AbYJMWBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 18:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbYJMWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 18:01:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40544 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755490AbYJMWBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 18:01:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dtor@insightbb.com>
Subject: [2.6.27-git-a447c093244] BUG: spinlock bad magic on CPU#0, setserial/3527
Date: Tue, 14 Oct 2008 00:05:39 +0200
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810140005.39852.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Linus' tree from today on Asus L5D:

BUG: spinlock bad magic on CPU#0, setserial/3527
 lock: ffffffff80dae020, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
Pid: 3527, comm: setserial Not tainted 2.6.27-git #57
Call Trace:
 [<ffffffff80345aae>] spin_bug+0xde/0xf0
 [<ffffffff80345bd6>] _raw_spin_lock+0x86/0x140
 [<ffffffff804823ca>] _spin_lock_irq+0x3a/0x50
 [<ffffffff803ae89d>] ? serial8250_startup+0x13d/0x610
 [<ffffffff803ae89d>] serial8250_startup+0x13d/0x610
 [<ffffffff803abd9a>] uart_startup+0x6a/0x1a0
 [<ffffffff803acca5>] uart_open+0x115/0x4a0
 [<ffffffff80482286>] ? _spin_unlock+0x26/0x30
 [<ffffffff8038d271>] ? check_tty_count+0x21/0xc0
 [<ffffffff8039067a>] tty_open+0x1ea/0x440
 [<ffffffff802a8490>] chrdev_open+0xa0/0x1c0
 [<ffffffff802a385c>] __dentry_open+0xcc/0x2c0
 [<ffffffff802a83f0>] ? chrdev_open+0x0/0x1c0
 [<ffffffff802a3a94>] nameidata_to_filp+0x44/0x60
 [<ffffffff802b052d>] do_filp_open+0x1fd/0x8f0
 [<ffffffff802add86>] ? getname+0x36/0x210
 [<ffffffff802bda06>] ? alloc_fd+0x106/0x130
 [<ffffffff802a36ae>] do_sys_open+0x5e/0xf0
 [<ffffffff802a376b>] sys_open+0x1b/0x20
 [<ffffffff8020b66b>] system_call_fastpath+0x16/0x1b

Do I have to bisect? :-)

Rafael
