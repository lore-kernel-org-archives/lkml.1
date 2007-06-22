Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbXFVGK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbXFVGK5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 02:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbXFVGKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 02:10:50 -0400
Received: from pythia.bakeyournoodle.com ([203.82.209.197]:54653 "EHLO
	pythia.bakeyournoodle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbXFVGKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 02:10:49 -0400
Date: Fri, 22 Jun 2007 16:10:47 +1000
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Daniel Walker <dwalker@mvista.com>, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] clocksouce implementation for powerpc
Message-ID: <20070622061047.GW9768@bakeyournoodle.com>
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de> <20070616101637.107940593@inhelltoy.tec.linutronix.de> <1182009083.11539.369.camel@imap.mvista.com> <20070620065710.GR9768@bakeyournoodle.com> <46795B9B.2020401@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46795B9B.2020401@ru.mvista.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: tony@bakeyournoodle.com (Tony Breeds)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 08:53:47PM +0400, Sergei Shtylyov wrote:

Hi Sergei,
	Thanks for taking the time to look over my patch.

>    I guess it's been based on the prior work by John Stultz (and me too :-)?

At some level I guess so.  John did send me a patch a while ago.
 
>    If you mean the init. part, this has been already done by me -- I've 
> implemented read_persistent_clock() and got rid of xtime setting. What's 
> left is to implemet update_persistent_clock() and get rid of 
> timer_check_rtc()...

Actually I think that comment is redundant.  and should be removed
sorry.

>    Perhaps we even need to raise the rating to 300 or 400 -- according to 
> what <linux/clocksource.h> says?

Sure.
 
> >+	.flags        = CLOCK_SOURCE_IS_CONTINUOUS,
> >+	.mask         = CLOCKSOURCE_MASK(64),
> >+	.shift        = 22,
> 
>    PPC64 has issues with the fixed shift value, see:
> 
> http://patchwork.ozlabs.org/linuxppc/patch?id=11125

Thanks!
 
> >+	.mult         = 0,	/* To be filled in */
> >+	.read         = NULL,   /* To be filled in */
> >+	.settimeofday = NULL,   /* To be filled in */
> 
>    I don't quite understand why not just init them right away?  The values 
> are fixed anyways.

Well at least mult needs to be calculated at runtime, and I prefer to
have the structure near the top of the file at which stage the
read/settimeofday functions aren't defined.

Yours Tony

  linux.conf.au        http://linux.conf.au/ || http://lca2008.linux.org.au/
  Jan 28 - Feb 02 2008 The Australian Linux Technical Conference!

