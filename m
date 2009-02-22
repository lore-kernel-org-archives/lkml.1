Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbZBVJVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbZBVJVH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 04:21:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZBVJUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 04:20:54 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:62205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZBVJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 04:20:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=M+mXd/tLUWcYNWEBp7iem3TMKM91eV4O/RB5ARKz+6uqHTGe8iRBWp/w43fU4vU/5q
         fFhd9KjpetxlEKPiBfIUV7Jv8NhYEnpUY0SMg1OHendQiWBk6ncQaj89d49V12aeMFWC
         Xnbpg7sehYhllwasRF+ds8/ccUTR/LQGZtiqI=
Date: Sun, 22 Feb 2009 12:27:22 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: kosaki.motohiro@jp.fujitsu.com, serue@us.ibm.com, mingo@elte.hu,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: Broken "User namespaces: Only put the userns when we unhash
	the uid"
Message-ID: <20090222092722.GA12347@x200.localdomain>
References: <20090222001257.GA15755@x200.localdomain> <6395.1235263079@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6395.1235263079@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 22, 2009 at 12:37:59AM +0000, David Howells wrote:
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > The following commit breaks clone(CLONE_NEWUSER)
> > with an oops.
> 
> Can you give the actual text of the oops, please?

One needs UP kernel for this. The box is really dead afterwards.

=============================================
[ INFO: possible recursive locking detected ]
2.6.29-rc5-2ec77fc93ca8731368fbe8e71f805c0569d4bcee #4
---------------------------------------------
swapper/0 is trying to acquire lock:
 (uidhash_lock){.+..}, at: [<c02182c8>] _atomic_dec_and_lock+0x18/0x40

but task is already holding lock:
 (uidhash_lock){.+..}, at: [<c02182c8>] _atomic_dec_and_lock+0x18/0x40

other info that might help us debug this:
1 lock held by swapper/0:
 #0:  (uidhash_lock){.+..}, at: [<c02182c8>] _atomic_dec_and_lock+0x18/0x40

stack backtrace:
Pid: 0, comm: swapper Not tainted 2.6.29-rc5-2ec77fc93ca8731368fbe8e71f805c0569d4bcee #4
Call Trace:
 [<c013ecd5>] validate_chain+0xac5/0x1130
 [<c013e5e0>] ? validate_chain+0x3d0/0x1130
 [<c013e5e0>] ? validate_chain+0x3d0/0x1130
 [<c013f5b6>] __lock_acquire+0x276/0xa10
 [<c013f5b6>] ? __lock_acquire+0x276/0xa10
 [<c013fdac>] lock_acquire+0x5c/0x80
 [<c02182c8>] ? _atomic_dec_and_lock+0x18/0x40
 [<c03bc0ac>] _spin_lock+0x3c/0x50
 [<c02182c8>] ? _atomic_dec_and_lock+0x18/0x40
 [<c02182c8>] _atomic_dec_and_lock+0x18/0x40
 [<c0125887>] free_uid+0x27/0xc0
 [<c01459f0>] ? free_user_ns+0x0/0x20
 [<c0145a01>] free_user_ns+0x11/0x20
 [<c021a4cb>] kref_put+0x2b/0x80
 [<c02182c8>] ? _atomic_dec_and_lock+0x18/0x40
 [<c01258c0>] free_uid+0x60/0xc0
 [<c013492f>] put_cred_rcu+0x2f/0x60
 [<c03bc709>] ? _spin_unlock_irqrestore+0x39/0x70
 [<c0148982>] __rcu_process_callbacks+0xd2/0x230
 [<c0148af2>] rcu_process_callbacks+0x12/0x30
 [<c012058a>] __do_softirq+0x7a/0x130
 [<c0120695>] do_softirq+0x55/0x60
 [<c012098b>] irq_exit+0x7b/0x80
 [<c0104f0e>] do_IRQ+0x3e/0x80
 [<c013da7c>] ? trace_hardirqs_on_caller+0xfc/0x190
 [<c01037ec>] common_interrupt+0x2c/0x34
 [<c01087df>] ? mwait_idle+0x3f/0x60
 [<c0101bc5>] cpu_idle+0x45/0x80
 [<c03af9f1>] rest_init+0x61/0x70
