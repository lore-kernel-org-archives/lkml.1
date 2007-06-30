Return-Path: <linux-kernel-owner+w=401wt.eu-S1757894AbXF3KoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbXF3KoW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 06:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755508AbXF3KoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 06:44:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:44108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755473AbXF3KoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 06:44:11 -0400
Date: Sat, 30 Jun 2007 11:44:08 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070630104408.GD24123@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	Nick Piggin <npiggin@suse.de>, Jeff Garzik <jeff@garzik.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-fsdevel@vger.kernel.org
References: <20070624014528.GA17609@wotan.suse.de> <467DE00A.9080700@garzik.org> <20070624034755.GA3292@wotan.suse.de> <20070624135126.GA10077@think.oraclecorp.com> <467F67A8.3030408@yahoo.com.au> <20070625122521.GA12446@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625122521.GA12446@think.oraclecorp.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2007 at 08:25:21AM -0400, Chris Mason wrote:
> > write_begin/write_end is a step in that direction (and it helps
> > OCFS and GFS quite a bit). I think there is also not much reason
> > for writepage sites to require the page to lock the page and clear
> > the dirty bit themselves (which has seems ugly to me).
> 
> If we keep the page mapping information with the page all the time (ie
> writepage doesn't have to call get_block ever), it may be possible to
> avoid sending down a locked page.  But, I don't know the delayed
> allocation internals well enough to say for sure if that is true.

The point of delayed allocations is that the mapping information doesn't
even exist until writepage for new allocations :)
