Return-Path: <linux-kernel-owner+w=401wt.eu-S965315AbXBFFxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965315AbXBFFxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 00:53:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965312AbXBFFxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 00:53:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50824 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965305AbXBFFxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 00:53:30 -0500
Date: Tue, 6 Feb 2007 06:53:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Filesystems <linux-fsdevel@vger.kernel.org>,
       Linux Memory Management <linux-mm@kvack.org>
Subject: Re: [patch 9/9] mm: fix pagecache write deadlocks
Message-ID: <20070206055328.GD16647@wotan.suse.de>
References: <20070204104609.GA29943@wotan.suse.de> <20070204025602.a5f8c53a.akpm@linux-foundation.org> <20070204110317.GA9034@wotan.suse.de> <20070204031549.203f7b47.akpm@linux-foundation.org> <20070204151051.GB12771@wotan.suse.de> <20070204103620.33c24cad.akpm@linux-foundation.org> <20070206022549.GB31476@wotan.suse.de> <20070206044146.GA11856@wotan.suse.de> <20070205213006.0ea2d918.akpm@linux-foundation.org> <20070206054905.GC16647@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070206054905.GC16647@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 06, 2007 at 06:49:05AM +0100, Nick Piggin wrote:
> > - If the get_user() doesn't fault, and if we're copying from and to the
> >   same page, we know that we've locked it, so nobody will be able to unmap
> >   it while we're copying from it.
> > 
> > Close, but no cigar!  This is still vulnerable to Hugh's ab/ba deadlock
> > scenario.
> 
> Yes I considered this too. Hard isn't it?

BTW, there are two different abba deadlocks. It's all documented in the
patch 9/9 description.
