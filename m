Return-Path: <linux-kernel-owner+w=401wt.eu-S1753611AbZFHKqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbZFHKqA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 06:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZFHKpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 06:45:50 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353AbZFHKpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 06:45:50 -0400
Date: Mon, 8 Jun 2009 06:45:44 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jan Kara <jack@suse.cz>,
       Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] writeback: skip new or to-be-freed inodes
Message-ID: <20090608104544.GA2428@infradead.org>
References: <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603141021.GB5738@localhost> <20090603141636.GC5650@duck.suse.cz> <20090603144711.GC5738@localhost> <20090606030725.GA12852@localhost> <4A2CB7AE.6080909@gmail.com> <20090608092930.GA13846@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090608092930.GA13846@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 05:29:30PM +0800, Wu Fengguang wrote:
> Thank you. Basically I'm not sure if UBIFS guarantees it won't be
> unmounted (hence the MS_ACTIVE bit is on) when calling
> generic_sync_sb_inodes() in shrink_liability() and ubifs_sync_fs().

Btw, the call in ubifs_sync_fs should be superflous in the
vfs-2.6#for-next tree.  We now do make sure that all inodes are flushed
before calling ->sync_fs with the wait parameter.

shrink_liability is a more interesting case, I don't understand enough
of ubifs to comment on it.
