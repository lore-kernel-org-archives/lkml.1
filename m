Return-Path: <linux-kernel-owner+w=401wt.eu-S1763435AbZDBQhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763435AbZDBQhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 12:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbZDBQhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 12:37:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33536 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755012AbZDBQhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 12:37:22 -0400
Date: Thu, 2 Apr 2009 12:37:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Howells <dhowells@redhat.com>, hch@infradead.org,
       viro@zeniv.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 22/43] CacheFiles: Add a hook to write a single page of
	data to an inode [ver #46]
Message-ID: <20090402163712.GA25177@infradead.org>
References: <200904030100.05741.nickpiggin@yahoo.com.au> <20090401230515.28177.73948.stgit@warthog.procyon.org.uk> <5564.1238684153@redhat.com> <200904030232.59355.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200904030232.59355.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 03, 2009 at 02:32:58AM +1100, Nick Piggin wrote:
> Hmm, I guess not all filesystems define write_begin/write_end. But if you
> only need to use ones that do define them?

No.  write_begin/write_end are simply callbacks for the write helpers,
and locking for them is entirely filesystem-defined.  E.g. xfs and the
cluster filesystems require additional locks taken first, and some
network filesystems require inode revalidations first.

They really should be taken out of the address_space_operations and
passed as callbacks to generic_file_aio_write & co.

