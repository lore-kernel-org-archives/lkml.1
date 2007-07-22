Return-Path: <linux-kernel-owner+w=401wt.eu-S933279AbXGVXsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933279AbXGVXsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760613AbXGVXsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:48:36 -0400
Received: from ozlabs.org ([203.10.76.45]:53677 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765562AbXGVXsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:48:35 -0400
Subject: Re: [patch 3/9] cpu: deliver CPU_UP_CANCELED only to NOTIFY_OKed
	callbacks with CPU_UP_PREPARE
From: Rusty Russell <rusty@rustcorp.com.au>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Dmitriy Zavin <dmitriyz@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>, Ashok Raj <ashok.raj@intel.com>
In-Reply-To: <20070722153349.369335694@gmail.com>
References: <20070722153312.083951746@gmail.com>
	 <20070722153349.369335694@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Jul 2007 09:48:10 +1000
Message-Id: <1185148090.6344.108.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-23 at 00:33 +0900, Akinobu Mita wrote:
> plain text document attachment (cpuhotplug-nr-calls.patch)
> From: Akinobu Mita <akinobu.mita@gmail.com>
> 
> The functions in a CPU notifier chain is called with CPU_UP_PREPARE event
> before making the CPU online. If one of the callback returns NOTIFY_BAD,
> it stops to deliver CPU_UP_PREPARE event, and CPU online operation is canceled.
> Then CPU_UP_CANCELED event is delivered to the functions in a CPU notifier
> chain again.
> 
> This CPU_UP_CANCELED event is delivered to the functions which have been
> called with CPU_UP_PREPARE, not delivered to the functions which haven't
> been called with CPU_UP_PREPARE.
> 
> The problem that makes existing cpu hotplug error handlings complex is
> that the CPU_UP_CANCELED event is delivered to the function that has
> returned NOTIFY_BAD, too.
> 
> Usually we don't expect to call destructor function against the
> object that has failed to initialize. It is like:
> 
> 	err = register_something();
> 	if (err) {
> 		unregister_something();
> 		return err;
> 	}
> 
> So it is natural to deliver CPU_UP_CANCELED event only to the functions
> that have returned NOTIFY_OK with CPU_UP_PREPARE event and not to call
> the function that have returned NOTIFY_BAD. This is what this patch is doing.
> 
> Otherwise, every cpu hotplug notifiler has to track whether
> notifiler event is failed or not for each cpu.
> (drivers/base/topology.c is doing this with topology_dev_map)
> 
> Similary this patch makes same thing with CPU_DOWN_PREPARE and
> CPU_DOWN_FAILED evnets.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

This makes a great deal of sense; I consider it a bugfix.

Thanks!
Rusty.


