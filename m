Return-Path: <linux-kernel-owner+w=401wt.eu-S1423131AbXBBGSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423131AbXBBGSQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 01:18:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423133AbXBBGSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 01:18:16 -0500
Received: from omx1-ext.sgi.com ([192.48.179.11]:44631 "EHLO omx1.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423131AbXBBGSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 01:18:15 -0500
Date: Thu, 1 Feb 2007 22:17:34 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Neil Brown <neilb@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Ethan Solomita <solo@google.com>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       linux-mm@kvack.org, Andi Kleen <ak@suse.de>, Paul Jackson <pj@sgi.com>,
       Dave Chinner <dgc@sgi.com>
Subject: Re: [RFC 0/8] Cpuset aware writeback
In-Reply-To: <17858.54239.364738.88727@notabene.brown>
Message-ID: <Pine.LNX.4.64.0702012213140.31640@schroedinger.engr.sgi.com>
References: <20070116054743.15358.77287.sendpatchset@schroedinger.engr.sgi.com>
 <45C2960B.9070907@google.com> <Pine.LNX.4.64.0702011815240.9799@schroedinger.engr.sgi.com>
 <20070201200358.89dd2991.akpm@osdl.org> <Pine.LNX.4.64.0702012044090.10575@schroedinger.engr.sgi.com>
 <17858.54239.364738.88727@notabene.brown>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Feb 2007, Neil Brown wrote:

> md/raid doesn't cause any problems here.  It preallocates enough to be
> sure that it can always make forward progress.  In general the entire
> block layer from generic_make_request down can always successfully
> write a block out in a reasonable amount of time without requiring
> kmalloc to succeed (with obvious exceptions like loop and nbd which go
> back up to a higher layer).

Hmmm... I wonder if that could be generalized. A device driver could make 
a reservation by increasing min_free_kbytes? Additional drivers in a 
chain could make additional reservations in such a way that enough 
memory is set aside for the worst case?

> The network stack is of course a different (much harder) problem.

An NFS solution is possible without solving the network stack issue?

