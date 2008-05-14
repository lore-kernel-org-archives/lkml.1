Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbYENWBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbYENWBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 18:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751726AbYENWBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 18:01:16 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:39684 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYENWBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 18:01:15 -0400
Date: Wed, 14 May 2008 16:00:58 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, mpm@selenic.com,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [patch 21/21] slab defrag: Obsolete SLAB
Message-ID: <20080514220058.GG9921@parisc-linux.org>
References: <Pine.LNX.4.64.0805141009210.15194@schroedinger.engr.sgi.com> <482B2617.5010605@firstfloor.org> <Pine.LNX.4.64.0805141104260.15633@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805141333550.18231@schroedinger.engr.sgi.com> <20080514205842.GC9921@parisc-linux.org> <Pine.LNX.4.64.0805141359420.18958@schroedinger.engr.sgi.com> <20080514212130.GD9921@parisc-linux.org> <Pine.LNX.4.64.0805141426440.19073@schroedinger.engr.sgi.com> <20080514214326.GF9921@parisc-linux.org> <Pine.LNX.4.64.0805141444220.19897@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805141444220.19897@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2008 at 02:53:57PM -0700, Christoph Lameter wrote:
> > Note the complete lack of comparison between slub and slab here!  As far
> > as I know, slub still loses against slab by a few % -- but I haven't
> > finished running a comparison with -rc2 yet.
> 
> Indeed remote frees are slightly slower in some situations. Dont really 
> dispute that. I am just not sure that the TPC test is really suffering 
> from that symptom. I thought for a long time that the tbench regression 
> was due to a similar effect too until I got down to it.

Since there's no way we've found to date to get the TPC test to you,
how about we settle for analysing _this_ testcase which did show a
significant performance degradation for slub?

I don't think it's an unreasonable testcase either -- effectively it's
allocating memory on all CPUs and then freeing it all on one.  If that's
a worst-case scenario for slub, then slub isn't suitable for replacing
slab yet.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
