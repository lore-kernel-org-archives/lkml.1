Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbZIARm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbZIARm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 13:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZIARm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 13:42:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35386 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbZIARmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 13:42:55 -0400
Date: Tue, 1 Sep 2009 13:42:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, reiserfs-devel@vger.kernel.org,
       jeffm@suse.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reiserfs: Truncate blocks not used by a write
Message-ID: <20090901174255.GA9051@infradead.org>
References: <20090901155554.GD8242@duck.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901155554.GD8242@duck.novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 05:55:54PM +0200, Jan Kara wrote:
> It can happen that write does not use all the blocks allocated in write_begin
> either because of some filesystem error (like ENOSPC) or because page with
> data to write has been removed from memory. We truncate these blocks so that
> we don't have dangling blocks beyond i_size. 

vmtruncate is in the process of going away for 2.6.32.  Please use a
filesystems-specific routine to just trim the blocks, similar to what
the vmtruncate call in the generic write_begin helper is beeing replaced
with in Nick's truncate patch series.

