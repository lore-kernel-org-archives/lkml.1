Return-Path: <linux-kernel-owner+w=401wt.eu-S1753301AbXDUWS4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbXDUWS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:18:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753507AbXDUWS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:18:56 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36112 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753301AbXDUWSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:18:55 -0400
Date: Sat, 21 Apr 2007 15:18:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Chinner <dgc@sgi.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Christoph Lameter <clameter@sgi.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Andi Kleen <ak@suse.de>
Subject: Re: [RFC 0/8] Variable Order Page Cache
Message-Id: <20070421151830.4edb54ae.akpm@linux-foundation.org>
In-Reply-To: <20070420074818.GN32602149@melbourne.sgi.com>
References: <20070419163504.11948.58487.sendpatchset@schroedinger.engr.sgi.com>
	<20070419224225.GJ32602149@melbourne.sgi.com>
	<20070420063257.GB6525@kernel.dk>
	<20070420074818.GN32602149@melbourne.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 17:48:18 +1000 David Chinner <dgc@sgi.com> wrote:

> Agreed - I was talking about a quick way to hack a real filesystem
> in to the VM to start exercising the new VM code without needing to
> implement compound page support down the whole I/O stack. 

Yes.  The whole point of this work is to speed stuff up, so I'd encourage
people to first work on getting some minimal scruffy proptotype in place -
whatever is needed to be able to start running performance tests.

Then we can take a look at the numbers (and the types of machines and
workloads upon which they are based) and decide whether it looks like
there's any point in proceeding with a full-on implementation.

And as part of that decision-making process we should take a detailed look
at the performance of the existing code and see if there are other ways in
which it might be acceptably sped up.

Because right now we're assuming that larger pages are the only way in
which acceptable performance may be obtained.  But that has not been proved.
