Return-Path: <linux-kernel-owner+w=401wt.eu-S1756738AbZBZNp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738AbZBZNp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 08:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbZBZNps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 08:45:48 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33981 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752454AbZBZNps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 08:45:48 -0500
Date: Thu, 26 Feb 2009 14:45:44 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] make CALLER_ADDRx overwriteable
Message-ID: <20090226134544.GA7110@pengutronix.de>
References: <1235600169-26912-1-git-send-email-u.kleine-koenig@pengutronix.de> <20090226050806.GB25589@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090226050806.GB25589@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Thu, Feb 26, 2009 at 12:08:06AM -0500, Steven Rostedt wrote:
> On Wed, Feb 25, 2009 at 11:16:09PM +0100, Uwe Kleine-K??nig wrote:
> > The current definition of CALLER_ADDRx isn't suitable for all platforms.
> > E.g. for ARM __builtin_return_address(N) doesn't work for N > 0 and
> > AFAIK for powerpc there are no frame pointers needed to have a working
> > __builtin_return_address.  This patch allows defining the CALLER_ADDRx
> > macros in <asm/ftrace.h> and let these take precedence.
> > 
> > Signed-off-by: Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>
>
> Ah, but unfortunately this will break other archs :-(
> 
> They may not use FTRACE, but they do include the ftrace header (the
> ftrace.h header can be used for other types of tracing, not just
> function tracing).
Then that's from generic files, because the archs that don't have
<asm/ftrace.h> don't include <linus/ftrace.h> under arch/.

> A better solution would be to move the CALLER_ADDER0 out of the
> ftrace.h header completely. Not sure where though. Have a caller.h ?
> And then we can have ftrace.h include caller.h. A asm/caller.h can be
> used to override the default.
Well, but then every arch needs this file.  I don't see an advantage
here.  So I'd favour to add an empty ftrace.h for the relevant archs.

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
