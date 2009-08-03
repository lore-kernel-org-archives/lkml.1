Return-Path: <linux-kernel-owner+w=401wt.eu-S1753752AbZHCS1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbZHCS1G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 14:27:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbZHCS1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 14:27:06 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33721 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbZHCS1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 14:27:04 -0400
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC 0/2] new kfifo API
From: Andi Kleen <andi@firstfloor.org>
References: <1249306755.8358.8.camel@wall-e>
Date: Mon, 03 Aug 2009 20:27:00 +0200
In-Reply-To: <1249306755.8358.8.camel@wall-e> (Stefani Seibold's message of "Mon, 03 Aug 2009 15:39:15 +0200")
Message-ID: <87skg8u51n.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefani Seibold <stefani@seibold.net> writes:
>   the buffer. No extra indirection is needed to access the fifo buffer.
> - Lockless access: if only one reader and one writer is active on the fifo,
>   which is the common use case, there is no additional locking necessary.

Would it also be NMI safe?  I've been looking at a new log buffer
for MCE/NMI. One option was the fifo in ftrace, but it seems
so big that it would blow up the machine check code considerably.

There was also an own new fifo that Ying Huang implemented,
but that one wasn't very popular.

This might be indeed an alternative. Requirement is NMI-safeness.

> The API:
> --------
>
> struct kfifo *kfifo_alloc(unsigned long size, gfp_t gfp_mask)
>  Dynamically allocates a new fifo and returns the address
>  @size: the size of the internal buffer to be allocated.
>  @gfp_mask: get_free_pages mask, passed to kmalloc()

For the MCE use case this would need to be able to optionally use
bootmem because the first initialization happens too early.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
