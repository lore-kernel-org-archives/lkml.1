Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756667Ab0CKKAG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 05:00:06 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:50110 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756497Ab0CKJ7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:59:55 -0500
Date: Thu, 11 Mar 2010 10:59:44 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Shinya Kuribayashi <shinya.kuribayashi@necel.com>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Greg KH <gregkh@suse.de>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] Loongson-2F: Flush the branch target history such as
 BTB and RAS
Message-ID: <20100311095944.GC18065@linux-mips.org>
References: <cover.1268153722.git.wuzhangjin@gmail.com>
 <d513f16856e499e82f0b4e428c97fe06afb5a426.1268153722.git.wuzhangjin@gmail.com>
 <4B98632E.70806@necel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B98632E.70806@necel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 12:27:42PM +0900, Shinya Kuribayashi wrote:

> Are you sure that RAS represents "Row Address Strobe", not "Return
> Address Stack?"
> 
> By the way, we have a similar local workaround for vr55xx processors
> when switching from kernel mode to user mode.  It's not necessarily
> related to out-of-order issues, but we need to prevent the processor
> from doing instruction prefetch beyond "eret" instruction.

Some R4000 revisions may do silly things in case of an NMI where c0_errorepc
is pointing is pointing to an ERET instruction.

There are various processors which want to save and restore core-specific
registers, for example the Cavium cnMIPS core.

> In the long term, it would be appreciated that the kernel has a set
> of hooks when switching KUX-modes, so that each machine could have
> his own, processor-specific treatmens.

It seems that uasm is the tool of choice.

  Ralf
