Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbYLEJle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbYLEJle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 04:41:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbYLEJl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 04:41:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:47728 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638AbYLEJl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 04:41:26 -0500
Date: Fri, 5 Dec 2008 04:41:15 -0500
From: Christoph Hellwig <hch@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, bfields@fieldses.org,
       hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from
	fh_to_dentry()/fh_to_parent()
Message-ID: <20081205094115.GA27695@infradead.org>
References: <20081205091255.26127.91011.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205091255.26127.91011.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 09:12:56AM +0000, David Howells wrote:
> Returning NULL from fh_to_dentry() and fh_to_parent() is not permitted, so
> return -ESTALE instead.  exportfs_decode_fh() does not check for NULL, but
> will try to dereference it as IS_ERR() does not check for it.
> 
> The generic_fh_to_dentry() and generic_fh_to_parent() functions also no longer
> return NULL, but return -ESTALE instead.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Acked-by: J. Bruce Fields <bfields@citi.umich.edu>

Looks good, thanks.   Linus, this is regression introduced in 2.6.28 by
me, so please apply.

