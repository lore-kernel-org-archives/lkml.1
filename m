Return-Path: <linux-kernel-owner+w=401wt.eu-S1751872AbXE2Xo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872AbXE2Xo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 19:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbXE2Xot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 19:44:49 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:58581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750937AbXE2Xot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 19:44:49 -0400
Date: Tue, 29 May 2007 16:44:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: How to use GDB to decode OOPSes
Message-Id: <20070529164442.0f272b74.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705281046001.30697@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0705281046001.30697@sbz-30.cs.Helsinki.FI>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 10:46:18 +0300 (EEST)
Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> +In addition, you can use GDB to figure out the exact file and line
> +number of the OOPS from the vmlinux file. If you have
> +CONFIG_DEBUG_INFO enabled, you can simply copy the EIP value from the
> +OOPS:
> +
> + EIP:    0060:[<c021e50e>]    Not tainted VLI
> +
> +And use GDB to translate that to human-readable form:
> +
> +  gdb vmlinux
> +  (gdb) l *0xc021e50e
> +
> +If you don't have CONFIG_DEBUG_INFO enabled, you use the function
> +offset from the OOPS:
> +
> + EIP is at vt_ioctl+0xda8/0x1482
> +
> +And recompile the kernel with CONFIG_DEBUG_INFO enabled:
> +
> +  make vmlinux
> +  gdb vmlinux
> +  (gdb) p vt_ioctl
> +  (gdb) l *(0x<address of vt_ioctl> + 0xda8)
> +

yeah.  Often this process will tell you that the oops was in
spin_lock_irq() or list_add() or something useless like that.

So the next step is to start adding and subtracting 4, 8, 12, ...
to the EIP value until you "fall out" of the inlined function and 
back into the callee.

But I'm not sure that I'd want to have to describe that process
(especially the means by which one determines that it is necessary)
to normal people ;)
