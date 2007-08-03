Return-Path: <linux-kernel-owner+w=401wt.eu-S1762216AbXHCT62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762216AbXHCT62 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:58:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbXHCT6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:58:20 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4127 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691AbXHCT6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:58:19 -0400
Date: Fri, 3 Aug 2007 21:58:42 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Arjan van de Ven <arjan@infradead.org>
cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] msleep() with hrtimers
In-Reply-To: <1186170407.3153.8.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0708032152060.1817@scrub.home>
References: <15327.1186166232@lwn.net>  <Pine.LNX.4.64.0708032116340.1817@scrub.home>
 <1186170407.3153.8.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 3 Aug 2007, Arjan van de Ven wrote:

> On Fri, 2007-08-03 at 21:19 +0200, Roman Zippel wrote:
> > Hi,
> > 
> > On Fri, 3 Aug 2007, Jonathan Corbet wrote:
> > 
> > > Most comments last time were favorable.  The one dissenter was Roman,
> > > who worries about the overhead of using hrtimers for this operation; my
> > > understanding is that he would rather see a really_msleep() function for
> > > those who actually want millisecond resolution.  I'm not sure how to
> > > characterize what the cost could be, but it can only be buried by the
> > > fact that every call sleeps for some number of milliseconds.  On my
> > > system, the several hundred total msleep() calls can't cause any real
> > > overhead, and almost all happen at initialization time.
> > 
> > The main point is still that these are two _different_ APIs for different 
> > usages, so I still prefer to add a hrsleep() instead.
> 
> 
> I would actually prefer it the other way around; call the
> not-so-accurate one "msleep_approx()" or somesuch, to make it explicit
> that the sleep is only approximate...

Actually the hrsleep() function would allow for submillisecond sleeps, 
which might be what some of the 450 users really want and they only use
msleep(1) because it's the next best thing.
A hrsleep() function is really what makes most sense from an API 
perspective.

bye, Roman
