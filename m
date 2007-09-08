Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbXIHI6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbXIHI6Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 04:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbXIHI6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 04:58:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:57861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbXIHI6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 04:58:00 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 10:53:36 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jesse.barnes@intel.com>, linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com> <200709090348.28076.nickpiggin@yahoo.com.au> <200709080413.12282.nickpiggin@yahoo.com.au>
In-Reply-To: <200709080413.12282.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709081053.36842.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2007 20:13:12 Nick Piggin wrote:
> On Sunday 09 September 2007 03:48, Nick Piggin wrote:
> 
> > There is some suggestion in the source code that non-temporal stores
> > (movntq) are weakly ordered. But AFAIKS from the documents, it is ordered
> > when operating on wb memory. What's the situation there?
> 
> Sorry, it looks from the AMD document like nontemporal stores to wb
> memory can go out of order.

Yes, that is how NT stores are defined.
 
> If this is the case, we can either retain the sfence in smp_wmb(), or noop
> it, and put explicit sfences around any place that performs nontemporal
> stores...

We do this already, but in most cases it doesn't matter anyways. We AFAIK
do not rely on any ordering for copy_*_user for example. There are not
that many users of nt so it's not a huge issue.

> 
> Anyway, the lfence should be able to go away without so much trouble.

You mean sfence? lfence in rmb is definitely needed.

sfence on x86-64 is not strictly needed, but also shouldn't hurt very much 
so I always kept it in.

-Andi
