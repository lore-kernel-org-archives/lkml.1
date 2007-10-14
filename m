Return-Path: <linux-kernel-owner+w=401wt.eu-S1763771AbXJNSkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763771AbXJNSkA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 14:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbXJNSjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 14:39:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:48628 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759385AbXJNSjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 14:39:51 -0400
Date: Sun, 14 Oct 2007 11:39:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1
Message-Id: <20071014113914.7654759d.akpm@linux-foundation.org>
In-Reply-To: <64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<4710A407.3070000@garzik.org>
	<64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>
	<4710B7C5.5050403@garzik.org>
	<64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>
	<64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com>
	<64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
	<47110500.8050503@garzik.org>
	<64bb37e0710131105m7c64fca0kb71f3955170e8bec@mail.gmail.com>
	<20071013111853.7e67c6c3.akpm@linux-foundation.org>
	<64bb37e0710140454s61325fdfya43179b14ea26dc4@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2007 13:54:26 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:

> > The page-owner code can pinpoint a leak source.  See
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/broken-out/page-owner-tracking-leak-detector.patch
> >
> > Enable CONFIG_DEBUG_SLAB_LEAK, check out /proc/slab_allocators
> 
> Did that. The output of /proc/page_owner is ~350Mb, gzipped still ~7Mb.
> 
> Taking only the first line from each stackdump it shows the following counts:
>
> ...
>
>  354042 [0xffffffff80266373] mempool_alloc+83

This one is suspicious.  Can you find the whole record for it?

The other info shows a tremendous memory leak, not via slab.  Looks like
someone is running alloc_pages() directly and isnb't giving them back.

