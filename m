Return-Path: <linux-kernel-owner+w=401wt.eu-S1763668AbXFEJac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763668AbXFEJac (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 05:30:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759618AbXFEJaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 05:30:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:43888 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763326AbXFEJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 05:30:18 -0400
Date: Tue, 5 Jun 2007 10:30:17 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Steve French <smfrench@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] support larger cifs network reads
Message-ID: <20070605093017.GA30288@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Steve French <smfrench@gmail.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cifs-client@lists.samba.org
References: <524f69650705311608l5433dedj4ec4f903e9af3ce4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650705311608l5433dedj4ec4f903e9af3ce4@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 06:08:23PM -0500, Steve French wrote:
> With Samba 3.0.26pre it is now possible for a cifs client (one which
> supports the newest Unix/Posix cifs extensions) to request up to
> almost 8MB at a time on a cifs read request.
> 
> A patch for the cifs client to support larger reads follows.  In this
> patch, using very large reads is not the default behavior, since it
> would require larger buffer allocations for the large cifs request
> buffers, but in the future when cifs can demultiplex reads to a page
> list in the cifs_demultiplex_thread (without having to copy to a large
> temporary buffer) this will be even more useful.

Increasing this now doesn't make any sense - slab won't be able to
create a 8MB cache on most architectures, and even if it could the
wasted memory would be enormous.  Once you actually support
scatter/gather allocations an increase is fine.

