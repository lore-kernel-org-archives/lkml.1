Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZJ1MMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZJ1MMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 08:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbZJ1MMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 08:12:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:35295 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807AbZJ1MMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 08:12:49 -0400
Message-ID: <4AE83541.3030306@kernel.org>
Date: Wed, 28 Oct 2009 13:12:49 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org, chrisw@sous-sol.org, dwmw2@infradead.org,
       joerg.roedel@amd.com, Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 07/10] bootmem: add free_bootmem_late
References: <1256712464-21472-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <1256712464-21472-8-git-send-email-fujita.tomonori@lab.ntt.co.jp>	 <20091028074832.GC19402@elte.hu> <4AE7FA12.2070905@kernel.org> <84144f020910280438j65bcacacq731f6076cbd8d99@mail.gmail.com>
In-Reply-To: <84144f020910280438j65bcacacq731f6076cbd8d99@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Pekka Enberg wrote:
> On Wed, Oct 28, 2009 at 10:00 AM, Tejun Heo <tj@kernel.org> wrote:
>> ISTR an attempt to initialize the kmalloc allocator much earlier
>> during boot such that it can completely replace the bootmem allocator,
>> which would nicely remove all the complications although it may
>> require the kmalloc allocator to go through more complex boot
>> strapping steps.  I didn't follow how that went.  Did it prove to be
>> unworkable?
> 
> We're doing it before scheduler init now but I haven't put any effort
> into moving it earlier than that yet. I don't see any fundamental
> reason we can't do that but the practical problem is that we're going
> to affect architecture specific boot code which is really hard to
> test.

Thanks for the explanation.  It would be really great if we can pull
that off someday.  This should be doable architecture-by-architecture,
right?  You can, for example, first convert x86 and then make bootmem
allocator thin wrapper around the slab allocator.  After all archs
have been converted, the wrappers can be dropped.

-- 
tejun
