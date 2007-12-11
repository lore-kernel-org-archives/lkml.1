Return-Path: <linux-kernel-owner+w=401wt.eu-S1756298AbXLKUH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298AbXLKUH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:07:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXLKUHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:07:52 -0500
Received: from phunq.net ([64.81.85.152]:56232 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751511AbXLKUHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:07:51 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Date: Tue, 11 Dec 2007 12:07:43 -0800
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
References: <200712051603.02183.phillips@phunq.net> <200712100617.24157.phillips@phunq.net> <20071211131514.GB25437@kernel.dk>
In-Reply-To: <20071211131514.GB25437@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712111207.43156.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 December 2007 05:15, Jens Axboe wrote:
> As to the patch in question "fixing" it in the block layer, it's a
> fairly simple work around and I'm not totally against it. If you get
> rid of the ->bi_throttle stuff and just do sanity checks on the
> count, then we could look at getting some testing done.

Oh, sorry I missed that olive branch on first read.  Getting rid of 
those 8 bytes that bother you requires an extensive rethink of bio  
handling in order to make some fields that are not now constant, 
constant or at least restored on change.  Which would be a good thing 
in itself.  There are lots of good improvements that can be made to 
this subsystem along those lines.

But that is properly a separate project.  Quite some time will be needed 
to get it right, and should I mention it, everybody needs to be on the 
same page or the work will never start.  It is therefore a theoretical 
solution.  We have a practical, tested solution, here and now, and it 
is short enough to be understood, unlike any of the previous attempts.

Your argument seems to be that adding 8 bytes to struct bio turns this 
beautiful swan into an ugly duck.  Actually, because the throttling 
reduces the number of bios in flight in a busy system, total memory use 
is reduced.  When the system is not busy, there are few bios hanging 
around so that is not a problem either.  Nice, hmm?

Daniel
