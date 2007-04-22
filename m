Return-Path: <linux-kernel-owner+w=401wt.eu-S965574AbXDVJKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965574AbXDVJKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 05:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965570AbXDVJKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 05:10:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37607 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965550AbXDVJKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 05:10:37 -0400
Date: Sun, 22 Apr 2007 10:10:33 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andreas Gruenbacher <agruen@suse.de>
Cc: Ulrich Drepper <drepper@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [d_path 0/7] Fixes to d_path: Respin
Message-ID: <20070422091033.GA1558@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andreas Gruenbacher <agruen@suse.de>,
	Ulrich Drepper <drepper@gmail.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <20070412090809.917795000@suse.de> <200704201840.07247.agruen@suse.de> <a36005b50704201217l649195f0q204c2434445e7160@mail.gmail.com> <200704212104.06349.agruen@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704212104.06349.agruen@suse.de>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 21, 2007 at 09:04:06PM +0200, Andreas Gruenbacher wrote:
> > It is unspecified whether all members of the statvfs structure have
> > meaningful values on all file systems.
> 
> In my opinion, the advantage of not reporting bogus pathnames in /proc/mounts 
> by far outweighs the problems is sometimes causes for fstatvfs(). Anyone 
> relying on the information obtained from statvfs / fstatvfs is making false 
> assumptions anyway, and in "normal setups" as you called them, nothing 
> changes for fstatvfs and statvfs.

So what about stopping the flaming here and implementing real statvfs/
fstatvfs syscalls instead of these horrible hacks glibc has to do currently?
Using our kstatfs infrastructure that should be dirt simple.
arch/sparc64/solaris/fs.c already has a template of a statvfs syscall for
solaris, although we could probably improve a little on that.

