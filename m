Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZIQW0g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZIQW0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 18:26:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZIQW0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 18:26:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45013 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZIQW0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 18:26:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david.graham@intel.com
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Date: Fri, 18 Sep 2009 00:27:37 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909170118.53965.rjw@sisk.pl> <4AB29F4A.3030102@intel.com>
In-Reply-To: <4AB29F4A.3030102@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909180027.37387.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 September 2009, Graham, David wrote:
> Rafael J. Wysocki wrote:
> > On Tuesday 15 September 2009, Karol Lewandowski wrote:
> >> Hello,
> >>
> >> I'm getting following oops sometimes during resume on my Thinkpad T21
> >> (where "sometimes" means about 10/1 good/bad ratio):
> >>
> >> ifconfig: page allocation failure. order:5, mode:0x8020
> > 
> > Well, this only tells you that an attempt to make order 5 allocation failed,
> > which is not unusual at all.
> > 
> > Allocations of this order are quite likely to fail if memory is fragmented,
> > the probability of which rises with the number of suspend-resume cycles already
> > carried out.
> > 
> > I guess the driver releases its DMA buffer during suspend and attempts to
> > allocate it back on resume, which is not really smart (if that really is the
> > case).
> > 
> Yes, we free a 70KB block (0x80 by 0x230 bytes) on suspend and 
> reallocate on resume, and so that's an Order 5 request. It looks 
> symmetric, and hasn't changed for years. I don't think we are leaking 
> memory, which points back to that the memory is too fragmented to 
> satisfy the request.
> 
> I also concur that Rafael's commit 6905b1f1 shouldn't change the logic 
> in the driver for systems with e100 (like yours Karol) that could 
> already sleep, and I don't see anything else in the driver that looks to 
> be relevant. I'm expecting that your test result without commit 6905b1f1 
> will still show the problem.
> 
> So I wonder if this new issue may be triggered by some other change in 
> the memory subsystem ?

I think so.  There have been reports about order 2 allocations failing for
2.6.31, so it looks like newer kernels are more likely to expose such problems.

Adding linux-mm to the CC list.

Thanks,
Rafael
