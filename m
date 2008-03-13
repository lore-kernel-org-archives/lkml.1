Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbYCMMBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbYCMMBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 08:01:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbYCMMAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 08:00:54 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33807 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751794AbYCMMAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 08:00:53 -0400
Date: Thu, 13 Mar 2008 12:00:51 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lg@opensource.wolfsonmicro.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: Re: [UPDATED v3][PATCH 1/7] regulator: consumer interface
Message-ID: <20080313120051.GA32729@rakim.wolfsonmicro.main>
Mail-Followup-To: David Brownell <david-b@pacbell.net>,
	Liam Girdwood <lg@opensource.wolfsonmicro.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Dmitry Baryshkov <dbaryshkov@gmail.com>
References: <1204827056.15360.147.camel@a10323.wolfsonmicro.main> <200803121452.47600.david-b@pacbell.net> <20080312235715.GA15894@opensource.wolfsonmicro.com> <200803122208.49040.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200803122208.49040.david-b@pacbell.net>
X-Cookie: Uh-oh!!  I'm having TOO MUCH FUN!!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 09:08:48PM -0800, David Brownell wrote:
> On Wednesday 12 March 2008, Mark Brown wrote:

> > Hrm.  I suspect that the documentation which Liam is currently writing
> > (together with some actual in-tree users) will help here.

> Yes, code is only one part of a balanced architecture.
> It's pretty weak at conveying any "big picture" issues,
> especially with only one underlying implementation.  If
> I can't get that picture without reviewing 100+ KBytes
> of code, then something critical is missing...

OK, that's good - from what you were saying it sounded like you had some
more fundamental objection.  Users are probably at least as important as
text documentation here since it's them that people tend to look at when
they need to look at code.  As with a lot of things the core isn't the
best thing to look at since it has to care about the things that it is
abstracting away from users.

> I've been pushing for clear explanations in part because,
> well, nobody else has.  I've come across clear needs for
> basic power switching, to manage sections of both SOCs and
> boards; and less clear needs for voltage adjustment.  I've
> been hoping some of the other folk who have looked at these
> issues would chime in.

The ability to adjust voltage is required for devices like MMC and CPU
frequency control so it needs to be implemented to at least some degree
and if we do it for everything it reduces the number of special cases to
handle.  Systems that don't need or want it can disable it by setting an
exact constraint in the platform code at which point it decays into a
safety feature.
