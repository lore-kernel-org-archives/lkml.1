Return-Path: <linux-kernel-owner+w=401wt.eu-S1754383Ab0AVLK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0AVLK0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 06:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543Ab0AVLKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 06:10:20 -0500
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:62041 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754197Ab0AVLKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 06:10:18 -0500
Subject: Re: [PATCH] kernel/timekeeping:  move xtime_cache to be in the
 same cache line as the lock
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: john stultz <johnstul@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1264094359.3253.11.camel@work-vm>
References: <1264088361.2082.45.camel@localhost>
	 <1264094359.3253.11.camel@work-vm>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 11:10:14 +0000
Message-ID: <1264158614.2143.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-21 at 09:19 -0800, john stultz wrote:

> 
> Hrm.. I'm hoping to kill off the xtime_cache at some point soon, so I'm
> not sure if this patch will do much for long. That said, I'm not opposed
> to it in the mean time, and when xtime_cache does get yanked, I'd
> appreciate similar performance review to make sure we're not regressing.
> 
OK, removing it will be even better. I can re-run the test anytime you
like, just let me know if you've got a patch that needs testing. 

> > ---
> > patch against v2.6.33-rc4
> > compiled & tested on AMD64X2 x86_64
> > 
> > 
> > BTW on 64 bit timespec is a 16 byte structure so the aligned 16 doesn't
> > do much, and on 32bit timepec is 8bytes so this just seems to spread
> > these variables across more cache lines than necessary. Any ideas what
> > this is here for?
> 
> I think it was a copy-paste from the xtime and wall_to_monotonic
> definitions, which both have the same alignment. 
Yes, that's what I thought. In that case I think we can remove all of
those attribute aligned, which should be a small improvement for 32 bit
builds.

regards
Richard



