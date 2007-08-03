Return-Path: <linux-kernel-owner+w=401wt.eu-S1763533AbXHCTsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763533AbXHCTsI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 15:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759867AbXHCTr5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 15:47:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33818 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758807AbXHCTr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 15:47:56 -0400
Subject: Re: [PATCH] msleep() with hrtimers
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708032116340.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708032116340.1817@scrub.home>
Content-Type: text/plain
Organization: Intel International BV
Date: Fri, 03 Aug 2007 12:46:46 -0700
Message-Id: <1186170407.3153.8.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-03 at 21:19 +0200, Roman Zippel wrote:
> Hi,
> 
> On Fri, 3 Aug 2007, Jonathan Corbet wrote:
> 
> > Most comments last time were favorable.  The one dissenter was Roman,
> > who worries about the overhead of using hrtimers for this operation; my
> > understanding is that he would rather see a really_msleep() function for
> > those who actually want millisecond resolution.  I'm not sure how to
> > characterize what the cost could be, but it can only be buried by the
> > fact that every call sleeps for some number of milliseconds.  On my
> > system, the several hundred total msleep() calls can't cause any real
> > overhead, and almost all happen at initialization time.
> 
> The main point is still that these are two _different_ APIs for different 
> usages, so I still prefer to add a hrsleep() instead.


I would actually prefer it the other way around; call the
not-so-accurate one "msleep_approx()" or somesuch, to make it explicit
that the sleep is only approximate...


