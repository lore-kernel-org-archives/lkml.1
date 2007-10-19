Return-Path: <linux-kernel-owner+w=401wt.eu-S1764343AbXJSVh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764343AbXJSVh0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 17:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXJSVg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 17:36:57 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42350 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765564AbXJSVgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 17:36:55 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Chris Mason <chris.mason@oracle.com>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>, stable@kernel.org
Subject: Re: [RFC][PATCH] block: Isolate the buffer cache in it's own mappings.
References: <200710151028.34407.borntraeger@de.ibm.com>
	<1192665785.15717.34.camel@think.oraclecorp.com>
	<m1tzopaxa1.fsf_-_@ebiederm.dsl.xmission.com>
	<200710181510.48382.nickpiggin@yahoo.com.au>
Date: Fri, 19 Oct 2007 15:35:40 -0600
In-Reply-To: <200710181510.48382.nickpiggin@yahoo.com.au> (Nick Piggin's
	message of "Thu, 18 Oct 2007 15:10:48 +1000")
Message-ID: <m1wstieqj7.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> writes:

>
> [*] The ramdisk code is simply buggy, right? (and not the buffer
>     cache)

>From the perspective of the ramdisk it expects the buffer cache to
simply be a user of the page cache, and thus the buffer cache
is horribly buggy.

>From the perspective of the buffer cache it still the block device
cache in the kernel and it the way it works are the rules for how
caching should be done in the kernel, and it doesn't give any
mind to this new fangled page cache thingy.

> The idea of your patch in theory is OK, but Andrew raises valid
> points about potential coherency problems, I think.

There are certainly implementation issues in various filesystems
to overcome before remounting read-write after doing a fsck
on a read-only filesystem will work as it does today.  So my patch
is incomplete.

Eric
