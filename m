Return-Path: <linux-kernel-owner+w=401wt.eu-S1755671AbZHYSOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755671AbZHYSOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 14:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755519AbZHYSOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 14:14:32 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:35763 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbZHYSOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 14:14:32 -0400
Subject: Re: [bisected] 2.6.31 regression: fails to boot as xen guest
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Arnd Hannemann <hannemann@nets.rwth-aachen.de>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A94283C.6000405@goop.org>
References: <4A9407B1.6020400@nets.rwth-aachen.de>
	 <84144f020908250929t7d4a74f1n4827de04e5c4c56a@mail.gmail.com>
	 <4A94161A.2020609@nets.rwth-aachen.de>
	 <1251219129.4852.1.camel@penberg-laptop>  <4A94283C.6000405@goop.org>
Date: Tue, 25 Aug 2009 21:14:32 +0300
Message-Id: <1251224072.13451.10.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-25 at 11:06 -0700, Jeremy Fitzhardinge wrote:
> On 08/25/09 09:52, Pekka Enberg wrote:
> > Hi Arnd,
> >
> > On Tue, 2009-08-25 at 18:49 +0200, Arnd Hannemann wrote:
> >   
> >>> Thanks for doing the bisect! Can we also see your .config also?
> >>>       
> >> Config for -rc7 is attached. My bisect configs were based on that
> >>     
> > Thanks! While we wait for the Xen people, you can try the following
> > patch to see if we can narrow the bug down to trap_init().
> >   
> 
> I think there's a problem that the side-effect of this change is that
> interrupt initialization comes later, and so the dynamically allocated
> arrays are not set up when the first interrupt comes in.

Which interrupt initialization is that? We call trap_init() _earlier_
now.

> However, this particular change shouldn't have any effect on interrupts
> being enabled early, right?

Yeah, interrupt enabling should not be affected.

			Pekka

