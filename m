Return-Path: <linux-kernel-owner+w=401wt.eu-S1756010AbXHHERR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbXHHERR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 00:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbXHHERE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 00:17:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57626 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbXHHERB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 00:17:01 -0400
Subject: Re: [PATCH] msleep() with hrtimers
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708071417200.1817@scrub.home>
References: <15327.1186166232@lwn.net>
	 <Pine.LNX.4.64.0708032116340.1817@scrub.home>
	 <1186170407.3153.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708032152060.1817@scrub.home>
	 <1186185229.3153.11.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708040345530.1817@scrub.home>
	 <1186255149.2777.3.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060150270.1817@scrub.home>
	 <1186360983.2697.8.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708060257010.1817@scrub.home>
	 <1186378798.2697.10.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708061159370.1817@scrub.home>
	 <1186415621.2706.4.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0708071417200.1817@scrub.home>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 07 Aug 2007 21:15:12 -0700
Message-Id: <1186546512.2862.3.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-08-07 at 14:45 +0200, Roman Zippel wrote:
> Hi,
> 
> On Mon, 6 Aug 2007, Arjan van de Ven wrote:
> 
> > So, let me ask a direct question: What do you think is specifically
> > wrong about changing the msleep() implementation as is done here? The
> > behavior is clearly an improvement, so what is your objection on the
> > flipside?
> 
> Again, we have two different timer APIs for a reason

yes because we have different usage patterns for timers. (exact/course
or expiring/not-typically-expiring; I know you have some other opinion
here than other people).

For this case it's relatively simple imo: The existing implementation
has a *typical* behavior which is 100% to 2000% worse than what the user
of the API asks for. And that is totally unneeded to be so crappy; it
can be much more exact easily as shown by this patch.

You keep claiming that hrtimers are so incredibly expensive; but for
msleep()... which is mostly called during driver init ... I really don't
buy that it's really expensive. We're not doing this a gazilion times
per second obviously...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

