Return-Path: <linux-kernel-owner+w=401wt.eu-S1754731AbZF1KFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731AbZF1KFS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 06:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZF1KFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 06:05:07 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57800 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZF1KFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 06:05:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XkMi/WD9nP6OpKHfqmtkPfqwnyP4F6TpixrJX7OCkzo9kNQNiQG26V1Gvi6LhC5cQi
         ji/q0vzE0KXNnpqAhP5BuRMyI3qoA38XAPOhmtY74mTc3TQmciYKCx3dxq6GARWLalKo
         xU8PAn1aZ3K588U4mprcxTCp38dvp/yJ77qMI=
Date: Sun, 28 Jun 2009 12:05:03 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: "David S. Miller" <davem@davemloft.net>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc1: WARNING: at mm/page_alloc.c:1743
	__alloc_pages_nodemask
Message-ID: <20090628100503.GA8568@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Thomas Meyer <thomas@m3y3r.de>,
	"David S. Miller" <davem@davemloft.net>,
	Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <1246112143.21110.2.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1246112143.21110.2.camel@localhost>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 04:15:43PM +0200, Thomas Meyer wrote:
> [    1.516209] ------------[ cut here ]------------
> [    1.516216] WARNING: at mm/page_alloc.c:1743 __alloc_pages_nodemask+0x153/0x550()
> [    1.516218] Hardware name: MS-7250
> [    1.516219] Modules linked in:
> [    1.516223] Pid: 1, comm: swapper Not tainted 2.6.31-rc1 #50
> [    1.516225] Call Trace:
> [    1.516232]  [<ffffffff8106c182>] ? warn_slowpath_common+0x84/0xb2
> [    1.516236]  [<ffffffff81178fb8>] ? sysfs_ilookup_test+0x0/0x3b
> [    1.516239]  [<ffffffff810e5ea8>] ? __alloc_pages_nodemask+0x153/0x550
> [    1.516245]  [<ffffffff811131bd>] ? kmem_cache_create+0x1ac/0x30c
> [    1.516249]  [<ffffffff810e6346>] ? __get_free_pages+0x22/0x77
> [    1.516253]  [<ffffffff81cb5b8f>] ? dccp_init+0xeb/0x38e
> [    1.516257]  [<ffffffff81cb5aa4>] ? dccp_init+0x0/0x38e
> [    1.516260]  [<ffffffff8100908e>] ? do_one_initcall+0x60/0x144
> [    1.516264]  [<ffffffff810c0040>] ? register_irq_proc+0xac/0xdb
> [    1.516268]  [<ffffffff81c6a88f>] ? kernel_init+0x170/0x1dd
> [    1.516272]  [<ffffffff8102cf8a>] ? child_rip+0xa/0x20
> [    1.516275]  [<ffffffff81c6a71f>] ? kernel_init+0x0/0x1dd
> [    1.516278]  [<ffffffff8102cf80>] ? child_rip+0x0/0x20
> [    1.516283] ---[ end trace 2e1baf37c897af4d ]---

Looks like DCCP is hitting the MAX_ORDER allocation sanity check, CCing relevant
people.
 
-- 
Regards/Gruss,
    Boris.
