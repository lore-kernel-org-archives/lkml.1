Return-Path: <linux-kernel-owner+w=401wt.eu-S1754977AbYBPK7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbYBPK7D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 05:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYBPK6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 05:58:52 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41242 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbYBPK6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 05:58:51 -0500
Date: Sat, 16 Feb 2008 02:58:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch 1/6] mmu_notifier: Core code
Message-Id: <20080216025803.40d8ccbc.akpm@linux-foundation.org>
In-Reply-To: <47B6BDDF.90502@inria.fr>
References: <20080215064859.384203497@sgi.com>
	<20080215064932.371510599@sgi.com>
	<20080215193719.262c03a1.akpm@linux-foundation.org>
	<47B6BDDF.90502@inria.fr>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 11:41:35 +0100 Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Andrew Morton wrote:
> > What is the status of getting infiniband to use this facility?
> >
> > How important is this feature to KVM?
> >
> > To xpmem?
> >
> > Which other potential clients have been identified and how important it it
> > to those?
> >   
> 
> As I said when Andrea posted the first patch series, I used something
> very similar for non-RDMA-based HPC about 4 years ago. I haven't had
> time yet to look in depth and try the latest proposed API but my feeling
> is that it looks good.
> 

"looks good" maybe.  But it's in the details where I fear this will come
unstuck.  The likelihood that some callbacks really will want to be able to
block in places where this interface doesn't permit that - either to wait
for IO to complete or to wait for other threads to clear critical regions.

>From that POV it doesn't look like a sufficiently general and useful
design.  Looks like it was grafted onto the current VM implementation in a
way which just about suits two particular clients if they try hard enough.

Which is all perfectly understandable - it would be hard to rework core MM
to be able to make this interface more general.  But I do think it's
half-baked and there is a decent risk that future (or present) code which
_could_ use something like this won't be able to use this one, and will
continue to futz with mlock, page-pinning, etc.

Not that I know what the fix to that is..
