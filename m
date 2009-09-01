Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbZIASK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbZIASK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 14:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754381AbZIASK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 14:10:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854AbZIASK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 14:10:26 -0400
Date: Tue, 1 Sep 2009 20:10:27 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       reiserfs-devel@vger.kernel.org, jeffm@suse.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] reiserfs: Truncate blocks not used by a write
Message-ID: <20090901181027.GF8242@duck.novell.com>
References: <20090901155554.GD8242@duck.novell.com> <20090901174255.GA9051@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090901174255.GA9051@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 01-09-09 13:42:56, Christoph Hellwig wrote:
> On Tue, Sep 01, 2009 at 05:55:54PM +0200, Jan Kara wrote:
> > It can happen that write does not use all the blocks allocated in write_begin
> > either because of some filesystem error (like ENOSPC) or because page with
> > data to write has been removed from memory. We truncate these blocks so that
> > we don't have dangling blocks beyond i_size. 
> 
> vmtruncate is in the process of going away for 2.6.32.  Please use a
> filesystems-specific routine to just trim the blocks, similar to what
> the vmtruncate call in the generic write_begin helper is beeing replaced
> with in Nick's truncate patch series.
  Reiserfs does not have such helper (yet), that's why I've used
vmtruncate. But OK, I'll try to convert reiserfs to the new truncate
sequence and then make this fix use it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
