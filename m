Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYGUItc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYGUItc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 04:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755474AbYGUItY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 04:49:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44021 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755371AbYGUItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 04:49:24 -0400
Date: Mon, 21 Jul 2008 04:49:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/23] tracehook: exec
Message-ID: <20080721084908.GA11580@infradead.org>
References: <20080717072541.F390E15411D@magilla.localdomain> <20080717072820.B14E715411D@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717072820.B14E715411D@magilla.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 12:28:20AM -0700, Roland McGrath wrote:
> This moves all the ptrace hooks related to exec into tracehook.h inlines.
> 
> This also lifts the calls for tracing out of the binfmt load_binary hooks
> into search_binary_handler() after it calls into the binfmt module.  This
> change has no effect, since all the binfmt modules' load_binary functions
> did the call at the end on success, and now search_binary_handler() does
> it immediately after return if successful.  We consolidate the repeated
> code, and binfmt modules no longer need to import ptrace_notify().

Care to first just consolidate the code from the binary handlers to
exec.c and then restrucure it?  Currently mainline doesn't even
have ptrace_event yet so it's hard to verify the code is the same.
It certainly isn't for binfmt_som although that's like just a bugfix
that needs to be documented.  Also the two new routines are too large
to be inlined, and I would rather not rely on the guarantee that no
other caller will pop up.

