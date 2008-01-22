Return-Path: <linux-kernel-owner+w=401wt.eu-S1756889AbYAVVCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756889AbYAVVCy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2008 16:02:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYAVVCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jan 2008 16:02:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46356 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751841AbYAVVCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2008 16:02:44 -0500
Date: Tue, 22 Jan 2008 13:02:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net,
       sparclinux@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
       Christoph Hellwig <hch@lst.de>
Subject: Re: 2.6.24-rc8-mm1: sparc64 warning at fs/file_table.c:49
 __fput+0x1a8/0x1e0()
Message-Id: <20080122130228.e7596163.akpm@linux-foundation.org>
In-Reply-To: <200801222130.24136.m.kozlowski@tuxland.pl>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<200801222130.24136.m.kozlowski@tuxland.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 22 Jan 2008 21:30:23 +0100 Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:
> Hello,
> 
> Issuing "sysrq-s sysrq-u" sequence causes these warnings on sparc64:
> 
> ------------[ cut here ]------------
> WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
> Modules linked in: sg sr_mod cdrom
> Call Trace:
>  [00000000004c9ac8] __fput+0x1b0/0x1e0
>  [00000000004c6978] filp_close+0x60/0x80
>  [00000000004c6a18] sys_close+0x80/0xe0
>  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
>  [0000000000012f1c] 0x12f24
> ---[ end trace 6dbe14ff8ec57744 ]---
> ------------[ cut here ]------------
> WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
> Modules linked in: sg sr_mod cdrom
> Call Trace:
>  [00000000004c9ac8] __fput+0x1b0/0x1e0
>  [00000000004c6978] filp_close+0x60/0x80
>  [00000000004c6a18] sys_close+0x80/0xe0
>  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
>  [0000000000012f1c] 0x12f24
> ---[ end trace 6dbe14ff8ec57744 ]---
> ------------[ cut here ]------------
> WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
> Modules linked in: sg sr_mod cdrom
> Call Trace:
>  [00000000004c9ac8] __fput+0x1b0/0x1e0
>  [00000000004c6978] filp_close+0x60/0x80
>  [00000000004c6a18] sys_close+0x80/0xe0
>  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
>  [0000000000012f1c] 0x12f24
> ---[ end trace 6dbe14ff8ec57744 ]---
> ------------[ cut here ]------------
> WARNING: at fs/file_table.c:49 __fput+0x1a8/0x1e0()
> Modules linked in: sg sr_mod cdrom
> Call Trace:
>  [00000000004c9ac8] __fput+0x1b0/0x1e0
>  [00000000004c6978] filp_close+0x60/0x80
>  [00000000004c6a18] sys_close+0x80/0xe0
>  [00000000004062d4] linux_sparc_syscall32+0x3c/0x40
>  [0000000000012f1c] 0x12f24
> ---[ end trace 6dbe14ff8ec57744 ]---
> 

That's

        WARN_ON(f->f_mnt_write_state == FILE_MNT_WRITE_TAKEN);

cc's added...
