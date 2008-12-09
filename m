Return-Path: <linux-kernel-owner+w=401wt.eu-S1753386AbYLIJwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386AbYLIJwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 04:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbYLIJwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 04:52:25 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYLIJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 04:52:24 -0500
Date: Tue, 9 Dec 2008 04:52:10 -0500
From: Christoph Hellwig <hch@infradead.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, hugh@veritas.com,
       hch@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] EXPORTFS: Don't return NULL from
	fh_to_dentry()/fh_to_parent() [ver #4]
Message-ID: <20081209095209.GA8599@infradead.org>
References: <20081205162318.20732.73054.stgit@warthog.procyon.org.uk> <alpine.LFD.2.00.0812050848060.3386@nehalem.linux-foundation.org> <20081205174228.GC29227@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081205174228.GC29227@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 12:42:28PM -0500, J. Bruce Fields wrote:
> Not of fh_to_dentry(), but it looks like fh_to_parent() is the same.  So
> you'd want the below.
> 
> This is partially reverting 440037287c5, which appears to have also do
> some changing of NULLs to ESTALEs which we might also want to reconsider
> at some point.  Maybe Christoph could explain what the rationale was.

Miklos suggested always returning ERR_PTR values instead of a a min
or NULLs and ERR_PTR values to make the interface cleaner.  I tend
to agree, but botched up the conversion.

