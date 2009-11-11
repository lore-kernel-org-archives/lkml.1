Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbZKKLvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbZKKLvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 06:51:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbZKKLvY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 06:51:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757383AbZKKLvX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 06:51:23 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related to preempt_count leakage in keventd)
Date: Wed, 11 Nov 2009 12:52:48 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc6-tst; KDE/4.3.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Marcel Holtmann <marcel@holtmann.org>,
       linux-bluetooth@vger.kernel.org
References: <200911091250.31626.rjw@sisk.pl> <200911100119.38019.rjw@sisk.pl> <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911111252.48214.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 November 2009, Linus Torvalds wrote:
> 
...
> 
> So I don't know, but it might be worthwhile to see if the problem goes 
> away if you disable sound. Just to narrow down what has changed.

I thought that the problem was somehow related to user space, because it only
happens after we've thawed tasks.  At least, all of the call traces I was able
to collect indicated so.

Moreover, in a few cases I got

kernel: PM: Finishing wakeup.
kernel: Restarting tasks ...
kernel: usb 5-2: USB disconnect, address 2
kernel: done.
bluetoothd[3445]: HCI dev 0 unregistered
bluetoothd[3445]: Unregister path: /org/bluez/3445/hci0
bluetoothd[3445]: Unregistered interface org.bluez.NetworkPeer on path /org/bluez/3445/hci0
bluetoothd[3445]: Unregistered interface org.bluez.NetworkHub on path /org/bluez/3445/hci0
bluetoothd[3445]: Unregistered interface org.bluez.NetworkRouter on path /org/bluez/3445/hci0
kernel: Slab corruption: size-512 start=ffff88007f1182b0, len=512

and so on (of course, the bluetoothd PID was different each time), so I thought
that the problem might be related to Bluetooth.

So, I've disabled the Bluetooth subsystem in the kernel config and I'm not able
to reproduce the problem any more (at least not within 50 consecutive
suspend-resume and hibernate-resume cycles).  Thus Bluetooth seems to be
at least necessary to reproduce the issue and perhaps it's also the cause of
it.

Rafael
