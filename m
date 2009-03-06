Return-Path: <linux-kernel-owner+w=401wt.eu-S1754596AbZCFDN7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbZCFDN7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 22:13:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZCFDNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 22:13:49 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:57053 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbZCFDNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 22:13:48 -0500
Subject: Re: Linux 2.6.29-rc6
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesper Krogh <jesper@krogh.cc>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>
In-Reply-To: <20090305084338.GA16026@elte.hu>
References: <1236029277.7756.0.camel@localhost.localdomain>
	 <49ACC853.8070205@krogh.cc> <1236110026.6068.18.camel@localhost>
	 <49AD90E2.7050209@krogh.cc> <1236118969.6068.87.camel@localhost>
	 <49AE9EA4.2080500@krogh.cc> <49AECA3B.5030503@krogh.cc>
	 <1236193075.3793.63.camel@jstultz-laptop>
	 <1236220759.6863.7.camel@localhost.localdomain>
	 <1236221530.6863.9.camel@localhost.localdomain>
	 <20090305084338.GA16026@elte.hu>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 19:13:36 -0800
Message-Id: <1236309216.7766.248.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 09:43 +0100, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > > Ingo, Thomas: On the hardware I'm testing the fast-pit 
> > > calibration only triggers probably 80-90% of the time. About 
> > > 10-20% of the time, the initial check to 
> > > pit_expect_msb(0xff) fails (count=0), so we may need to look 
> > > more at this approach.
> 
> We definitely need to improve calibration quality.
> 
> The question is - why does fast-calibration fail 10-20% of the 
> time on your test-system? Also, why exactly do we miscalibrate? 
> Could you please have a look at that?

Working on it, I just wanted to let you know I was seeing some different
odd behavior then Jesper.

> One theory would be that the PIT readout is unreliable. Windows 
> does not make use of it, so it's not the most tested aspect of 
> the PIT. Is that what happens on your box?

Still looking into it, but from my initial debugging it seems that by
reading the PIT very quickly after setting it, we may be getting junk
values. If I re-read the PIT again, I see the expected 0xff value. 

Its been somewhat of a heisenbug, as if I add any printk's or even just
a mb() after the outb it seems to make the problem go away (or just rare
enough I don't have the patience to reproduce it :)

So I don't know if a small delay is appropriate here (seems counter
productive to the whole fast-pit calibration ;) or if we should just try
to catch these bad reads and try again before failing?

Thoughts?

thanks
-john


