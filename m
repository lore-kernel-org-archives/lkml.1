Return-Path: <linux-kernel-owner+w=401wt.eu-S1755267AbYICSar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267AbYICSar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 14:30:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYICSaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 14:30:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52052 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbYICSai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 14:30:38 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Andrew Patterson <andrew.patterson@hp.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
       andmike@linux.vnet.ibm.com, mike.miller@hp.com, genanr@emsphone.com
Subject: Re: [PATCH 6/6] Call flush_disk() after detecting an online resize.
References: <20080829231254.25065.66052.stgit@bluto.andrew>
	<20080829231325.25065.48172.stgit@bluto.andrew>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 03 Sep 2008 14:20:11 -0400
In-Reply-To: <20080829231325.25065.48172.stgit@bluto.andrew> (Andrew
	Patterson's message of "Fri, 29 Aug 2008 17:13:26 -0600")
Message-ID: <x491w019jms.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Patterson <andrew.patterson@hp.com> writes:

> Call flush_disk() after detecting an online resize.
>
> We call flush_disk() to make sure the buffer cache for the disk is
> flushed after a disk resize. There are two resize cases, growing and
> shrinking. Given that users can shrink/then grow a disk before
> revalidate_disk() is called, we treat the grow case identically to
> shrinking. We need to flush the buffer cache after an online shrink
> because, as James Bottomley puts it,
>
>      The two use cases for shrinking I can see are
>
>      1. planned: the fs is already shrunk to within the new boundaries
>         and all data is relocated, so invalidate is fine (any dirty
>         buffers that might exist in the shrunk region are there only
>         because they were relocated but not yet written to their
>         original location).
>      2. unplanned:  In this case, the fs is probably toast, so whether
>         we invalidate or not isn't going to make a whole lot of
>         difference; it's still going to try to read or write from
>         sectors beyond the new size and get I/O errors.
>
> Immediately invalidating shrunk disks will cause errors for outstanding
> I/Os for reads/write beyond the new end of the disk to be generated
> earlier then if we waited for the normal buffer cache operation. It also
> removes a potential security hole where we might keep old data around
> from beyond the end of the shrunk disk if the disk was not invalidated.
>
> Signed-off-by: Andrew Patterson <andrew.patterson@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
