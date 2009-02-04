Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbZBDXx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbZBDXx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:53:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbZBDXxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:53:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754510AbZBDXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:53:47 -0500
Date: Wed, 4 Feb 2009 15:53:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Larry Keegan <lk@pfw.demon.co.uk>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 'vmap allocation failed' with 2 graphics cards and kernel
 2.6.28
Message-Id: <20090204155308.6efa5dc8.akpm@linux-foundation.org>
In-Reply-To: <20090204194923.30bab978@cs2.al.itld>
References: <20090204194923.30bab978@cs2.al.itld>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 19:49:23 +0000
Larry Keegan <lk@pfw.demon.co.uk> wrote:

> Dear Chaps,
> 
> I'm experiencing a problem on a Gigabyte GA-G31M-S2L. The problem did
> not occur on kernel 2.6.25, but does on 2.6.28 and 2.6.28.2. I am using
> virgin kernels.
> 
> During boot I swapon <logical_volume>. This worked fine until 2.6.28
> came along. Now, the kernel boots fine, but when I run swapon the
> following error message is displayed:
> 
> vmap allocation failed: use vmalloc=<size> to increase size.

Nick, we should add a dump_stack() there too.

> The error seems to be directly related to the second graphics card
> installed in this machine. Here are the details of the on-board
> graphics chip:
> 
> 00:02.0 VGA compatible controller: Intel Corporation 82G33/G31 Express
> Integrated Graphics Controller (rev 10) (prog-if 00 [VGA controller])
> Subsystem: Giga-byte Technology Device d000 Flags: bus master, fast
> devsel, latency 0, IRQ 2300 Memory at e6200000 (32-bit,
> non-prefetchable) [size=512K] I/O ports at e400 [size=8]
>         Memory at d0000000 (32-bit, prefetchable) [size=256M]
>         Memory at e6100000 (32-bit, non-prefetchable) [size=1M]
>         Capabilities: [90] MSI: Mask- 64bit- Count=1/1 Enable+
>         Capabilities: [d0] Power Management version 2
> 
> and here are the details of the graphics card I added:
> 
> 01:00.0 VGA compatible controller: nVidia Corporation G72 [GeForce 7300
> SE] (rev a1) (prog-if 00 [VGA controller]) Flags: fast devsel, IRQ 16
>         Memory at e0000000 (32-bit, non-prefetchable) [size=16M]
>         Memory at c0000000 (64-bit, prefetchable) [size=256M]
>         Memory at e1000000 (64-bit, non-prefetchable) [size=16M]
>         [virtual] Expansion ROM at e2000000 [disabled] [size=128K]
>         Capabilities: [60] Power Management version 2
>         Capabilities: [68] MSI: Mask- 64bit+ Count=1/1 Enable-
>         Capabilities: [78] Express Endpoint, MSI 00
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [128] Power Budgeting <?>
> 
> When I set the BIOS to initialise the nVidia PCI-Express graphics card
> first I see the vmap error. When I set the BIOS to initialise the
> on-board Intel graphics card first I do not.
> 
> I have upgraded to the latest (F9) BIOS revision, but to no avail. Has
> anyone else come across this before?

This is the first report I've seen.

Unfortunately pre-2.6.28 kernels didn't have /proc/vmallocinfo.

Please send the contents of /proc/vmallocinfo.  Try to avoid
wordwrapping it.

Did we intend to make /proc/vmallocinfo root-only?

Please gather the contents of /proc/iomem for 2.6.25 and for 2.6.28,
perhaps we can work something out from that.

Thanks.
