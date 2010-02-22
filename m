Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab0BVTUO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:20:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51899 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab0BVTUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:20:12 -0500
Date: Mon, 22 Feb 2010 20:20:09 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Rabin Vincent <rabin@rab.in>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>
Subject: Re: [PATCH 02/10] ARM: ftrace: document mcount formats
Message-ID: <20100222192009.GA13527@pengutronix.de>
References: <1266090518-31120-1-git-send-email-rabin@rab.in> <1266090518-31120-3-git-send-email-rabin@rab.in> <20100213203748.GC16528@pengutronix.de> <20100222180624.GA4061@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100222180624.GA4061@debian>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 11:36:24PM +0530, Rabin Vincent wrote:
> On Sat, Feb 13, 2010 at 09:37:48PM +0100, Uwe Kleine-König wrote:
> > On Sun, Feb 14, 2010 at 01:18:30AM +0530, Rabin Vincent wrote:
> > > + * With both the mcount types, we need to restore the original lr before
> > > + * returning.  In the __gnu_mcount_nc, version we're allowed to clobber ip.
> > > + * No other registers should be clobbered.
> > > + */
> > Very nice.
> > 
> > Maybe make the last two sentences:
> > 
> > In the __gnu_mcount_nc case the ip register is clobbered which is OK as
> > the calling convention for ARM allow clobbering this value for
> > subroutines and it doesn't contain parameters.
> 
> Won't quoting calling conventions here be misleading?  The mcounts don't
> following normal convention for the other bits (we can't clobber even
> the registers that are normally caller-saved, we need to restore lr,
> etc.)
actually mcount is a function in the middle of a function call.  So it
must be transparent for both the caller and the callee.  As the called
function needs to know the return address, mcount must not clobber it.
And as ip is don't care and can be clobbered mcount can use it as it
likes.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
