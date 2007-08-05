Return-Path: <linux-kernel-owner+w=401wt.eu-S1759421AbXHEUlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421AbXHEUlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759732AbXHEUlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:41:23 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52470 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759493AbXHEUlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:41:22 -0400
Date: Sun, 5 Aug 2007 21:41:12 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
       tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805204112.GC25107@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, miklos@szeredi.hu,
	akpm@linux-foundation.org, neilb@suse.de, dgc@sgi.com,
	tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804163733.GA31001@elte.hu> <p73hcnen7w2.fsf@bingen.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <p73hcnen7w2.fsf@bingen.suse.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 02:26:53AM +0200, Andi Kleen wrote:
> I always thought the right solution would be to just sync atime only
> very very lazily. This means if a inode is only dirty because of an
> atime update put it on a "only write out when there is nothing to do
> or the memory is really needed" list.

Which is the policy I implemented for XFS a while ago.

