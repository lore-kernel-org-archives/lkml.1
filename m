Return-Path: <linux-kernel-owner+w=401wt.eu-S1763655AbZE1SSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763655AbZE1SSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 14:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756302AbZE1SSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 14:18:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:41897 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756967AbZE1SSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 14:18:03 -0400
From: Olaf Kirch <okir@suse.de>
To: David Newall <davidn@davidnewall.com>
Subject: Re: CFS Performance Issues
Date: Thu, 28 May 2009 20:20:09 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.27.21-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com,
       Andreas Gruenbacher <agruen@suse.de>
References: <200905281502.22487.okir@suse.de> <4A1EB272.3050902@davidnewall.com>
In-Reply-To: <4A1EB272.3050902@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905282020.09667.okir@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 May 2009 17:49:06 David Newall wrote:
> > I see this:
> >
> > ./slice 16
> >     avg slice:  1.12 utime: 216263.187500
> > ...
> > Any insight you can offer here is greatly appreciated!
> >   
> 
> About that: avg slice is in nsec, not msec (the old, off-by-one-million
> bug), and utime, also an average, is in usec.

I'm not sure I'm following what you're saying.

The test program uses getrusage(SELF) to get the utime, which is in
microseconds.

For the average time slice, it takes ru_ninvcsw, ie the number of involuntary
context switches as reported by getrusage, and computes

	utime / ninvcsw / 1000

which is a millisecond quantity.

> The first result indicates 1.12 nsec per context switch,  193 context
> switches and 346% CPU utilisation.  You must have at least four CPU

Consider the first line a bogon - it's crap resulting from variables not being
initialized with proper values the first time around. This machine is actually a
core duo, and as you notice, most of the time the numbers add up to
roughly 200% CPU utilization.

But you're right that it sometimes reports more than 200% is actually
a bug in the test case - it's not guaranteed that we're taking the samples
always exactly 1 second apart, so the utime needs to be scaled by the
elapsed wall time.

I'll fix that and come back

Olaf
-- 
Neo didn't bring down the Matrix. SOA did.
				--soafacts.com

