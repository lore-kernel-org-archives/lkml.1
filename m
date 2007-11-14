Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbXKNLA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbXKNLA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:00:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbXKNLAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:00:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47016 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXKNLAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:00:17 -0500
Date: Wed, 14 Nov 2007 11:00:09 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, eranian@hpl.hp.com,
       William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114110009.GA17833@infradead.org>
References: <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <18234.41652.199520.31261@cargo.ozlabs.ibm.com> <20071114103805.GA16652@infradead.org> <18234.53558.883970.87414@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18234.53558.883970.87414@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 09:43:02PM +1100, Paul Mackerras wrote:
> Christoph Hellwig writes:
> 
> > Mine for example.  The whole userspace interface is just on crack,
> > and the code is full of complexities aswell.
> 
> Could you give some _technical_ details of what you don't like?

I've done this a gazillion times before, so maybe instead of beeing a lazy
bastard you could look up mailinglist archive.  It's not like this is the
first discussion of perfmon.  But to get start look at the systems calls,
many of them are beasts like:

  int pfm_read_pmds(int fd, pfarg_pmd_t *pmds, int n)

This is basically a read(2) (or for other syscalls a write) on something
else than the file descriptor provided to the system call.   The right thing
to do is obviously have a pmds and pmcs file in procfs for the thread beeing
monitored instead of these special-case files, with another set for global
tracing.  Similarly I'm pretty sure we can get a much better interface
if we introduce marching files in procfs for the other calls.

