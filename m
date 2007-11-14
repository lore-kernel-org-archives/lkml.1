Return-Path: <linux-kernel-owner+w=401wt.eu-S1758126AbXKNLpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758126AbXKNLpv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbXKNLpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:45:30 -0500
Received: from ozlabs.org ([203.10.76.45]:47792 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbXKNLp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:45:28 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18234.56940.229831.735533@cargo.ozlabs.ibm.com>
Date: Wed, 14 Nov 2007 22:39:24 +1100
From: Paul Mackerras <paulus@samba.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, eranian@hpl.hp.com,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
In-Reply-To: <20071114110009.GA17833@infradead.org>
References: <p73abpl2654.fsf@bingen.suse.de>
	<20071113151718.GA3804@erda.amd.com>
	<4739C42F.8030208@redhat.com>
	<20071113175545.GD4319@frankl.hpl.hp.com>
	<53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu>
	<20071113185924.GA22748@suse.de>
	<20071113120728.4342e7d7.akpm@linux-foundation.org>
	<18234.41652.199520.31261@cargo.ozlabs.ibm.com>
	<20071114103805.GA16652@infradead.org>
	<18234.53558.883970.87414@cargo.ozlabs.ibm.com>
	<20071114110009.GA17833@infradead.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig writes:

>   int pfm_read_pmds(int fd, pfarg_pmd_t *pmds, int n)
> 
> This is basically a read(2) (or for other syscalls a write) on something
> else than the file descriptor provided to the system call.

No it's not basically a read().  It's more like a request/reply
interface, which a read()/write() interface doesn't handle very well.
The request in this case is "tell me about this particular collection
of PMDs" and the reply is the values.

It seems to me that an important part of this is to be able to collect
values from several PMDs at a single point in time, or at least an
approximation to a single point in time.  So that means that you don't
want a file per PMD either.

Basically we don't have a good abstraction for a request/reply (or
command/response) type of interface, and this is a case where we need
one.  Having a syscall that takes a struct containing the request and
reply is as good a way as any, particularly for something that needs
to be quick.

Paul.
