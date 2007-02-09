Return-Path: <linux-kernel-owner+w=401wt.eu-S1946296AbXBIKKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946296AbXBIKKg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 05:10:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946265AbXBIKKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 05:10:31 -0500
Received: from smtp.osdl.org ([65.172.181.24]:40985 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946294AbXBIKJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 05:09:59 -0500
Date: Fri, 9 Feb 2007 02:09:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc][patch 0/3] a faster buffered write deadlock fix?
Message-Id: <20070209020954.4951256e.akpm@linux-foundation.org>
In-Reply-To: <20070209095405.GA14398@wotan.suse.de>
References: <20070208105437.26443.35653.sendpatchset@linux.site>
	<20070209004101.3e4a88fc.akpm@linux-foundation.org>
	<20070209095405.GA14398@wotan.suse.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Feb 2007 10:54:05 +0100 Nick Piggin <npiggin@suse.de> wrote:

> On Fri, Feb 09, 2007 at 12:41:01AM -0800, Andrew Morton wrote:
> > On Thu,  8 Feb 2007 14:07:15 +0100 (CET) Nick Piggin <npiggin@suse.de> wrote:
> > 
> > > So I have finally finished a first slightly-working draft of my new aops
> > > op (perform_write) proposal. I would be interested to hear comments about
> > > it.  Most of my issues and concerns are in the patch headers themselves,
> > > so reply to them.
> > > 
> > > The patches are against my latest buffered-write-fix patchset.
> > 
> > What happened with Linus's proposal to instantiate the page as pinned,
> > non-uptodate, unlocked and in pagecache while we poke the user address?
> 
> That's still got a deadlock,

It does?

>  and also it doesn't work if we want to lock
> the page when performing a minor fault (which I want to fix fault vs
> invalidate),

It's hard to discuss this without a description of what you want to fix
there, and a description of how you plan to fix it.

> and also assumes nobody's ->nopage locks the page or
> requires any resources that are held by prepare_write (something not
> immediately clear to me with the cluster filesystems, at least).

The nopage handler is filemap_nopage().  Are there any exceptions to that?

> But that all becomes legacy path, so do we really care? Supposing fs
> maintainers like perform_write, then after the main ones have implementations
> we could switch over to the slow-but-correct prepare_write legacy path.
> Or we could leave it, or we could use Linus's slightly-less-buggy scheme...
> by that point I expect I'd be sick of arguing about it ;)

It's worth "arguing" about.  This is write().  What matters more??
