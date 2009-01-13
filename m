Return-Path: <linux-kernel-owner+w=401wt.eu-S1760050AbZAMJ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050AbZAMJ1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 04:27:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbZAMJ1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 04:27:36 -0500
Received: from websrv.werbeagentur-aufwind.de ([88.198.253.206]:52370 "EHLO
	websrv.werbeagentur-aufwind.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755200AbZAMJ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 04:27:33 -0500
Subject: Re: [Xen-devel] Re: OOPS and panic on 2.6.29-rc1 on xen-x86
From: Christophe Saout <christophe@saout.de>
To: Bryan Donlan <bdonlan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       linux-mm@kvack.org, xen-devel@lists.xensource.com
In-Reply-To: <3e8340490901122054q4af2b4cm3303c361477defc0@mail.gmail.com>
References: <20090112172613.GA8746@shion.is.fushizen.net>
	 <3e8340490901122054q4af2b4cm3303c361477defc0@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 10:25:31 +0100
Message-Id: <1231838731.4823.2.camel@leto.intern.saout.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

> I've bisected the bug in question, and the faulty commit appears to be:
> commit e97a630eb0f5b8b380fd67504de6cedebb489003
> Author: Nick Piggin <npiggin@suse.de>
> Date:   Tue Jan 6 14:39:19 2009 -0800
> 
>     mm: vmalloc use mutex for purge
> 
>     The vmalloc purge lock can be a mutex so we can sleep while a purge is
>     going on (purge involves a global kernel TLB invalidate, so it can take
>     quite a while).
> 
>     Signed-off-by: Nick Piggin <npiggin@suse.de>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> The bug is easily reproducable by a kernel build on -j4 - it will
> generally OOPS and panic before the build completes.
> Also, I've tested it with ext3, and it still occurs, so it seems
> unrelated to btrfs at least :)

Nice!

Reverting this also fixes the BUG() I was seeing when testing the Dom0
patches on 2.6.29-rc1+tip.  It just ran stable for an hour compiling
gimp and playing music on my notebook (and then I had to leave).

Thanks,
	Christophe


