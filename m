Return-Path: <linux-kernel-owner+w=401wt.eu-S1754034AbZFDVTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbZFDVTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 17:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbZFDVTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 17:19:04 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60527 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbZFDVTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 17:19:03 -0400
Date: Thu, 4 Jun 2009 14:17:45 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Gary Hade <garyhade@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       mingo@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       hpa@zytor.com, x86@kernel.org, yinghai@kernel.org, lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "active" device IRQ interrruption
Message-ID: <20090604211744.GB9213@us.ibm.com>
References: <20090602193216.GC7282@us.ibm.com> <m1prdlttgz.fsf@fess.ebiederm.org> <20090603170617.GB7566@us.ibm.com> <m1oct5nhqk.fsf@fess.ebiederm.org> <20090604200437.GA9213@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090604200437.GA9213@us.ibm.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 01:04:37PM -0700, Gary Hade wrote:
> On Wed, Jun 03, 2009 at 02:13:23PM -0700, Eric W. Biederman wrote:
> > Gary Hade <garyhade@us.ibm.com> writes:
> > 
> > > Correct, after the fix was applied my testing did _not_ show
> > > the lockups that you are referring to.  I wonder if there is a
> > > chance that the root cause of those old failures and the root
> > > cause of issue that my fix addresses are the same?
> > >
> > > Can you provide the test case that demonstrated the old failure
> > > cases so I can try it on our systems?  Also, do you recall what
> > > mainline version demonstrated the old failure 
> > 
> > The irq migration has already been moved to interrupt context by the
> > time I started working on it.  And I managed to verify that there were
> > indeed problems with moving it out of interrupt context before my code
> > merged.
> > 
> > So if you want to reproduce it reduce your irq migration to the essentials.
> > Set IRQ_MOVE_PCNTXT, and always migrate the irqs from process context
> > immediately.
> > 
> > Then migrate an irq that fires at a high rate rapidly from one cpu to
> > another.
> > 
> > Right now you are insulated from most of the failures because you still
> > don't have IRQ_MOVE_PCNTXT.  So you are only really testing your new code
> > in the cpu hotunplug path.
> 
> OK, I'm confused. 
> 
> It sounds like you want me force IRQ_MOVE_PCNTXT so that I can
> test in a configuration that you say is already broken.  Why
> in the heck would this config, where you expect lockups without 
> the fix, be a productive environment in which to test the fix?  

Sorry, I did not say this well.  Trying again:

Why would this config, where you already expect lockups
for reasons that you say are not addressed by the fix, be
a productive environment in which to test the fix?

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
