Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbZAUATY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbZAUATY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:19:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbZAUATM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:19:12 -0500
Received: from w241.dkm.cz ([62.24.88.241]:43529 "EHLO machine.or.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757426AbZAUATL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:19:11 -0500
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jan 2009 19:19:11 EST
Date: Wed, 21 Jan 2009 01:11:31 +0100
From: Petr Baudis <pasky@suse.cz>
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: Ulrich Drepper <drepper@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       linux-api@vger.kernel.org, aarcange@redhat.com
Subject: Re: [PATCH v6 0/5] Add preadv & pwritev system calls.
Message-ID: <20090121001131.GF21648@machine.or.cz>
References: <1232124344-25892-1-git-send-email-kraxel@redhat.com> <200901161852.04953.arnd@arndb.de> <4970DDF9.4090007@redhat.com> <49748C1B.8090205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49748C1B.8090205@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2009 at 03:20:11PM +0100, Gerd Hoffmann wrote:
> I do see the point in adding a interface like this ...
> 
> >    ssize_t readz (int fd, void *buf, size_t len, void **res)
> 
> ... to help the kernel do zero-copy I/O.
> 
> I think system calls for vector I/O are *not* the right place for that
> though.  Usually applications use vectored I/O because they *do* care
> about the place the data is stored, because vectored I/O allows them to
> avoid copying data within the application.

Can you elaborate on this? An application would have to have quite a
contrived design if its pointers simply cannot be updated according
to what the kernel returns.

Then again, I'm not sure why wouldn't readv() actually be
zerocopy-ready. Just make sure you handle iov_base being NULL gracefully
now (EINVAL, with the remark that the kernel can write to the iovec
memory area in the future) and later the kernel can in that case set
iov_base to the buffer location?

-- 
				Petr "Pasky" Baudis
The average, healthy, well-adjusted adult gets up at seven-thirty
in the morning feeling just terrible. -- Jean Kerr
