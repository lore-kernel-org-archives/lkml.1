Return-Path: <linux-kernel-owner+w=401wt.eu-S1755709AbYF2HP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709AbYF2HP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 03:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751642AbYF2HPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 03:15:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395AbYF2HPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 03:15:44 -0400
Date: Sun, 29 Jun 2008 03:15:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, Andrew Morton <akpm@linux-foundation.org>,
       mhalcrow@us.ibm.com, hooanon05@yahoo.co.jp, hch@infradead.org,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fsstack: fsstack_copy_inode_size locking
Message-ID: <20080629071528.GA31114@infradead.org>
References: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806290101160.20280@blonde.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 01:05:09AM +0100, Hugh Dickins wrote:
> LTP's iogen01 doio tests used to hang nicely on 32-bit SMP when /tmp was a
> unionfs mount of a tmpfs, i_size_read spinning forever, waiting for a lost
> seqcount update: fixed by taking i_lock around i_size_write when 32-bit SMP.
> 
> But akpm was dissatisfied with the resulting patch: its lack of commentary,
> the #ifs, the nesting around i_size_read, the lack of attention to i_blocks.
> I promised to redo it with the general spin_lock_32bit() he proposed; but 
> disliked the result, partly because "32bit" obscures the real constraints,
> which are best commented within fsstack_copy_inode_size itself.
> 
> This version adds those comments, and uses sizeof comparisons which the
> compiler can optimize out, instead of CONFIG_SMP, CONFIG_LSF. BITS_PER_LONG.

Btw, I hope fsstack doesn't rely on i_size having any particular
meaning.  As far as the VFS is concerned i_size is field only used by
the filesystem (or library routines like generic_file_*).

