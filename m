Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXICNlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXICNlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 09:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbXICNk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 09:40:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48010 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXICNkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 09:40:55 -0400
Date: Mon, 3 Sep 2007 14:40:43 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mingming Cao <cmm@us.ibm.com>,
       linux-fsdevel@vger.kernel.org, adilger@clusterfs.com,
       sho@tnes.nec.co.jp, ext4 development <linux-ext4@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] JBD: slab management support for large block(>8k)
Message-ID: <20070903134043.GB28962@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Christoph Lameter <clameter@sgi.com>, Mingming Cao <cmm@us.ibm.com>,
	linux-fsdevel@vger.kernel.org, adilger@clusterfs.com,
	sho@tnes.nec.co.jp, ext4 development <linux-ext4@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <20070828190551.415127746@sgi.com> <20070828190735.292638294@sgi.com> <1188432669.3799.35.camel@localhost.localdomain> <1188434857.3799.76.camel@localhost.localdomain> <1188605538.3837.51.camel@localhost.localdomain> <20070901183922.GA12907@infradead.org> <Pine.LNX.4.64.0709020438490.28046@schroedinger.engr.sgi.com> <20070902152801.GA19962@infradead.org> <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709030051370.31366@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 12:55:04AM -0700, Christoph Lameter wrote:
> On Sun, 2 Sep 2007, Christoph Hellwig wrote:
> 
> > > We are doing what you describe right now. So the current code is broken?
> > Yes.
> 
> How about getting rid of the slabs there and use kmalloc? Kmalloc in mm 
> (and therfore hopefully 2.6.24) will convert kmallocs > PAGE_SIZE to page 
> allocator calls. Not sure what to do about the 1k and 2k requests though.

The problem is that we must never use kmalloc pages, so we always need
to request a page or more for these.  Better to use get_free_page directly,
that's how I fixed it in XFS a while ago.
