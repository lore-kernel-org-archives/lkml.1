Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbXKMWZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbXKMWZp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 17:25:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbXKMWZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 17:25:37 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41867 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbXKMWZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 17:25:36 -0500
Date: Tue, 13 Nov 2007 23:25:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, perfmon@napali.hpl.hp.com,
       William Cohen <wcohen@redhat.com>, perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071113222534.GC17145@one.firstfloor.org>
References: <p73abpl2654.fsf@bingen.suse.de> <20071113151718.GA3804@erda.amd.com> <4739C42F.8030208@redhat.com> <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071113222234.GH5747@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 02:22:34PM -0800, Stephane Eranian wrote:
> Andi,
> On Tue, Nov 13, 2007 at 10:50:56PM +0100, Andi Kleen wrote:
> > > Yes, horribly more complicated because of locking issues within perfmon.
> > > As soon as you expose a file descriptor, you need some locking to prevent
> > > multiple user threads (malicious or not) to compete to access the PMU state.
> > 
> > Why do you need the file descriptor? 
> > 
> 
> To identify your monitoring session be it system-wide (i.e., per-cpu) or per-thread.
> file descriptor allows you to use close, read, select, poll and you leverage the

Surely that could be done with a flag for each call too? Keeping file descriptors
to pass essentially a boolean seems overkill.

> existing file descriptor sharing/inheritance sematics. At the kernel level, a 
> descriptor provides all the callback necessary to make sure you clean up the perfmon
> session state on exit.

Didn't you already have a thread destructor for it?

-Andi
