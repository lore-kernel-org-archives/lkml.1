Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYCJRVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYCJRVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 13:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYCJRVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 13:21:18 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:48232 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111AbYCJRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 13:21:17 -0400
Date: Mon, 10 Mar 2008 17:19:32 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andi Kleen <andi@firstfloor.org>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <87myp68r88.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0803101707070.3398@blonde.site>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de>
 <20080309111456.GA21690@elte.hu> <20080309210000.C6DE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <20080309120940.GA1695@elte.hu> <20080309123432.GA3267@elte.hu>
 <20080309114640.85c9c3eb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0803100851560.23575@schroedinger.engr.sgi.com>
 <87myp68r88.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Mar 2008, Andi Kleen wrote:
> Christoph Lameter <clameter@sgi.com> writes:
> > 
> > Zeroed pages however will not address the issue of having initialized pgd 
> > (which seems to be what i386 needs).
> 
> pgd is tiny on i386 PAE (4 * 16 bytes). Are you sure reinitializing that
> is a serious issue? ...

It used to be tiny (32 aligned bytes), then 2.6.22's quicklist enlarged
that to a whole (lowmem) page.  I think we were all too busy with other
stuff to protest loudly enough about that bloat.

If the quicklists are going, it'd be good for PAE to go back to a
kmem_cache of 32-byte entries as in 2.6.21 - I think Ingo's patch is
still using a whole page there.

Or have sl?b alignment changes, or virtualization issues (locking
per underlying struct page?), made a kmem_cache awkward there now?

Hugh
