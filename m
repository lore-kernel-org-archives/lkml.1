Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYJBWYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYJBWYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 18:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbYJBWX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 18:23:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41989 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbYJBWXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 18:23:55 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
In-Reply-To: <Pine.LNX.4.64.0810011817060.19654@blonde.site>
References: <Pine.LNX.4.64.0810011817060.19654@blonde.site> <1222818570.13453.5.camel@calx>
To: Hugh Dickins <hugh@veritas.com>
Cc: dhowells@redhat.com, Matt Mackall <mpm@selenic.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: unify shmem and tiny-shmem
Date: Thu, 02 Oct 2008 23:23:40 +0100
Message-ID: <1710.1222986220@redhat.com>
From: David Howells <dhowells@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh Dickins <hugh@veritas.com> wrote:

> That's much nicer than I'd been imagining, thanks Matt: I've no qualms
> about the few #ifdefs you're adding to mm/shmem.c, it does seem an
> outright improvement that you're bringing them together.

It's not an outright improvement.  shmem.o is still larger than tiny-shmem.o,
albeit not a lot; however, some embedded people really do count the bytes.

> This ifndef is the ugliest part of it: and looking into it, guess
> what, shmem_get_unmapped_area() hasn't been used since 2.6.20 -
> that's right, isn't it, David?

Ummm...  It seems to be.  I think it used to be used by SYSV SHM.  Certainly
deleting that function causes no link problems.

David
