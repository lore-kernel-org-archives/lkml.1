Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbYCZXqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbYCZXqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 19:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754060AbYCZXqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 19:46:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51663 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754047AbYCZXqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 19:46:47 -0400
Date: Wed, 26 Mar 2008 16:43:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
cc: Gary Hade <garyhade@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Meyer <thomas@m3y3r.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>, pm@debian.org
Subject: Re: [patch] pci: revert "PCI: remove transparent bridge sizing"
In-Reply-To: <20080326232922.GA15784@jurassic.park.msu.ru>
Message-ID: <alpine.LFD.1.00.0803261638350.2775@woody.linux-foundation.org>
References: <47E969E1.6080608@m3y3r.de> <alpine.LFD.1.00.0803251445500.2775@woody.linux-foundation.org> <20080326101450.GA9060@jurassic.park.msu.ru> <20080326135458.GA27621@elte.hu> <20080326180701.GA6249@us.ibm.com> <alpine.LFD.1.00.0803261132310.2775@woody.linux-foundation.org>
 <20080326203012.GB6249@us.ibm.com> <alpine.LFD.1.00.0803261344430.2775@woody.linux-foundation.org> <20080326205828.GA15225@jurassic.park.msu.ru> <alpine.LFD.1.00.0803261416390.2775@woody.linux-foundation.org> <20080326232922.GA15784@jurassic.park.msu.ru>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 Mar 2008, Ivan Kokshaysky wrote:
> 
> If the new "align" field (and then, maybe, "size" instead of "end"?)
> is OK, then I'm definitely willing to give it a try.

Adding an alignment field should be a non-issue: the size of this 
structure is not likely to be a big deal (yeah, we have something like 12 
of them in each PCI device etc, so smaller is better, but it's still not 
going to be something anybody really notices).

And yeah, it might be nice to have "size" instead of "end", but the real 
problem with that one is actually that on 32-bit (without the 64-bit 
resource configuration) we want it to be "size-1" in order to be able to 
fit a whole 0-0xffffffff resource into a resource.

And *that* would be really ugly with "size": at least right now it makes a 
certain amount of sense with "end" pointing to the last entry.

So while I can understand your wish for "start+len" rather than 
"start+end", I don't think it's really practical.

		Linus
