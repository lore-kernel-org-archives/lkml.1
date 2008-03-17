Return-Path: <linux-kernel-owner+w=401wt.eu-S1753570AbYCQFxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbYCQFxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:53:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYCQFxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:53:14 -0400
Received: from phunq.net ([64.81.85.152]:33618 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751408AbYCQFxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:53:14 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Sun, 16 Mar 2008 21:52:57 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803161942.01944.phillips@phunq.net> <alpine.DEB.1.00.0803162052160.14887@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803162052160.14887@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803162252.58274.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 March 2008 20:59, david@lang.hm wrote:
> On Sun, 16 Mar 2008, Daniel Phillips wrote:
> > On Sunday 16 March 2008 18:31, David Newall wrote:
> >> Daniel Phillips wrote:
> >>> The UPS provides a guarantee of commit to stable storage.  No amount of
> >>> FUD will change that.
> >>
> >> What about system crashes?  They guarantee that data will be lost.  I
> >
> > Not if it is mirrored and replicated.  Also nice if crashes are very
> > rare, which they are unless you work at it.
> 
> if you are depending on replication over the network you have just limited 
> your throughput to your network speed and latency.

Replication does not work that way.  On each replication cycle, the
differences between the most recent two volume snapshots go over the
network.  This strategy has the nice effect of consolidating rewrites.
There are also excellent delta compression opportunities.

In the worst case, with insufficient bandwidth for the churn rate of
the volume, replication rate increases to the time for replicating the
full volume.  Again, at worst, this would require extra storage for the
snapshot to be replicated equivalent to the original volume size, so
that the primary volume is not forced to wait synchronously for a
replication cycle to complete.

Mirroring on the other hand, makes a realtime copy of a volume, that is
never out of date.

I hope this helps.

> on an enterprise level  
> machine the network can frequently be significantly slower than the disk 
> array that you are so frantic to avoid waiting for.

Frantic... your word.  Designing for dependably high transaction rates
requires a different mode of thinking that some traditionalists seem to
be having some trouble with.

Daniel
