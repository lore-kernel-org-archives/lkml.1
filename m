Return-Path: <linux-kernel-owner+w=401wt.eu-S1753336AbXEXXh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336AbXEXXh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750729AbXEXXhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:37:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbXEXXhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:37:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070524162447.c9e14d14.akpm@linux-foundation.org>
References: <20070524162447.c9e14d14.akpm@linux-foundation.org> <20070524154611.080b38ed.akpm@linux-foundation.org> <20070524144732.d9b2650b.akpm@linux-foundation.org> <20070524133821.3ee9c9f3.akpm@linux-foundation.org> <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com> <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com> <27608.1180042522@redhat.com> <28590.1180046073@redhat.com> <29173.1180048123@redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from the pagecache
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Fri, 25 May 2007 00:37:45 +0100
Message-ID: <29613.1180049865@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> But we already covered that?  Your exciser can do an unconditional
> end_page_writeback(), because it is this thread of control which did the
> set_page_writeback().  So we end up with:

Ah, I misunderstood what you meant.  I assumed you meant to wait insted of
ending.

Of course, if we've decided to excise this page, it really oughtn't to get
PG_writeback set again.  I'll have to think about that.

> Well someone needs to be taught all about this case.  Question is, should
> it be the VFS, or should it just be the address_space(s) which brought
> this state about, and which care about it?

For the most part, I think that this only applies to netfs's, and possibly not
all of those, so making it fully general might be overkill.

David
