Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbXE3RjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbXE3RjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 13:39:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbXE3RjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 13:39:09 -0400
Received: from pat.uio.no ([129.240.10.15]:41871 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064AbXE3RjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 13:39:08 -0400
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write
	from the pagecache
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <10564.1180521323@redhat.com>
References: <1180050860.8872.42.camel@heimdal.trondhjem.org>
	 <1180046115.8872.27.camel@heimdal.trondhjem.org>
	 <20070524133821.3ee9c9f3.akpm@linux-foundation.org>
	 <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
	 <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
	 <27608.1180042522@redhat.com> <29320.1180048725@redhat.com>
	 <10564.1180521323@redhat.com>
Content-Type: text/plain
Date: Wed, 30 May 2007 13:39:00 -0400
Message-Id: <1180546740.6770.15.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.115)
X-UiO-Scanned: 0C33D4DD21572F1728E8EB7D6634B92A4F0B6C9D
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 636 total 2051363 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-30 at 11:35 +0100, David Howells wrote:
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> > All I do is to protect new calls to read() and write() with a call to
> > check if the page cache needs invalidating.
> 
> What about mmap()?  What if someone gets a mapping on a section of file that
> subsequently has a write rejected on it?  If you invalidate only on
> read()/write(), what do you do about such a mapping?

Same philosophy: The people who already have the file mapped will
already be working with corrupted data, so there is little point in
bending over backwards to "fix" the problem. Instead we flush out the
page cache using invalidate_inode_pages2() whenever someone tries to
mmap() a new section of the file.

Trond

