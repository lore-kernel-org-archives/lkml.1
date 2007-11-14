Return-Path: <linux-kernel-owner+w=401wt.eu-S1763515AbXKNVvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763515AbXKNVvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 16:51:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754772AbXKNVuu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 16:50:50 -0500
Received: from ozlabs.org ([203.10.76.45]:49472 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266AbXKNVut (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 16:50:49 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18235.26873.437786.651828@cargo.ozlabs.ibm.com>
Date: Thu, 15 Nov 2007 08:30:33 +1100
From: Paul Mackerras <paulus@samba.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, hch@infradead.org,
       akpm@linux-foundation.org, gregkh@suse.de, mucci@cs.utk.edu,
       eranian@hpl.hp.com, wcohen@redhat.com, robert.richter@amd.com,
       linux-kernel@vger.kernel.org, andi@firstfloor.org
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <200711141125.18568.nickpiggin@yahoo.com.au>
References: <20071114.031216.11725447.davem@davemloft.net>
	<200711141049.49154.nickpiggin@yahoo.com.au>
	<20071114.035850.202836100.davem@davemloft.net>
	<200711141125.18568.nickpiggin@yahoo.com.au>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin writes:

> What I really mean is a readv-like syscall, but one that also
> vectorises the file offset. Maybe this is useful enough as a generic
> syscall that also helps Paul's example...

I've sometimes thought it would be useful to have a "transaction"
system call that is like a write + read combined into one:

	int transaction(int fd, char *req, size_t req_nb,
			char *reply, size_t reply_nb);

as a way to provide a general request/reply interface for special
files.

> Of course, I guess this all depends on whether the atomicity is an
> important requirement. If not, you can obviously just do it with
> multiple read syscalls...

That would take N system calls instead of one, which could have a
performance impact if you need to read the counters frequently (which
I believe you do in some performance monitoring situations).

Paul.
