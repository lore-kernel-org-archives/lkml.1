Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbYFWMpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbYFWMpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 08:45:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753397AbYFWMpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 08:45:04 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3840 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYFWMpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 08:45:03 -0400
Date: Mon, 23 Jun 2008 14:43:21 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: nanosleep() uses CLOCK_MONOTONIC, should be CLOCK_REALTIME?
In-Reply-To: <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0806231438130.6791@localhost.localdomain>
References: <485E00CD.9060503@gmail.com>  <e2e108260806230134g48f5ac63mb93256e08c57b4f7@mail.gmail.com>
 <cfd18e0f0806230248g3a2ab795s63de2b96538ebdd0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 23 Jun 2008, Michael Kerrisk wrote:

> >> Is there a reason to use CLOCK_MONOTONIC, instead of CLOCK_REALTIME?  Is it
> >> intentional?  If yes, then I should document this in the man-pages.  If not,
> >> then it should be fixed.
> >
> > CLOCK_MONOTONIC works fine even if ntpd steps the clock forward or
> > backward, CLOCK_REALTIME not. So the man page should be fixed.
> 
> Thanks for your reply, but I'm not quite convinced yet.  The things
> is: the Solaris man page also says "CLOCK_REALTIME".  (Of course that
> man page may just be parroting the standard.)  Could there not be some
> reasonable semantics for a nanosleep() that was based on
> CLOCK_REALTIME?

CLOCK_MONOTONIC is optional, that's probably the reason it's not mentioned 
there. If you check the man page for clock_settime, it specifically 
mentions that pending relative timer (including nanosleep) aren't affected 
by the changed time, thus if CLOCK_MONOTONIC and CLOCK_REALTIME advance 
equally, it doesn't matter which you use for relative timer.

bye, Roman
