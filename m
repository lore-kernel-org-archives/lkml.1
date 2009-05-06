Return-Path: <linux-kernel-owner+w=401wt.eu-S1758739AbZEFLo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758739AbZEFLo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 07:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbZEFLoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 07:44:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47297 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758432AbZEFLoh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 07:44:37 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090505151520.070c84c1.akpm@linux-foundation.org>
References: <20090505151520.070c84c1.akpm@linux-foundation.org> <20090505212638.17034.10989.stgit@warthog.procyon.org.uk> <20090505212648.17034.18375.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, npiggin@suse.de,
       gerg@snapgear.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] NOMMU: Make the initial mmap allocation excess behaviour Kconfig configurable
Date: Wed, 06 May 2009 12:42:41 +0100
Message-ID: <23252.1241610161@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Nasty problem.

Yes.  That's part of the fun of the NOMMU world.  It has many of the same
problems as the MMU world - just more exaggerated.

> > -int sysctl_nr_trim_pages = 1; /* page trimming behaviour */
> > +int sysctl_nr_trim_pages = CONFIG_NOMMU_INITIAL_TRIM_EXCESS;
> >  int heap_stack_gap = 0;
> >  
> 
> But there's a risk of -ENOMEM regression on other system here?

There shouldn't be (assuming you mean with this patch), the default is the
same as the original value.

> It's unlikely to be a huge problem for real-world embedded developers,
> as long as they know about this change.  And because you set the
> Kconfig default to "no change" then I guess they'll be none the wiser.
> 
> I think that patches 2 and 3 (and #1 unless I reorder and redo things)
> are 2.6.30 material.  Agree?

Assuming you mean go in before 2.6.30 is cut, then yes.  If you want, I can
reorder the patches to put #1 last.

David
