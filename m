Return-Path: <linux-kernel-owner+w=401wt.eu-S1752478AbYKSWJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbYKSWJs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbYKSWJk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:09:40 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:2639 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbYKSWJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:09:39 -0500
Subject: Re: [PATCH] disable CPU side GART accesses
From: Bob Montgomery <bob.montgomery@hp.com>
Reply-To: bob.montgomery@hp.com
To: Dave Airlie <airlied@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "vojtech@suse.cz" <vojtech@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "chandru@in.ibm.com" <chandru@in.ibm.com>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <21d7e9970811031555y2e8187c5q5b8768800e176bd4@mail.gmail.com>
References: <1224107317.2215.238.camel@amd.troyhebe>
	 <20081015234842.GA10999@elte.hu>	 <1225147341.2215.401.camel@amd.troyhebe>
	 <4906495B.1060506@kernel.org>	 <1225313564.3428.14.camel@amd.troyhebe>
	 <21d7e9970810291424g369035d4h562b54c676d49aef@mail.gmail.com>
	 <20081029213244.GD24794@redhat.com>
	 <21d7e9970810291440w50d15c30o961dad801cf71548@mail.gmail.com>
	 <1225755379.3428.39.camel@amd.troyhebe>
	 <21d7e9970811031555y2e8187c5q5b8768800e176bd4@mail.gmail.com>
Content-Type: text/plain
Organization: Contractor at HP
Date: Wed, 19 Nov 2008 15:12:14 -0700
Message-Id: <1227132734.3428.142.camel@amd.troyhebe>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-03 at 23:55 +0000, Dave Airlie wrote:
> On Tue, Nov 4, 2008 at 9:36 AM, Bob Montgomery <bob.montgomery@hp.com> wrote:

> > We're specifically talking about AMD64, and we're not using an IOMMU for
> > AGP, we're using the AMD64 implementation of the GART for an IOMMU.
> > The (possible) danger is that some old AMD64 system could also (or
> > instead) try using the GART for AGP and run into a problem since my
> > patch wants to disable CPU side access to the aperture, which is fine
> > when we're using it as an IOMMU.
> >
> > In drivers/gpu/drm/drm_memory.c:agp_remap(), there are these comments
> > about the part of the code that deals with "cant_use_aperture":
> >
> > /*
> >  * OK, we're mapping AGP space on a chipset/platform on which
> >  * memory accesses by the CPU do not get remapped by the GART.
> >  * We fix this by using the kernel's page-table instead (that's
> >  * probably faster anyhow...).
> >  */
> >
> > So that's encouraging.  Now the question is this:  Can I just go into
> > amd64-agp.c and add ".cant_use_aperture=true" to the agp_bridge_driver
> > struct?  Who's brave enough to say that will just work? :-)
> 
> I have serious doubts about including such a patch without testing on
> a large range of AMD64 systems
> with a large range of distro/X servers.
> 
> Dave.

Well, since I hate it when kernel discussion threads just end with no
resolution...

I don't have access to a large range of AMD64 systems that use AGP
graphics.  In fact, I can't find any around here.  So testing my way to
resolving this potential problem in these drivers is probably not going
to work.

I've seen references to systems that had Opterons, and AGP graphics, and
could hold more than 4GB of RAM, but I don't know how many are out
there.  So since I can't do a bunch of distro/X server testing, I'm not
sure how to proceed to get as simple a fix for this problem on real
systems that do exist now.

Bob Montgomery


