Return-Path: <linux-kernel-owner+w=401wt.eu-S1752916AbXFNWEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916AbXFNWEb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751059AbXFNWEY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:04:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56062 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbXFNWEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:04:23 -0400
Date: Thu, 14 Jun 2007 15:04:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org
Subject: Re: [patch 00/14] Page cache cleanup in anticipation of Large
 Blocksize support
Message-Id: <20070614150417.c73fb6b9.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
References: <20070614193839.878721298@sgi.com>
	<20070614130645.cabdff1b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141411180.1579@schroedinger.engr.sgi.com>
	<20070614143248.736312f8.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0706141436030.1797@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 14 Jun 2007 14:37:33 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
> On Thu, 14 Jun 2007, Andrew Morton wrote:
> 
> > We want the 100% case.
> 
> Yes that is what we intend to do. Universal support for larger blocksize. 
> I.e. your desktop filesystem will use 64k page size and server platforms 
> likely much larger.

With 64k pagesize the amount of memory required to hold a kernel tree (say)
will go from 270MB to 1400MB.   This is not an optimisation.

Several 64k pagesize people have already spent time looking at various
tail-packing schemes to get around this serious problem.  And that's on
_server_ class machines.  Large ones.  I don't think
laptop/desktop/samll-server machines would want to go anywhere near this.

> fsck times etc etc are becoming an issue for desktop 
> systems

I don't see what fsck has to do with it.

fsck is single-threaded (hence no locking issues) and operates against the
blockdev pagecache and does a _lot_ of small reads (indirect blocks,
especially).  If the memory consumption for each 4k read jumps to 64k, fsck
is likely to slow down due to performing a lot more additional IO and due
to entering page reclaim much earlier.

