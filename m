Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbYKTSnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbYKTSnc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 13:43:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbYKTSnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 13:43:20 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:3955 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYKTSnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 13:43:19 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Date: Thu, 20 Nov 2008 10:43:10 -0800
From: "Matt Carlson" <mcarlson@broadcom.com>
To: "Willy Tarreau" <w@1wt.eu>
cc: "Matthew Carlson" <mcarlson@broadcom.com>,
       "Roger Heflin" <rogerheflin@gmail.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: WARNING: at net/sched/sch_generic.c:219
 dev_watchdog+0xfe/0x17e() with tg3 network
Message-ID: <20081120184310.GB27712@xw6200.broadcom.net>
References: <491954E1.2050002@gmail.com>
 <1226403067.7685.1598.camel@twins> <491E49AA.60407@gmail.com>
 <20081118065006.GC24654@1wt.eu>
 <20081120031101.GD26448@xw6200.broadcom.net>
 <20081120053746.GB15168@1wt.eu>
MIME-Version: 1.0
In-Reply-To: <20081120053746.GB15168@1wt.eu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Nov 2008 18:43:10.0696 (UTC)
 FILETIME=[D649E680:01C94B3F]
X-WSS-ID: 653B704A37G19112460-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2008 at 09:37:47PM -0800, Willy Tarreau wrote:
> Hello Matt,
> 
> On Wed, Nov 19, 2008 at 07:11:01PM -0800, Matt Carlson wrote:
> > > My tg3 is just PCI-based, no PCIe in this beast. I can send more
> > > info when I turn it on. I don't think that the tg3 driver changes
> > > often, so most likely digging through the changes between 2.6.25
> > > and 2.6.27 should not take much time. I just don't know if I can
> > > reliably reproduce the issue right now.
> > 
> > Willy, this problem description sounds a little different than the
> > original report.  There was a bug where the driver would wait 2.5
> > seconds for a firmware event that would never get serviced.  That
> > fix has already landed in the 2.6.27 tree though.
> > 
> > I glanced over the changes between 2.6.25 and 2.6.27.6.  There are quite
> > a few changes related to phylib support for an upcoming device, but not
> > so many changes that affect older devices.  What device are you using?
> 
> I think it's a 5704, but I will check this this morning when I'm at
> work. I also want to try to reliably reproduce the problem. After
> that, I see only 29 patches which differ from the two kernels, it
> should be pretty easy to spot the culprit.

O.K.  Let me know how it goes.

Could we clarify something though?  In your previous email, you said you
didn't have any problems on pre-2.6.25 kernels.  I'm wondering if the
problem goes back further than 2.6.25.  From 2.6.24 to 2.6.25, there was a
significant set of flow control changes that took place.  I suspect that
might have something to do with Roger's problem, and it may have
something to do with your problem too.  So, is it true that 2.6.25 works
for you?  If not, can you try disabling flow control and see if that
helps?

> If you think it's a different bug than original report (though I
> really thought it was the same), I'll post my findings in a separate
> thread not to mix investigations.

Right now, I think it is premature to say, so let's continue as if they
were the same problem.  We can always break it out into a separate
discussion later.


