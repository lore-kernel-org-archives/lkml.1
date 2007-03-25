Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXCYJKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXCYJKI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 05:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933265AbXCYJKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 05:10:08 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37039 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933262AbXCYJKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 05:10:06 -0400
Date: Sun, 25 Mar 2007 01:09:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid time_offset overflows
Message-Id: <20070325010903.a0e6e624.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0703240153220.14457@scrub.home>
References: <1174696834.5690.14.camel@localhost.localdomain>
	<Pine.LNX.4.64.0703240153220.14457@scrub.home>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Mar 2007 06:20:45 +0100 (CET) Roman Zippel <zippel@linux-m68k.org> wrote:

> Hi,
> 
> On Fri, 23 Mar 2007, john stultz wrote:
> 
> > @@ -314,8 +314,8 @@ #endif
> >  		    freq_adj += time_freq;
> >  		    freq_adj = min(freq_adj, (s64)MAXFREQ_NSEC);
> >  		    time_freq = max(freq_adj, (s64)-MAXFREQ_NSEC);
> > -		    time_offset = (time_offset / NTP_INTERVAL_FREQ)
> > -		    			<< SHIFT_UPDATE;
> > +		    do_div(time_offset, NTP_INTERVAL_FREQ);
> > +		    time_offset <<= SHIFT_UPDATE;
> >  		} /* STA_PLL */
> >  	    } /* txc->modes & ADJ_OFFSET */
> >  	    if (txc->modes & ADJ_TICK)
> 
> This is wrong, time_offset is signed and do_div is unsigned.
> In general I planned to do the same change, but the do_div API could use a 
> little cleanup to provide some clear function for signed/unsigned divide 
> (hopefully with a better name than div_long_long_rem_signed or 
> do_div_llr).
> 

Can we do a minimal thing for 2.6.21, worry about API beautification later?
