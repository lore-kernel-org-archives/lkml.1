Return-Path: <linux-kernel-owner+w=401wt.eu-S1753167AbZIPL10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167AbZIPL10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:27:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZIPL1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:27:25 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:7053 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162AbZIPL1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:27:24 -0400
X-Trace: 259362144/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.7.143/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.7.143
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAGJosEpPRQeP/2dsb2JhbACBU9t2hBcF
X-IronPort-AV: E=Sophos;i="4.44,397,1249254000"; 
   d="scan'208";a="259362144"
Date: Wed, 16 Sep 2009 12:26:36 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Wu Fengguang <fengguang.wu@intel.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Ingo Molnar <mingo@elte.hu>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-m68k@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH 0/3] /proc/kmem cleanups and hwpoison bits
In-Reply-To: <10f740e80909160201l4834369s75e63fe8df0991aa@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0909161211100.12659@sister.anvils>
References: <20090915021851.168285585@intel.com> 
 <20090915120939.bcc571e1.kamezawa.hiroyu@jp.fujitsu.com> 
 <20090915082200.GA2588@localhost>  <Pine.LNX.4.64.0909151057020.26095@sister.anvils>
 <10f740e80909160201l4834369s75e63fe8df0991aa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323584-1472666607-1253100396=:12659"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323584-1472666607-1253100396=:12659
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 16 Sep 2009, Geert Uytterhoeven wrote:
> On Tue, Sep 15, 2009 at 12:16, Hugh Dickins <hugh.dickins@tiscali.co.uk> =
wrote:
> > Warning: it may be rubbish, it may just be a hack which appeared to
> > work for me the last time I tried, on a particular address range of a
> > particular set of configurations of a particular set of architectures
> > (x86_32, x86_64, powerpc64). =C2=A0I've never thought it through enough=
 to
> > consider submitting, but it _might_ contain something useful for you
> > to factor into your own efforts.
> >
> > Sorry for chucking it over the wall to you in this way, but I guess
> > that's better than just sitting quietly on it for a few more years.
> >
> > Certainly-Not-Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

I think that gives a good idea of the status of this patch:
I'm not making any policy decisions here or submitting to any tree.

> > --- 2.6.31/drivers/char/mem.c =C2=A0 2009-09-09 23:13:59.000000000 +010=
0
> > +++ 2.6.31d/drivers/char/mem.c =C2=A02009-09-10 09:38:30.000000000 +010=
0
>=20
> > -#ifdef __ARCH_HAS_NO_PAGE_ZERO_MAPPED
> > - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* we don't have pag=
e 0 mapped on sparc and m68k.. */
>=20
> Is this `feature' removed?

The feature that some arches don't have page zero mapped?
No, I could hardly change that from drivers/char/mem.c,
and wouldn't wish to.

The feature that reading from one unmapped page gave zeroes
and writing to it threw away what you wrote?  Yes, in making
that patch, I was thinking that if we cope with unmapped areas
elsewhere by returning -ENXIO, it made little sense to have
special code to do something different for page zero.

But of course there might be userspace compatibility reasons
why that couldn't change e.g. a body of /dev/kmem users who
would be surprised by an error right at the "start" (though
in kmem's case, they've already had to seek to get anywhere).

Take the patch as saying "hmm, I wonder if we could do it this way".

Hugh
--8323584-1472666607-1253100396=:12659--
