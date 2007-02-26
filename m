Return-Path: <linux-kernel-owner+w=401wt.eu-S932899AbXBZXoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899AbXBZXoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 18:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932974AbXBZXoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 18:44:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38533 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932899AbXBZXoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 18:44:19 -0500
Date: Mon, 26 Feb 2007 15:44:13 -0800
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC] div64_64 support
Message-ID: <20070226154413.4ead571a@freekitty>
In-Reply-To: <Pine.LNX.4.61.0702262348140.23355@yvahk01.tjqt.qr>
References: <20070223170527.4ca695b2@freekitty>
	<Pine.LNX.4.61.0702262108010.23355@yvahk01.tjqt.qr>
	<20070226143127.5c74bec9@freekitty>
	<Pine.LNX.4.61.0702262348140.23355@yvahk01.tjqt.qr>
Organization: Linux Foundation
X-Mailer: Sylpheed-Claws 2.5.0-rc3 (GTK+ 2.10.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Feb 2007 00:02:50 +0100 (MET)
Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:

> 
> On Feb 26 2007 13:28, Stephen Hemminger wrote:
> >> 
> >> ./arch/arm26/lib/udivdi3.c
> >> ./arch/sh/lib/udivdi3.c
> >> ./arch/sparc/lib/udivdi3.S
> >> 
> >> should not this be consolidated too?
> >
> >Hmm. Those are the GCC internal versions, that are picked up but
> >doing divide in place. Do we want to allow general 64 bit in kernel to
> >be easily used? It could cause sloppy slow code, but it would look
> >cleaner.
> 
> Then our reviewers should catch it, and if not, the janitors will
> (/me winks at R.P.J.Day and trivial@).
> 
> >@@ -134,7 +112,7 @@
> > 	 */
> > 	do {
> > 		x1 = x;
> >-		x = (2 * x + (uint32_t) div64_64(a, x*x)) / 3;
> >+		x = (2 * x + (u32) (a / x*x)) / 3;
> 
> Eye see a bug.
> 
> Previously there was div64_64(a, x*x) which is equivalent to
> (a)/(x*x), or just: a/(x^2). But now you do a/x*x, which is
> equivalent to a*x/x (in the domain of real numbers). Furthermore,
> a/x*x is a-(a%x), which does not even remotely match a/(x^2).
> 
> Please keep the math intact, thank you ;-)

Been there, done that, don't want to repeat it...

-- 
Stephen Hemminger <shemminger@linux-foundation.org>
