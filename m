Return-Path: <linux-kernel-owner+w=401wt.eu-S1755034AbZIJDZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755034AbZIJDZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 23:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755013AbZIJDZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 23:25:47 -0400
Received: from mail-px0-f194.google.com ([209.85.216.194]:43878 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009AbZIJDZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 23:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=p8IMRs88tGTBSM/ypw2tyHHj5DoZeFP3V9f817A0+vMOGfv82ua8AOAUsH8RXEU4Rp
         BvagvnsdkOk72kbK9s5FuL5ag5H0Y8Pw6KlzTXgUpCYtLAh7er8FxngrV0KjN482jeW5
         A9oaWoSkENKN7jC8TjlGmuDEqVnQfxi/4ntok=
MIME-Version: 1.0
In-Reply-To: <6278d2220909091420g688bd11fybc33be4e472757b1@mail.gmail.com>
References: <6278d2220909091420g688bd11fybc33be4e472757b1@mail.gmail.com>
Date: Thu, 10 Sep 2009 11:25:49 +0800
Message-ID: <d82e647a0909092025q377729fau88e39214c349d746@mail.gmail.com>
Subject: Re: [2.6.31-rc9] hotplug SATA vs lockdep: false positive?
From: Ming Lei <tom.leiming@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/10 Daniel J Blueman <daniel.blueman@gmail.com>:
> When hot-plugging my SATA DVD drive into my laptop, I see a lockdep
> warning [1]. On closer inspection, both flush_workqueue() and
> worker_thread() do tricks with lockdep maps. False positive?

> Call Trace:
>  [<ffffffff8108c8a7>] print_circular_bug_tail+0xa7/0x100
>  [<ffffffff8108ebe1>] __lock_acquire+0xef1/0x1240
>  [<ffffffff8108a808>] ? add_lock_to_list+0x58/0xf0
>  [<ffffffff8108f04e>] lock_acquire+0x11e/0x170
>  [<ffffffff81073a70>] ? flush_workqueue+0x0/0xf0 (workqueue.c:397)
>  [<ffffffff812f6ebd>] ? acpi_os_execute_hp_deferred+0x0/0x3e
>  [<ffffffff81073acc>] flush_workqueue+0x5c/0xf0 (workqueue.c:403)

The lockdep warning is caused by calling flush_workqueue() from the
work function of
acpi_os_execute_hp_deferred. I don't know if it is safe to do that.

>  [<ffffffff81073a70>] ? flush_workqueue+0x0/0xf0 (workqueue.c:397)
>  [<ffffffff812f6eaf>] acpi_os_wait_events_complete+0x10/0x1e drivers/acpi/osl.c
>  [<ffffffff812f6ee7>] acpi_os_execute_hp_deferred+0x2a/0x3e
>  [<ffffffff81072a98>] worker_thread+0x248/0x3c0 (workqueue.c:292)
>  [<ffffffff81072a42>] ? worker_thread+0x1f2/0x3c0
>  [<ffffffff81077900>] ? autoremove_wake_function+0x0/0x40
>  [<ffffffff81072850>] ? worker_thread+0x0/0x3c0
>  [<ffffffff81077456>] kthread+0xa6/0xc0
>  [<ffffffff8100d29a>] child_rip+0xa/0x20
>  [<ffffffff8100cbd4>] ? restore_args+0x0/0x30
>  [<ffffffff810773b0>] ? kthread+0x0/0xc0
>  [<ffffffff8100d290>] ? child_rip+0x0/0x20
>

-- 
Lei Ming
