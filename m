Return-Path: <linux-kernel-owner+w=401wt.eu-S1754507AbXLJX7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbXLJX7Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 18:59:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752447AbXLJX7G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 18:59:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:52493 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbXLJX7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 18:59:05 -0500
Date: Mon, 10 Dec 2007 15:56:11 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       rjw@sisk.pl, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, Guillaume Chazarain <guichaz@yahoo.fr>
Subject: Re: 2.6.24-rc4-git5: Reported regressions from 2.6.23
Message-ID: <20071210155611.512ab381@laptopd505.fenrus.org>
In-Reply-To: <20071211003433.5cf0230d@morte>
References: <200712080340.49546.rjw@sisk.pl>
	<20071210204212.GA5502@elte.hu>
	<20071210125923.37bd2f10.akpm@linux-foundation.org>
	<20071210224508.GB27178@elte.hu>
	<20071210230425.GA641@elte.hu>
	<20071211003433.5cf0230d@morte>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 00:34:33 +0100
Stefano Brivio <stefano.brivio@polimi.it> wrote:

> On Tue, 11 Dec 2007 00:04:25 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > * Andrew Morton <akpm@linux-foundation.org> wrote:
> > > 
> > > > > what do you think? Right now i've got them queued up for
> > > > > 2.6.25 in both the scheduler-devel and the x86-devel git
> > > > > trees - but can submit them for 2.6.24 if it's better if we
> > > > > did them there. I've got no strong opinion either way.
> > > > 
> > > > printk_clock() doesn't seem terribly important but what's this
> > > > stuff about effects on udelay/mdelay?  That can be serious if
> > > > they're getting shortened.
> > > 
> > > since udelay depends on loops_per_jiffy, which is fixed up 
> > > time_cpufreq_notifier(), i dont see how it could be affected by 
> > > frequency changes. (but that's the theory - practice might be 
> > > different)
> > 
> > Stefano Brivio reported udelay()/mdelay() effects in the b43
> > driver. (and it caused driver failures for him.)
> > 
> > Stefano, could you please try to sum up your experiences with that 
> > issue? Is it reproducable, and the 5 patches i did fix it? (if yes, 
> > could you try to re-do the mdelay verifications perhaps, to make
> > sure it's not some other effect interacting here. In theory
> > sched-clock scaling has no effect on udelay behavior.)
> 
> Sorry for disappearing. Anyway, yes, those patches fixed it.
> Precision in delays isn't that good when using my crappy unstable TSC
> (mdelay(2000) causes delays between 2 and 2.9 seconds) but it's not
> depending on frequency changes anymore. So I'd say it's fixed, but
> please tell me if you want me to do any other test so as to be sure
> it is.
> 
> 
I'm still quite concerned about this in dual/quad core scenarios;
the frequency of both cores is the maximum of what linux sets each core to;
this means that if you're THIS sensitive to that there still is quite a nasty issue there.

I wonder if the various delay functions (maybe only in .25) should use the maximum observed loops_per_jiffie instead always (across cpus) to be super safe here.

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
