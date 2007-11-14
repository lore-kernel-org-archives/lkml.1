Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbXKNO0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbXKNO0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXKNO0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:26:33 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54352 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbXKNO0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:26:33 -0500
Date: Wed, 14 Nov 2007 15:26:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Philip Mucci <mucci@cs.utk.edu>, William Cohen <wcohen@redhat.com>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
       Perfmon <perfmon@napali.hpl.hp.com>,
       perfmon2-devel@lists.sourceforge.net,
       OSPAT devel <ospat-devel@cs.utk.edu>,
       papi list <ptools-perfapi@cs.utk.edu>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114142629.GE17145@one.firstfloor.org>
References: <20071113175545.GD4319@frankl.hpl.hp.com> <53F4663B-CFBA-44E4-8283-BAAC8C8F1AFF@cs.utk.edu> <20071113185924.GA22748@suse.de> <20071113120728.4342e7d7.akpm@linux-foundation.org> <18234.41652.199520.31261@cargo.ozlabs.ibm.com> <20071114103805.GA16652@infradead.org> <18234.53558.883970.87414@cargo.ozlabs.ibm.com> <20071114110009.GA17833@infradead.org> <p734pfp6lyp.fsf@bingen.suse.de> <20071114141342.GH6557@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114141342.GH6557@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 06:13:42AM -0800, Stephane Eranian wrote:
> > At least for x86 and I suspect some 1other architectures we don't
> > initially need a syscall at all for this. There is an instruction
> > RDPMC who can read a performance counter just fine. It is also much
> > faster and generally preferable for the case where a process measures
> > events about itself. In fact it is essential for one of the use cases
> > I would like to see perfmon used (replacement of RDTSC for cycle
> > counting) 
> > 
> 
> This only works when counting (not sampling) and only for self-monitoring.

It works for global monitoring too.

> 
> > Later a syscall might be needed with event multiplexing, but that seems
> > more like a far away non essential feature.
> > 
> On a machine with only two generic counters such as MIPS or Intel Core 2 Duo,
> multiplexing offers some advantages. If NMI watchdog is enabled, then you drop
> to one generic counter on on Core 2.

NMI watchdog is off by default now.

Yes longer term we might need multiplexing, but definitely not as first step.

-Andi
