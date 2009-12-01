Return-Path: <linux-kernel-owner+w=401wt.eu-S1753590AbZLAPNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbZLAPNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:13:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753087AbZLAPNd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:13:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58960 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753080AbZLAPNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:13:31 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091201142611.GA1183@elte.hu>
References: <20091201142611.GA1183@elte.hu> <25668.1259675528@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       steved@redhat.com, jens.axboe@oracle.com, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-fsdevel@vger.kernel.org,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org,
       linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] SLOW_WORK: Fix the CONFIG_MODULES=n case
Date: Tue, 01 Dec 2009 15:13:08 +0000
Message-ID: <31860.1259680388@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> wrote:

> this slow_work_wait_for_items() function should move into the #ifdef 
> block too.

I disagree: I want to keep the variable declaration blocks small; I'd rather
not even put the inline functions in there that I did.  I only did that because
you wanted the #ifdef count reduced.

> In terms of .32 i guess it's OK too and the fix is needed - but i'd really
> not have done even the preceding changes - why again did we need
> /proc/slow_work_rq via 8fba10a

The slow_work_rq debugging interface is not strictly necessary, but it proved a
useful debugging tool.  I emailed Linus before I went on holiday and asked if
he was willing to take these not-strictly-necessary patches on which other
patches were built, or whether he'd prefer me to drop those patches and adjust
the rest.

> and why did it have to happen right before the final kernel?

Because it did.  That's when I finished my set of patches and published them
before going on holiday for a week - and that in turn was related to when I
came up with a better test case.  Sometimes coincidences do happen.

> If then it should have been done in debugfs - we dont need yet another 
> /proc ABI.

Possibly.  That just means we have a debugfs ABI instead of a proc ABI - it
needs maintaining either way.  On the other hand, it can be moved there easily
and the docs changed, and doing so makes a reasonable amount of sense - except
that debugfs isn't normally mounted by at least Fedora for some reason.

David
