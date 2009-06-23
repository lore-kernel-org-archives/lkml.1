Return-Path: <linux-kernel-owner+w=401wt.eu-S1758212AbZFWOeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758212AbZFWOeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756456AbZFWOeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:34:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58194 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbZFWOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:34:05 -0400
Date: Tue, 23 Jun 2009 10:34:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       viro@ZenIV.linux.org.uk, adilger@sun.com, dhowells@redhat.com,
       alan@lxorguk.ukuu.org.uk, akpm@linux-foundation.org
Subject: Re: [RFC] O_NOACC: open without any access
Message-ID: <20090623143408.GA2147@infradead.org>
References: <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 04:12:22PM +0200, Miklos Szeredi wrote:
> > an issue ioctls + stat / etc on it ut not actually read/write it.
> 
> Two differences between open("foo", 3) and open("foo", O_NOACC):
> 
>   1) open with "3" requires _read_and_write_ permissions on foo, but
>      does not allow either read or write.  Not sure what the logic in
>      that, but that's the way it has always been.

Which is a quite sensible requirement if we want to do ioctls.

> 
>   2) open with "3" calls driver's ->open() with any side effect that
>      may have.  Open with O_NOACC doesn't do that, and hence if we
>      want to allow ioctls they need a new interface which gets a
>      "struct path" instead of a "struct file".

Well, we'll need ->open to support ioctls, and I think it's good to go
down that road.

