Return-Path: <linux-kernel-owner+w=401wt.eu-S1764999AbXHFPzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764999AbXHFPzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 11:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753009AbXHFPzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 11:55:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:34714 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbXHFPzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 11:55:11 -0400
Subject: Re: [PATCH] msleep() with hrtimers
From: Arjan van de Ven <arjan@infradead.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.64.0708061159370.1817@scrub.home>
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
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 06 Aug 2007 08:53:41 -0700
Message-Id: <1186415621.2706.4.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-2.fc7) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-06 at 12:03 +0200, Roman Zippel wrote:
> Hi,
> 
> On Sun, 5 Aug 2007, Arjan van de Ven wrote:
> 
> > > There's no problem to provide a high resolution sleep, but there is also 
> > > no reason to mess with msleep, don't fix what ain't broken...
> > 
> > John Corbet provided the patch because he had a problem with the current
> > msleep... in that it didn't provide as good a common case as he
> > wanted... so I think your statement is wrong ;)
> 
> Only under the assumptation, that msleep _must_ be "fixed" for all other 
> current users too.
> Give users a choice to use msleep or nanosleep, how do you know what's 
> "best" for them?

do you have any actual technical objections, or do you just hate
hrtimers in general?

I really don't see what you hate so much about making the msleep()
implementation provide a more precise (typical sleep time of 1msec
rather than 20msec) behavior than the current one. Trying to distract
that by proposing a very different API (working on a totally different
time unit, while a lot of kernel users are using miliseconds; don't get
me wrong, a usleep() and nsleep() might be useful if there's users that
want to sleep in such times) is just trying to distract the issue.

So, let me ask a direct question: What do you think is specifically
wrong about changing the msleep() implementation as is done here? The
behavior is clearly an improvement, so what is your objection on the
flipside?

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

