Return-Path: <linux-kernel-owner+w=401wt.eu-S1753549AbXEFMqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbXEFMqW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 08:46:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754112AbXEFMqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 08:46:22 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:38915 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbXEFMqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 08:46:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=GDeziBE8oMghpDGpMCtY27m90+TXUnjkCfEuDcqm57MSjj/lKydG/5nPxuKWOX8yYYmRDiPTj9UKOUdg5LuteSetOcoGrhJZCC74z5cpNcFBu0wyBWX7E6jSHCuVKXiQQS7MEtUJJqvwnwmkoRfZKXkDS456H4IEherbWmU0wCA=
Message-ID: <a781481a0705060546o2e3f5914v5a83adb8d73afe01@mail.gmail.com>
Date: Sun, 6 May 2007 18:16:20 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Ray Lee" <ray-lk@madrabbit.org>
Subject: Re: BUG: sleeping function called from invalid context at net/core/sock.c:1523
Cc: LKML <linux-kernel@vger.kernel.org>, "Pavel Machek" <pavel@suse.cz>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Max Krasnyansky" <maxk@qualcomm.com>, marcel@holtmann.org,
       "pm list" <linux-pm@lists.linux-foundation.org>
In-Reply-To: <2c0942db0705051425kd878e7exf9484ee8d03cd3bb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <2c0942db0705051425kd878e7exf9484ee8d03cd3bb@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ray,

On 5/6/07, Ray Lee <ray-lk@madrabbit.org> wrote:
> Upon resume (from suspend to RAM) of my laptop, I'm getting the
> following. (Not a regression, it's been there a while.) This is under
> 2.6.21. Everything *seems* fine afterward, but... <shrug> -- it's not
> like I use bluetooth all that often.
>
> My laptop has the bluetooth adapter hooked via USB insternally, so
> it's the hci_usb driver. Authors cc:d.
>
> [    1.329537] BUG: sleeping function called from invalid context at
> net/core/sock.c:1523
> [    1.329574] in_atomic():1, irqs_disabled():0
> [    1.329576] INFO: lockdep is turned off.
> [    1.329578]
> [    1.329578] Call Trace:
> [    1.329585]  [<ffffffff8029cedc>] debug_show_held_locks+0x1c/0x30
> [    1.329598]  [<ffffffff8020b2f5>] __might_sleep+0xe5/0xf0
> [    1.329603]  [<ffffffff803cfdbc>] lock_sock_nested+0x2c/0x120
> [    1.329617]  [<ffffffff881c9a6a>] :bluetooth:hci_sock_dev_event+0x4a/0xf0
> [    1.329627]  [<ffffffff881c9ae7>] :bluetooth:hci_sock_dev_event+0xc7/0xf0
> [    1.329634]  [<ffffffff80269cef>] notifier_call_chain+0x2f/0x50
> [    1.329639]  [<ffffffff80269d49>] atomic_notifier_call_chain+0x39/0x70
> [    1.329649]  [<ffffffff881c4d86>] :bluetooth:hci_notify+0x16/0x20
> [    1.329657]  [<ffffffff881c5deb>] :bluetooth:hci_unregister_dev+0x5b/0x80
> [    1.329664]  [<ffffffff8825e136>] :hci_usb:hci_usb_disconnect+0x56/0x90
> [    1.329683]  [<ffffffff8801e0fe>] :usbcore:usb_unbind_interface+0x4e/0xa0
> [    1.329690]  [<ffffffff80392e03>] __device_release_driver+0x93/0xc0
> [    1.329694]  [<ffffffff803933e6>] device_release_driver+0x46/0x70
> [    1.329699]  [<ffffffff80392638>] bus_remove_device+0x78/0x90
> [    1.329703]  [<ffffffff80390697>] device_del+0x187/0x200
> [    1.329717]  [<ffffffff8801b4d2>] :usbcore:usb_disable_device+0x82/0x110
> [    1.329731]  [<ffffffff8801745a>] :usbcore:usb_disconnect+0xba/0x140
> [    1.329746]  [<ffffffff88018440>] :usbcore:hub_thread+0x400/0xcc0
> [    1.329757]  [<ffffffff80297970>] autoremove_wake_function+0x0/0x40
> [    1.329772]  [<ffffffff88018040>] :usbcore:hub_thread+0x0/0xcc0
> [    1.329775]  [<ffffffff802977a0>] keventd_create_kthread+0x0/0x90
> [    1.329781]  [<ffffffff80233e73>] kthread+0xd3/0x110
> [    1.329784]  [<ffffffff80228890>] schedule_tail+0x0/0xe0
> [    1.329791]  [<ffffffff80260648>] child_rip+0xa/0x12
> [    1.329796]  [<ffffffff80260200>] restore_args+0x0/0x30
> [    1.329802]  [<ffffffff80233da0>] kthread+0x0/0x110
> [    1.329806]  [<ffffffff8026063e>] child_rip+0x0/0x12
> [    1.329809]

Hmmm ... net/bluetooth/hci_sock.c:hci_sock_dev_event() is calling
lock_sock() which can sleep (while holding the hci_sk_list.lock
read-write spinlock).

Can't really convert hci_sk_list.lock to a rwsem as
hci_sock_dev_event() is the notifier_call for hci_sock_nblock which is
an atomic notifier and so executes in atomic context.

We could convert hci_sock_nblock itself to a blocking notifier too,
but then I'm not _that_ familiar with this code to do that myself.

Anyway, this doesn't look like anything to do with suspend-resume.
Perhaps you could try to send this on bluez-devel@lists.sf.net or
netdev@vger.kernel.org or something.

Cheers,
Satyam
