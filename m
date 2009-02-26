Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbZBZFIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbZBZFIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 00:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbZBZFIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 00:08:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41433 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbZBZFIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 00:08:10 -0500
Date: Thu, 26 Feb 2009 00:08:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
Message-ID: <20090226050806.GB25589@goodmis.org>
References: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 11:16:09PM +0100, Uwe Kleine-K??nig wrote:
> The current definition of CALLER_ADDRx isn't suitable for all platforms.
> E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
> AFAIK for powerpc there are no frame pointers needed to have a working
> __builtin_return_address.  This patch allows defining the CALLER_ADDRx
> macros in <asm/ftrace.h> and let these take precedence.
> 
> Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> [I resent because vger blocked my mail saying: "Wrong MIME labeling on
> 8-bit character texts."  Steven didn't get it either.  I don't know
> what's wrong, so I put the patch back into git and format-patch'd it.  I
> hope this one makes it through.  Sorry if you got it twice.]
> 
> I think I don't break any architecture with this patch:
> 
> 	$ for arch in $(ls arch/); do if test ! -d arch/$arch; then continue; fi; test -f arch/$arch/include/asm/ftrace.h || test -f include/asm-$arch/ftrace.h || { echo -n "$arch: "; git grep FTRACE arch/$arch | wc -l; } done
> 	alpha: 0
> 	avr32: 0
> 	blackfin: 0
> 	cris: 0
> 	frv: 0
> 	h8300: 0
> 	m32r: 0
> 	m68k: 0
> 	m68knommu: 0
> 	mips: 0
> 	mn10300: 0
> 	parisc: 0
> 	um: 0
> 	xtensa: 0
> 
> So all archs that don't have <asm/ftrace.h> seem not to use FTRACE.

Ah, but unfortunately this will break other archs :-(

They may not use FTRACE, but they do include the ftrace header (the ftrace.h header
can be used for other types of tracing, not just function tracing).

A better solution would be to move the CALLER_ADDER0 out of the
ftrace.h header completely. Not sure where though. Have a caller.h ?
And then we can have ftrace.h include caller.h. A asm/caller.h can be
used to override the default.

How does that sound?

-- Steve
