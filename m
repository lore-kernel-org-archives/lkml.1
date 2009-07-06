Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbZGFLlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbZGFLlX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 07:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbZGFLlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 07:41:16 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56367 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZGFLlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:41:16 -0400
To: tj@kernel.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org,
       fuse-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       npiggin@suse.de
In-reply-to: <4A4F3998.5020805@kernel.org> (message from Tejun Heo on Sat, 04
	Jul 2009 20:14:32 +0900)
Subject: Re: [PATCH 4/4] FUSE: implement direct mmap
References: <1245317073-24000-1-git-send-email-tj@kernel.org> <1245317073-24000-5-git-send-email-tj@kernel.org> <E1MJPmn-0001Q6-Fj@pomaz-ex.szeredi.hu> <4A48EEDC.807@kernel.org> <E1MMMgq-0002R2-FO@pomaz-ex.szeredi.hu> <4A4F3998.5020805@kernel.org>
Message-Id: <E1MNmZM-0001ZB-GR@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Jul 2009 13:41:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Jul 2009, Tejun Heo wrote:
> > Afaics sound drivers now map the dma memory with remap_pfn_range().
> > Similary we could allocate a chunk of non-swapabble kernel memory on
> > request from the userspace server and map its pages using this trick
> > to both the server's and the client's address space.
> > 
> > This is still sort of OSSP specific, I don't see clearly how it could
> > be made more generic.
> 
> Using non-swappable memory would be fine for most device emulations
> but mapping large amount of pages would be problematic.  Hmmm... this
> is difficult.  It's a compromise among flexibility, scalability and
> code complexity.

What's the difficulty?

Allocating pages, giving them an ID and mapping them into various page
tables seems simple in contrast to trying to make a tmpfs file be a
fuse file at the same time, which the VM is really not prepared for.

Thanks,
Miklos
