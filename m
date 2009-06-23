Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbZFWNqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbZFWNqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 09:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753975AbZFWNql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 09:46:41 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbZFWNqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 09:46:40 -0400
Date: Tue, 23 Jun 2009 09:46:40 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, adilger@sun.com,
       dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Message-ID: <20090623134640.GA13831@infradead.org>
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 18, 2009 at 08:55:37AM +0200, Miklos Szeredi wrote:
> Implement a new open flag that doesn't require any access on the file.
> It works on any file type including symlinks.
> 
> The sole purpose is to help race free "userspace lookup" type
> operations.  So fstat, fch*, *at work but nothing else.  Filesystem's
> ->open() is not called and f_op is set to NULL.

we guarantee that f_op is never NULL, so you'll need to assign a
file operations structure that is empty to it to avoid crashed in
various places.

> It would be logical to reuse the open_flag=3 value, but that has
> historically been used with different semantics so I'm afraid of
> touching it.

I think the historical semantics are exactly that you can open it
an issue ioctls + stat / etc on it ut not actually read/write it.

