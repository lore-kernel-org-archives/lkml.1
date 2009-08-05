Return-Path: <linux-kernel-owner+w=401wt.eu-S1755717AbZHEGjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbZHEGjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 02:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbZHEGjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 02:39:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:35420 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691AbZHEGjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 02:39:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HmXOCUWTjeQSd4ZgT7mpE6NY1aw521hXM63lCjUc79veID8lpOIx38OMarv8XcBGwu
         G/TiR5LGt11CJfhumJjZ6FkjdhsuLE4gH1fKlXxYaKP2iaUbaf5vlYNWbbxhkVZC8u3u
         ax9yKzg3Bc4kaZ10f7rjQ7Nn/DOKJzZRgdja0=
Date: Wed, 5 Aug 2009 14:39:46 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2009-08-04-14-22 uploaded
Message-ID: <20090805063946.GA1934@darkstar>
References: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908042125.n74LP9qY018119@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi andrew,

I see following lockdep warning with this release:

[    0.474144] INFO: trying to register non-static key.
[    0.474144] the code is fine but needs lockdep annotation.
[    0.474144] turning off the locking correctness validator.
[    0.474144] Pid: 1, comm: swapper Not tainted 2.6.31-rc5-mm1 #7
[    0.474144] Call Trace:
[    0.474144]  [<c1047f1e>] register_lock_class+0x58/0x241
[    0.474144]  [<c1049ab1>] __lock_acquire+0xac/0xb73
[    0.474144]  [<c1076eb5>] ? __alloc_pages_nodemask+0xe2/0x483
[    0.474144]  [<c1048b64>] ? mark_lock+0x1e/0x1c7
[    0.474144]  [<c1048b64>] ? mark_lock+0x1e/0x1c7
[    0.474144]  [<c1048d50>] ? mark_held_locks+0x43/0x5b
[    0.474144]  [<c10940a6>] ? kmem_cache_alloc+0xac/0x11b
[    0.474144]  [<c104a615>] lock_acquire+0x9d/0xc0
[    0.474144]  [<c12b8b96>] ? netif_addr_lock_bh+0xd/0xf
[    0.474144]  [<c1330feb>] _spin_lock_bh+0x20/0x2f
[    0.474144]  [<c12b8b96>] ? netif_addr_lock_bh+0xd/0xf
[    0.474144]  [<c12b8b96>] netif_addr_lock_bh+0xd/0xf
[    0.474144]  [<c12bc3c3>] alloc_netdev_mq+0xf9/0x1a5
[    0.474144]  [<c121f016>] ? loopback_setup+0x0/0x74
[    0.474144]  [<c1578d49>] loopback_net_init+0x20/0x5d
[    0.474144]  [<c12b7907>] register_pernet_operations+0x13/0x15
[    0.474144]  [<c12b7970>] register_pernet_device+0x1f/0x47
[    0.474144]  [<c157ee8d>] net_dev_init+0xfe/0x14d
[    0.474144]  [<c1001137>] do_one_initcall+0x4a/0x11a
[    0.474144]  [<c157ed8f>] ? net_dev_init+0x0/0x14d
[    0.474144]  [<c1067e00>] ? register_irq_proc+0x64/0xa8
[    0.474144]  [<c1067e97>] ? init_irq_proc+0x53/0x60
[    0.474144]  [<c1557535>] kernel_init+0x129/0x17a
[    0.474144]  [<c155740c>] ? kernel_init+0x0/0x17a
[    0.474144]  [<c1003d47>] kernel_thread_helper+0x7/0x10

--
Regards
dave
