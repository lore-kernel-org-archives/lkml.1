Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXHDXeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXHDXeA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 19:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756226AbXHDXdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 19:33:52 -0400
Received: from ns2.suse.de ([195.135.220.15]:37728 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222AbXHDXdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 19:33:51 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
References: <20070803123712.987126000@chello.nl>
	<alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org>
	<20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
From: Andi Kleen <andi@firstfloor.org>
Date: 05 Aug 2007 02:28:19 +0200
In-Reply-To: <20070804103347.GA1956@elte.hu>
Message-ID: <p73d4y2n7to.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > [ my personal interest in this is the following regression: every time 
> >   i start a large kernel build with DEBUG_INFO on a quad-core 4GB RAM 
> >   box, i get up to 30 seconds complete pauses in Vim (and most other 
> >   tasks), during plain editing of the source code. (which happens when 
> >   Vim tries to write() to its swap/undo-file.) ]
> 
> hm, it turns out that it's due to vim doing an occasional fsync not only 
> on writeout, but during normal use too. "set nofsync" in the .vimrc 
> solves this problem.

It should probably be doing fdatasync() instead. Then ext3 could just
write the data blocks only, but only mess with the logs when the file 
size changed and mtime would be written out somewhat later.

[unless you have data logging enabled]

Does the problem go away when you change it to that? 

-Andi

