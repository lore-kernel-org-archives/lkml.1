Return-Path: <linux-kernel-owner+w=401wt.eu-S1762880AbXHEUnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762880AbXHEUnc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 16:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761964AbXHEUnO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 16:43:14 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52504 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761004AbXHEUnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 16:43:13 -0400
Date: Sun, 5 Aug 2007 21:43:05 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       nikita@clusterfs.com, trond.myklebust@fys.uio.no,
       yingchao.zhou@gmail.com, richard@rsk.demon.co.uk
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070805204305.GD25107@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Florian Weimer <fw@deneb.enyo.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, miklos@szeredi.hu, neilb@suse.de,
	dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
	trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
	richard@rsk.demon.co.uk
References: <20070803123712.987126000@chello.nl> <alpine.LFD.0.999.0708031518440.8184@woody.linux-foundation.org> <20070804063217.GA25069@elte.hu> <20070804070737.GA940@elte.hu> <20070804103347.GA1956@elte.hu> <alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org> <20070804094119.81d8e533.akpm@linux-foundation.org> <87wswbjejw.fsf@mid.deneb.enyo.de> <20070804230007.30857453.akpm@linux-foundation.org> <87r6miza5t.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r6miza5t.fsf@mid.deneb.enyo.de>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 05, 2007 at 09:57:02AM +0200, Florian Weimer wrote:
> For instance, some editors don't perform fsync-then-rename, but simply
> truncate the file when saving (because they want to preserve hard
> links).  With XFS, this tends to cause null bytes on crashes.  Since
> ext3 has got a much larger install base, this would result in lots of
> bug reports, I fear.

XFS has recently been changed to only updated the on-disk i_size after
data writeback has finished to get rid of this irritation.

