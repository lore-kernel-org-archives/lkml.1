Return-Path: <linux-kernel-owner+w=401wt.eu-S1761072AbZDXRvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761072AbZDXRvN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 13:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758250AbZDXRuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 13:50:52 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53468 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753467AbZDXRuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 13:50:51 -0400
Date: Fri, 24 Apr 2009 13:50:25 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Fr?d?ric Weisbecker <fweisbec@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Alessio Igor Bogani <abogani@texware.it>,
       Jonathan Corbet <corbet@lwn.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>,
       LFSDEV <linux-fsdevel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/1] vfs: umount_begin BKL pushdown v2
Message-ID: <20090424175025.GA30091@infradead.org>
References: <20090423191934.GW1926@parisc-linux.org> <1240556813-8739-1-git-send-email-abogani@texware.it> <1240556813-8739-2-git-send-email-abogani@texware.it> <20090424071312.GE8633@ZenIV.linux.org.uk> <20090424071853.GG8633@ZenIV.linux.org.uk> <20090424080634.GG24912@elte.hu> <20090424085017.GB28592@infradead.org> <c62985530904240216j2760e3dbvca5b8e9da22d009f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c62985530904240216j2760e3dbvca5b8e9da22d009f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 11:16:18AM +0200, Fr?d?ric Weisbecker wrote:
> I disagree with you. The kill-the-BKL tree does not only aggregate patches
> to turn the BKL into more traditional locks. The Bkl has been
> converted to a common mutex in
> this tree, making it losing its common horrid properties:
> 
> - release/reacquire on schedule
> - not preemptable
> - can be reacquired recursively by a same task
> 
> Such a basis is very useful because we can easily find these places
> which won't support a usual lock conversion without reworking the
> locking scheme.
> This is a necessary preliminary for the Bkl removal.
> All the places which have been designed very tightly with Bkl
> properties are rapidly detected
> with lockdep in this tree and reworked, still using lockdep, code
> reviewing and the help of
> this Bkl-to-mutex conversion.
> 
> The work done with this tree can be merged inside and also on the
> matching subsytem tree for
> each patchset. That's a very sane workflow IMHO.

Having a working tree for debugging stuff is fine, but the point is
that it should never be pulled into mainline and probably frequently
reabsed to avoid cruft.  In that case there's really no point in
creating branches to share pieces of tree history, just apply the patch
locally if you think you want it and merge or rebase once mainline gets
the patch.

Al frequently rebases the vfs tree, btw - so even if it was a separate
branch now there's a fair chance it would end up in mainline with a
different commit id.
