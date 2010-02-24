Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab0BXNrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 08:47:48 -0500
Received: from www.tglx.de ([62.245.132.106]:57739 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757048Ab0BXNrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 08:47:47 -0500
Date: Wed, 24 Feb 2010 14:47:32 +0100
From: "Hans J. Koch" <hjk@linutronix.de>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg KH <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Subject: Re: UIO support for >32-bit physical addresses on 32-bit platforms
Message-ID: <20100224134732.GB1931@local>
References: <A596AEB5-BAF0-4BF9-A9C0-44C50B9BCA34@kernel.crashing.org>
 <20100223150140.GA3781@suse.de>
 <20100223194946.GA1941@local>
 <100F3ED0-597E-4F4F-83CC-CC8505E3563F@kernel.crashing.org>
 <20100223233938.GA2938@local>
 <554C9C89-9D0A-4307-AC4D-CD67F41A53B7@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <554C9C89-9D0A-4307-AC4D-CD67F41A53B7@kernel.crashing.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 23, 2010 at 09:24:42PM -0600, Kumar Gala wrote:
> > Well, UIO is (up to now) completely independent of the architecture. If you've
> > got a good idea how to implement such mappings, feel free to come up with your
> > suggestions/patches. Just changing struct uio_mem.addr to u64 is certainly not
> > enough.
> > 
> > I'll give it some thoughts myself, and will discuss the problem with friends,
> > maybe there's a nice solution. Help from your side is much appreciated.
> 
> For my needs I believe changing uio_mem.addr to a u64 is sufficient for getting UIO_MEM_PHYS to work for the physical address being above 4G.  I need the type to be large to represent a wider PFN range.  Obviously there are limitations (ie, we can't make an IO region >4G in size, etc.)
> 

Hmm, after some research it seems you're right. But the type for the addr
member of struct uio_mem should be phys_addr_t, not u64. phys_addr_t is
an u64 on systems that support it, and an u32 otherwise.

It'll probably work with UIO_MEM_LOGICAL and UIO_MEM_VIRTUAL as well.

Could you hack up a patch to that effect, and test it? If it works for you,
I think we should apply it.

Thanks for pointing this out.

Hans

> - k
