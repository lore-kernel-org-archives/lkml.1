Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbYJTDiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbYJTDiQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 23:38:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYJTDiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 23:38:00 -0400
Received: from gate.crashing.org ([63.228.1.57]:47865 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYJTDiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 23:38:00 -0400
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
In-Reply-To: <1224279947.7654.106.camel@pasglop>
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop>
	 <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org>
	 <20081016.210404.151891223.davem@davemloft.net>
	 <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org>
	 <1224220339.7654.84.camel@pasglop>
	 <alpine.LFD.2.00.0810170852010.3438@nehalem.linux-foundation.org>
	 <1224277413.7654.95.camel@pasglop>
	 <alpine.LFD.2.00.0810171410020.3438@nehalem.linux-foundation.org>
	 <1224279947.7654.106.camel@pasglop>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 14:37:30 +1100
Message-Id: <1224473850.7654.128.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-10-18 at 08:45 +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2008-10-17 at 14:11 -0700, Linus Torvalds wrote:
> 
> > So the default is all the wrong way around. Make the defaults the sane 
> > ones: 04x for IO, and 08x for MMIO, and then see if anybody wants anything 
> > else. I seriously doubt they do. The whole ".. but but sparc" argument 
> > seems to be entirely based on the total mis-conception of truncation that 
> > has no relevance.
> 
> Well, I definitely want 08x for IO on powerpc and I suspect anything
> non-x86 or alpha does as well... So I'm fine but I'd like to keep
> the default for IO at 08x unless you really have a strong opinion
> against it.

Actually, screw it. 04x is fine, as you said, it's not going to truncate
anyway. The reason I wanted 08x on powerpc is that we have legitimate
negative-looking values in there due to the way we do PIO on 32-bit and
we have most PCI IO looking like it's >64K on 64-but but that's no big
deal, ie, we don't actually need the padding for IO space.

So I'm happy with just a padding of 8 for memory which is even good
looking for most 64-bit archs in fact, and 4 for IO. I left the ability
for archs to pick a different value if they want to tho.

I'll send the patch separately after a test or two with a better mail
subject.

Cheers,
Ben.


