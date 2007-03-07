Return-Path: <linux-kernel-owner+w=401wt.eu-S2992700AbXCGXRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992700AbXCGXRc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:17:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992716AbXCGXRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:17:32 -0500
Received: from smtp.osdl.org ([65.172.181.24]:37175 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992700AbXCGXRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:17:31 -0500
Date: Wed, 7 Mar 2007 15:16:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Hansen <hansendc@us.ibm.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: 2.6.21-rc2-mm2 hang
Message-Id: <20070307151658.bfcd90e1.akpm@linux-foundation.org>
In-Reply-To: <1173308841.868.14.camel@localhost.localdomain>
References: <20070306004408.d3f6434d.akpm@linux-foundation.org>
	<1173305536.868.8.camel@localhost.localdomain>
	<20070307221628.GD26473@linux-os.sc.intel.com>
	<1173308841.868.14.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Mar 2007 15:07:21 -0800
Dave Hansen <hansendc@us.ibm.com> wrote:

> On Wed, 2007-03-07 at 14:16 -0800, Siddha, Suresh B wrote:
> > On Wed, Mar 07, 2007 at 02:12:16PM -0800, Dave Hansen wrote:
> > > I'm seeing weird hangs running ltp on 2.6.21-rc2-mm2.  It manifests
> > > itself by the waitpid06 test in LTP hanging.  This is very, very
> > > reproducible in about 5 seconds by adding '-s wait' to the ltp command
> > > line.
> > > 
> > > I see 4 waitpid06 processes on my 4-way machine spinning in userspace.
> > > But, the weird part is that I can't ssh in once this happens, but I can
> > > log in to the console.  I've bisected it down to:
> > >         
> > >         sched-fix-idle-load-balancing-in-softirqd-context
> > 
> > This sounds like an issue in merge we recently had and 2.6.21-rc2-mm2 already
> > has a fix for this.
> > 
> > sched-fix-idle-load-balancing-in-softirqd-context-fix.patch  
> > 
> > Can you please apply both
> > sched-fix-idle-load-balancing-in-softirqd-context
> > sched-fix-idle-load-balancing-in-softirqd-context-fix.patch
> > and see if you still see this problem?
> 
> I was confused that I couldn't find this fix in my patches directory,
> but I double-checked, and realized that I was still on 2.6.21-rc2-mm1.
> I must have grabbed the wrong broken-out tarball when I started the
> bisect.  Darn.
> 
> Anyway, 2.6.21-rc2-mm2 appears to be OK.  Sorry for the false alarm.
> 

Ah, OK.  I'll undrop those three patches.

Michal, did rc2-mm2 make that weird hang go away for you?
