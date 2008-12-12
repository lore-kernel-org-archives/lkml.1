Return-Path: <linux-kernel-owner+w=401wt.eu-S1759448AbYLLSsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759448AbYLLSsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 13:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758148AbYLLSs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 13:48:26 -0500
Received: from sh.osrg.net ([192.16.179.4]:49019 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbYLLSsZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 13:48:25 -0500
Date: Sat, 13 Dec 2008 03:48:08 +0900 (JST)
Message-Id: <20081213.034808.104867584.ryusuke@osrg.net>
To: andi@firstfloor.org
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm 1/5] nilfs2: fix problems of memory allocation in
 ioctl
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <871vwdcxo1.fsf@basil.nowhere.org>
References: <1229059021-9538-1-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<1229059021-9538-2-git-send-email-konishi.ryusuke@lab.ntt.co.jp>
	<871vwdcxo1.fsf@basil.nowhere.org>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
On Fri, 12 Dec 2008 14:47:58 +0100, Andi Kleen <andi@firstfloor.org> wrote:
> Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp> writes:
> 
> > The current memory copy function of nilfs2 ioctl has following
> > problems:
> 
> Wouldn't it be easier/faster/more reliable to just use vmalloc for
> those allocations?  The only reason to use kmalloc for such large
> allocations would be if you want to do direct DMA (but even there are
> ways to do this using virtual allocations and scatter-gather)
> 
> -Andi

Thanks. Using vmalloc seems worthy of consideration.
I'll try to rewrite and test it to confirm whether it can make the
code simpler and robust enough.

By the way, is there any recommended way to exchange such a large
amount of data items between user space and kernel space?

In the current interface, each data item is copied twice: one is to
the allocated memory from user space (via copy_from_user), and another
is to on-memory structures or to buffers/pages from the allocated
memory.

This looks somehow inefficient.

Regards,
Ryusuke
