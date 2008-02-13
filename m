Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbYBMQxP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbYBMQxP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:53:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760527AbYBMQxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:53:00 -0500
Received: from styx.suse.cz ([82.119.242.94]:47947 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756736AbYBMQw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:52:59 -0500
Date: Wed, 13 Feb 2008 17:52:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
cc: Zdenek Kabelac <zdenek.kabelac@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Jeste jeden bug
In-Reply-To: <c4e36d110802130841l591f20a4j32759821543b554c@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802131749460.30955@jikos.suse.cz>
References: <c4e36d110802130841l591f20a4j32759821543b554c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ the original mail was sent by Zdenek to me offlist ]

On Wed, 13 Feb 2008, Zdenek Kabelac wrote:

> [   68.379022] gnome-settings-[2941] trap int3 ip:3d2c840f34
> sp:7fff36f5d100 error:0<3>BUG: sleeping function called from invalid
> context at kernel/rwsem.c:21
> [   68.379039] in_atomic():1, irqs_disabled():0
> [   68.379044] no locks held by gnome-settings-/2941.
> [   68.379050] Pid: 2941, comm: gnome-settings- Not tainted 2.6.25-rc1 #30
> [   68.379054]
> [   68.379056] Call Trace:
> [   68.379061]  <#DB>  [<ffffffff81064883>] ? __debug_show_held_locks+0x13/0x30
> [   68.379109]  [<ffffffff81036765>] __might_sleep+0xe5/0x110
> [   68.379123]  [<ffffffff812f2240>] down_read+0x20/0x70
> [   68.379137]  [<ffffffff8109cdca>] print_vma_addr+0x3a/0x110
> [   68.379152]  [<ffffffff8100f435>] do_trap+0xf5/0x170
> [   68.379168]  [<ffffffff8100f52b>] do_int3+0x7b/0xe0
> [   68.379180]  [<ffffffff812f4a6f>] int3+0x9f/0xd0
> [   68.379203]  <<EOE>>
> [   68.379229]  in libglib-2.0.so.0.1505.0[3d2c800000+dc000]

Andi,

in commit 03252919 you introduced print_vma_addr(), but this funcion for 
obvious reasons takes mmap_sem, so it is not safe to call it from atomic 
context (i.e. do_trap(), for example), which is behavior your patch 
introduced.

-- 
Jiri Kosina
SUSE Labs
