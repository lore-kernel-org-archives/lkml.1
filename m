Return-Path: <linux-kernel-owner+w=401wt.eu-S1754352AbYHKBaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbYHKBaj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 21:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYHKBab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 21:30:31 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45211 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbYHKBab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 21:30:31 -0400
Date: Sun, 10 Aug 2008 21:30:24 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Keith Packard <keithp@keithp.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
Message-ID: <20080811013024.GA28884@infradead.org>
References: <1217573919-7496-1-git-send-email-eric@anholt.net> <200808041902.23970.nickpiggin@yahoo.com.au> <1217845590.24714.45.camel@koto.keithp.com> <200808042043.46710.nickpiggin@yahoo.com.au> <1217850352.24714.66.camel@koto.keithp.com> <Pine.LNX.4.64.0808041720500.25617@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808041720500.25617@blonde.site>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 06:09:24PM +0100, Hugh Dickins wrote:
> Whether such usage conforms to VFS API I'm not so sure: as I understand
> it, it's really for internal use by a filesystem - if it's going to be
> used beyond that, we ought to add a check that the filesystem it's used
> upon really has a ->readpage method (and I'd rather we add such a check
> than you do it at your end, in case we change the implementation later
> to use something other than a ->readpage method - Nick, you'll be
> nauseated to hear I was looking to see if ->fault with a pseudo-vma
> could do it).  But if the layering police are happy with this, I am.

Using read_mapping_page is fine on any pagecache backed file.  What is
much more difficult is actually writing into pagecache on a sub-page
level where we don't have proper APIs for anything but the filesystem
itself.

