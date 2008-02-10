Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbYBJA3N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbYBJA3N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 19:29:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755362AbYBJA26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 19:28:58 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59621 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbYBJA25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 19:28:57 -0500
Date: Sat, 9 Feb 2008 16:26:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Miles Lane" <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Nishanth Aravamudan <nacc@us.ibm.com>,
       Adam Litke <agl@us.ibm.com>, David Gibson <david@gibson.dropbear.id.au>
Subject: Re: 2.6.24-git20 -- BUG: sleeping function called from invalid
 context at include/asm/uaccess_32.h:449
Message-Id: <20080209162643.fd3822f1.akpm@linux-foundation.org>
In-Reply-To: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com>
References: <a44ae5cd0802091103s4c24c70fyc747d9c4ab9a9897@mail.gmail.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Feb 2008 14:03:28 -0500 "Miles Lane" <miles.lane@gmail.com> wrote:

> Command run:
>      find /proc | xargs tail
> 
> [ 2710.028219] BUG: sleeping function called from invalid context at
> include/asm/uaccess_32.h:449
> [ 2710.028229] in_atomic():1, irqs_disabled():0
> [ 2710.028232] 1 lock held by head/9380:
> [ 2710.028234]  #0:  (hugetlb_lock){--..}, at: [<c016734f>]
> hugetlb_overcommit_handler+0x16/0x3e
> [ 2710.028248] Pid: 9380, comm: head Not tainted 2.6.24-git20 #5
> [ 2710.028260]  [<c0118749>] __might_sleep+0xc2/0xc9
> [ 2710.028267]  [<c021cb39>] copy_to_user+0x32/0x49
> [ 2710.028277]  [<c0123f6a>] do_proc_doulongvec_minmax+0x1df/0x27f
> [ 2710.028289]  [<c012403c>] proc_doulongvec_minmax+0x15/0x17
> [ 2710.028295]  [<c0167363>] hugetlb_overcommit_handler+0x2a/0x3e
> [ 2710.028303]  [<c01a1462>] proc_sys_read+0x5e/0x7b
> [ 2710.028311]  [<c01a1404>] ? proc_sys_read+0x0/0x7b
> [ 2710.028317]  [<c0170d7a>] vfs_read+0x8a/0x106
> [ 2710.028325]  [<c017116f>] sys_read+0x3b/0x60
> [ 2710.028331]  [<c0103e32>] sysenter_past_esp+0x5f/0xa5

Ugh, how did I let that one through?

Guys, how often mut it be said?  PLEASE always test all code with all
kernel deubg options enabled.
