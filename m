Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbXKNMiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbXKNMiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754771AbXKNMil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:38:41 -0500
Received: from mail.suse.de ([195.135.220.2]:35171 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbXKNMik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:38:40 -0500
To: Christoph Hellwig <hch@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, eranian@hpl.hp.com,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
From: Andi Kleen <andi@firstfloor.org>
References: <p73abpl2654.fsf@bingen.suse.de>
	<20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com>
	<20071113175545.GD4319@frankl.hpl.hp.com>
	<53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
	<20071113185924.GA22748@suse.de>
	<20071113120728.4342e7d7.akpm@linux-foundation.org>
	<18234.41652.199520.31261@cargo.ozlabs.ibm.com>
	<20071114103805.GA16652@infradead.org>
	<18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
Date: Wed, 14 Nov 2007 13:38:38 +0100
In-Reply-To: <20071114110009.GA17833@infradead.org> (Christoph Hellwig's message of "Wed\, 14 Nov 2007 11\:00\:09 +0000")
Message-ID: <p734pfp6lyp.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:
>
> I've done this a gazillion times before, so maybe instead of beeing a lazy
> bastard you could look up mailinglist archive.  It's not like this is the
> first discussion of perfmon.  But to get start look at the systems calls,
> many of them are beasts like:
>
>   int pfm_read_pmds(int fd, pfarg_pmd_t *pmds, int n)
>
> This is basically a read(2) (or for other syscalls a write) on something

At least for x86 and I suspect some 1other architectures we don't
initially need a syscall at all for this. There is an instruction
RDPMC who can read a performance counter just fine. It is also much
faster and generally preferable for the case where a process measures
events about itself. In fact it is essential for one of the use cases
I would like to see perfmon used (replacement of RDTSC for cycle
counting) 

Later a syscall might be needed with event multiplexing, but that seems
more like a far away non essential feature.

> else than the file descriptor provided to the system call.   The right thing

I don't like read/write for this too much. I think it's better to
have individual syscalls.  After all that is CPU state and having
syscalls for that does seem reasonable.

-Andi
