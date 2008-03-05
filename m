Return-Path: <linux-kernel-owner+w=401wt.eu-S1761898AbYCEVMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761898AbYCEVMs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 16:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755664AbYCEVMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 16:12:38 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:42995 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754585AbYCEVMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:12:37 -0500
Date: Wed, 5 Mar 2008 21:11:34 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Christian Kujau <lists@nerdbynature.de>
cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.25-rc3: 34TB vmalloc total -- overflow in /proc/meminfo?
In-Reply-To: <alpine.DEB.1.00.0803052038410.8658@sheep.housecafe.de>
Message-ID: <Pine.LNX.4.64.0803052045430.821@blonde.site>
References: <20080305090610.GA30024@atrey.karlin.mff.cuni.cz>
 <alpine.DEB.1.00.0803052038410.8658@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008, Christian Kujau wrote:
> On Wed, 5 Mar 2008, Pavel Machek wrote:
> > CommitLimit:   4132360 kB
> > Committed_AS:    27684 kB
> > VmallocTotal: 34359738367 kB
> > VmallocUsed:     18112 kB
> > VmallocChunk: 34359720115 kB

I don't see what Pavel's issue is with this: it's simply a fact that
with a 64-bit kernel, we've lots of virtual address space to spare
for vmalloc.  What would be surprising is for VmallocUsed to get up
as high as that.

> 
> out of curiosity: yesterday I've seen a box[0] with ~4 TB Committed_AS:
> 
> CommitLimit:   3085152 kB
> Committed_AS: 4281048084 kB
> VmallocTotal:   118776 kB
> VmallocUsed:     13772 kB
> VmallocChunk:   103880 kB
> 
> Since it's a rather old kernel (2.6.19.2), I just want to know: could this be
> related to what you've seen or this completely different

Completely different and much more interesting.

> (and Committed_AS is
> just this high because some st00pid app has allocated this much memory but not
> freed again)?

Unlikely.  Offhand I'm not quite sure that's impossible, but it's far
more likely that we've a kernel bug and vm_committed_space has wrapped
negative.

Ancient as your kernel is, I don't notice anything in the ChangeLogs
since then to say we've fixed a bug of that kind since 2.6.19.
Any idea how to reproduce this?  Are you using HugePages at all?
(It's particularly easy for us to get into a muddle over them,
though historically I think mremap has proved most difficult for
Committed_AS accounting).

Thanks,
Hugh

> 
> Thanks,
> Christian.
> 
> [0] amd64, 32bit kernel, 32bit userland, 4GB RAM
