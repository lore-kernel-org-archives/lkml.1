Return-Path: <linux-kernel-owner+w=401wt.eu-S1753293AbZIVXut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbZIVXut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 19:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbZIVXut
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 19:50:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752286AbZIVXus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 19:50:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Subject: Re: [BUG 2.6.30+] e100 sometimes causes oops during resume
Date: Wed, 23 Sep 2009 01:51:36 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rjw; KDE/4.3.1; x86_64; ; )
Cc: david.graham@intel.com,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
References: <20090915120538.GA26806@bizet.domek.prywatny> <200909180027.37387.rjw@sisk.pl> <20090922233531.GA3198@bizet.domek.prywatny>
In-Reply-To: <20090922233531.GA3198@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909230151.36678.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 September 2009, Karol Lewandowski wrote:
> On Fri, Sep 18, 2009 at 12:27:37AM +0200, Rafael J. Wysocki wrote:
> > On Thursday 17 September 2009, Graham, David wrote:
> > > Rafael J. Wysocki wrote:
> > > > I guess the driver releases its DMA buffer during suspend and attempts to
> > > > allocate it back on resume, which is not really smart (if that really is the
> > > > case).
> 
> > > Yes, we free a 70KB block (0x80 by 0x230 bytes) on suspend and 
> > > reallocate on resume, and so that's an Order 5 request. It looks 
> > > symmetric, and hasn't changed for years. I don't think we are leaking 
> > > memory, which points back to that the memory is too fragmented to 
> > > satisfy the request.
> > > 
> > > I also concur that Rafael's commit 6905b1f1 shouldn't change the logic 
> > > in the driver for systems with e100 (like yours Karol) that could 
> > > already sleep, and I don't see anything else in the driver that looks to 
> > > be relevant. I'm expecting that your test result without commit 6905b1f1 
> > > will still show the problem.
> > > 
> > > So I wonder if this new issue may be triggered by some other change in 
> > > the memory subsystem ?
> 
> > I think so.  There have been reports about order 2 allocations failing for
> > 2.6.31, so it looks like newer kernels are more likely to expose such problems.
> > 
> > Adding linux-mm to the CC list.
> 
> I've hit this bug 2 times since my last email.  Is there anything I
> could do?
> 
> Maybe I should revert following commits (chosen somewhat randomly)?
> 
> 1. 49255c619fbd482d704289b5eb2795f8e3b7ff2e
> 
> 2. dd5d241ea955006122d76af88af87de73fec25b4 - alters changes made by
> commit above
> 
> Any ideas?

You can try that IMO.

Best,
Rafael
