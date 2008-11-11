Return-Path: <linux-kernel-owner+w=401wt.eu-S1756337AbYKKNnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756337AbYKKNnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 08:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbYKKNm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 08:42:57 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:53311 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755360AbYKKNm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 08:42:56 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11380] lockdep warning: cpu_add_remove_lock at:cpu_maps_update_begin+0x14/0x16
Date: Tue, 11 Nov 2008 14:47:36 +0100
User-Agent: KMail/1.9.9
Cc: Oleg Nesterov <oleg@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Max Krasnyansky <maxk@qualcomm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <20081110073047.GA28578@elte.hu> <20081111120111.GA3503@redhat.com> <20081111110708.GE15645@elte.hu>
In-Reply-To: <20081111110708.GE15645@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111447.37858.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Ingo Molnar wrote:
> 
> * Oleg Nesterov <oleg@redhat.com> wrote:
> 
> > On 11/11, KOSAKI Motohiro wrote:
> > >
> > > it seem simple ABBA lock, right?
> > >
> > > -> #4 (&dev->mutex){--..}:
> > >        [<c0160f87>] validate_chain+0x831/0xaa2
> > >        [<c0161872>] __lock_acquire+0x67a/0x6e0
> > >        [<c0161933>] lock_acquire+0x5b/0x81
> > >        [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
> > >        [<c0782d02>] input_register_handle+0x26/0x7a			dev->mutex
> >                                                                         ^^^^^^^^^^
> > >        [<c04a62c9>] kbd_connect+0x64/0x8d
> > >        [<c0782842>] input_attach_handler+0x38/0x6b
> > >        [<c0784216>] input_register_handler+0x74/0xc3			input_mutex
> > >        [<c0f54e4b>] kbd_init+0x66/0x91
> > >        [<c0f54f7b>] vty_init+0xce/0xd7
> > >        [<c0f54952>] tty_init+0x193/0x197
> > >        [<c010112a>] do_one_initcall+0x42/0x133
> > >        [<c0f2d5cb>] kernel_init+0x16e/0x1d5
> > >        [<c0117c03>] kernel_thread_helper+0x7/0x10
> > >        [<ffffffff>] 0xffffffff
> > >
> > > -> #3 (input_mutex){--..}:
> > >        [<c0160f87>] validate_chain+0x831/0xaa2
> > >        [<c0161872>] __lock_acquire+0x67a/0x6e0
> > >        [<c0161933>] lock_acquire+0x5b/0x81
> > >        [<c0a660e4>] mutex_lock_interruptible_nested+0xde/0x2f8
> > >        [<c0783fbe>] input_register_device+0xff/0x17f		input_mutex
> > >        [<c048a889>] acpi_button_add+0x31e/0x429
> > >        [<c04889f4>] acpi_device_probe+0x43/0xde
> > >        [<c052c67f>] driver_probe_device+0xa5/0x120
> > >        [<c052c73c>] __driver_attach+0x42/0x64			dev->sem
> >                                                                 ^^^^^^^^
> > input_dev->mutex != device->sem
> > 
> > > ...
> > >        [<c0f2d201>] do_async_initcalls+0x1a/0x2a
> > >        [<c0150eec>] run_workqueue+0xc3/0x193			
> > >        [<c015195d>] worker_thread+0xbb/0xc7
> > >        [<c0153e2a>] kthread+0x40/0x66
> > 
> > What is the kernel version, btw? I can't find do_async_initcalls
> > in 2.6.27 or 2.6.28.
> 
> i suspect it's an older version of tip/master that still had async 
> initcalls.
> 
> > Anyway, this really looks like lockdep bug to me. Even if we really 
> > have the circular dependency (will try to grep more) I can't 
> > understand why lockdep claims that polldev_mutex depends on 
> > cpu_add_remove_lock.
> 
> ok, will re-report if i can trigger it again with latest kernels. 
> Rafael, please close this bug as cannot-reproduce for now.

Done.

Thanks,
Rafael
