Return-Path: <linux-kernel-owner+w=401wt.eu-S1757274AbZEVOCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274AbZEVOCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755203AbZEVOCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:02:08 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64354 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960AbZEVOCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:02:06 -0400
X-IronPort-AV: E=Sophos;i="4.41,233,1241409600"; 
   d="scan'208";a="4395655"
Subject: Re: swiotlb: remove __weak hooks in favour of
	architecture-specific functions
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: "mingo@elte.hu" <mingo@elte.hu>, "jeremy@goop.org" <jeremy@goop.org>,
       "beckyb@kernel.crashing.org" <beckyb@kernel.crashing.org>,
       "okir@suse.de" <okir@suse.de>, "gregkh@suse.de" <gregkh@suse.de>,
       "xendevel@lists.xensource.com" <xendevel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090522205533P.fujita.tomonori@lab.ntt.co.jp>
References: <1242922528-5982-1-git-send-email-ian.campbell@citrix.com>
	 <20090522201325I.fujita.tomonori@lab.ntt.co.jp>
	 <1242992596.22654.273.camel@zakaz.uk.xensource.com>
	 <20090522205533P.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: Citrix Systems, Inc.
Date: Fri, 22 May 2009 15:02:04 +0100
Message-ID: <1243000924.25553.2112.camel@localhost.localdomain>
MIME-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-22 at 07:55 -0400, FUJITA Tomonori wrote:
> On Fri, 22 May 2009 12:43:16 +0100
> Ian Campbell <Ian.Campbell@eu.citrix.com> wrote:
> 
> > On Fri, 2009-05-22 at 07:13 -0400, FUJITA Tomonori wrote:
> > > On Thu, 21 May 2009 17:15:21 +0100
> > > Ian Campbell <ian.campbell@citrix.com> wrote:
> > > Please go with the following way (that I posted yesterday):
> > > 
> > > http://marc.info/?l=xen-devel&m=124292666214380&w=2
> > > 
> > > 
> > > Export the core feature of swiotlb, managing iotlb buffer and
> > > implement the Xen mapping functions.
> > 
> > I feel that should be a last resort, before we go down that path we
> > should try and find a way for us to use the generic code in a clean way
> > which makes everyone happy.
> >
> > We have had several attempts at this and admittedly have not yet come up
> > with something that satisfies everyone but I don't really think we have
> > gotten to the point of admitting defeat and just duplicating the code.
> 
> There should not be much duplication.
> 
> 
> > I think the proposal to use a dma_map_range-like function which I sent a
> > few minutes ago I think gets us closer to something which satisfies
> > everyone's requirements, including yours for a clean abstraction.
> 
> Seems you don't understand the point; with dom0, we can't cleanly use
> arch/*/include/asm/.

I understand precisely what you are saying, I just fundamentally
disagree with you. It is perfectly possible for an arch/*/include/asm
interface for this stuff to be defined which is completely abstracted
from the POV of the swiotlb code (and any other arch-external code).

> You need to insert Xen's hook like this:

As I said in the email this snippet was contained in:
>       * The Xen specific stuff in arch/x86/include/asm/dma-mapping.h
>         clearly needs to be properly abstracted away (I just stuck it
>         there for testing).

So obviously I am well aware that it is unacceptable as it stands.

I think we can find a way to implement this functionality which is
contained entirely within the arch/x86 code and is also acceptable to
the x86 maintainers. There are plenty of cases where we define similar
interfaces where arch code implements an API with different backends for
different configurations, hardware configurations etc etc.

> See above. POWERPC can use arch/*/include/asm/ cleanly for the
> phys/bus address conversion while dom0 can't. That's what I said again
> and again.

And I dispute this claim, again and again.

Ian.

