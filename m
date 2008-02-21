Return-Path: <linux-kernel-owner+w=401wt.eu-S935344AbYBUXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935344AbYBUXBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 18:01:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYBUXBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 18:01:13 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:53929 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbYBUXBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 18:01:11 -0500
Date: Thu, 21 Feb 2008 14:58:44 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
Subject: Re: 2.6.25-rc1 xen pvops regression
Message-ID: <20080221225844.GA7644@mail.oracle.com>
Mail-Followup-To: Ian Campbell <ijc@hellion.org.uk>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Jody Belka <lists-lkml@pimb.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
	Thomas Gleixner <tglx@linutronix.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mika Penttila <mika.penttila@kolumbus.fi>
References: <20080218104025.GA15899@ca-server1.us.oracle.com> <1203458366.26910.15.camel@cthulhu.hellion.org.uk> <47BBDA20.8030105@zytor.com> <1203497511.26910.39.camel@cthulhu.hellion.org.uk> <47BCA275.7000504@goop.org> <1203546597.26910.74.camel@cthulhu.hellion.org.uk> <47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com> <47BDEF36.8000903@goop.org> <1203631956.28436.4.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1203631956.28436.4.camel@cthulhu.hellion.org.uk>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 10:12:36PM +0000, Ian Campbell wrote:
> 
> On Thu, 2008-02-21 at 13:37 -0800, Jeremy Fitzhardinge wrote:
> > H. Peter Anvin wrote:
> > >> Still curious about why a pagetable page is ending up in that range 
> > >> though.  Seems like it shouldn't be possible, since we shouldn't be 
> > >> allowed to allocate from those pages, at least until the DMI probe 
> > >> has happened...  Unless the early allocator is only excluded from 
> > >> e820 reserved pages, which would cause a problem on systems which 
> > >> don't reserve the DMI space...  HPA?
> > >>
> > >
> > > I thought the problem was a Xen-provided pagetable from before Linux 
> > > started? 
> > 
> > Hm, I don't think so.  The domain-builder pagetable is put after the 
> > kernel, so it shouldn't be under 1M.
> 
> I can confirm that it is Linux which is allocating it. The call path:

	Also, I have older kernels (2.6.24-rc era) that run Just Fine.
I haven't changed my dom0 at all.

Joel

-- 

"There is no more evil thing on earth than race prejudice, none at 
 all.  I write deliberately -- it is the worst single thing in life 
 now.  It justifies and holds together more baseness, cruelty and
 abomination than any other sort of error in the world." 
        - H. G. Wells

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
