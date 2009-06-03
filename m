Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbZFCRGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbZFCRGd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 13:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZFCRGY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 13:06:24 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56204 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058AbZFCRGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 13:06:24 -0400
Date: Wed, 3 Jun 2009 10:06:17 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@elte.hu, mingo@redhat.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, yinghai@kernel.org, lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining
	triggered "active" device IRQ interrruption
Message-ID: <20090603170617.GB7566@us.ibm.com>
References: <20090602193216.GC7282@us.ibm.com> <m1prdlttgz.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1prdlttgz.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 03, 2009 at 05:03:24AM -0700, Eric W. Biederman wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
> 
> > Impact: Eliminates an issue that can leave the system in an
> >         unusable state.
> >
> > This patch addresses an issue where device generated IRQs
> > are no longer seen by the kernel following IRQ affinity
> > migration while the device is generating IRQs at a high rate.
> >
> > I have been able to consistently reproduce the problem on
> > some of our systems by running the following script (VICTIM_IRQ
> > specifies the IRQ for the aic94xx device) while a single instance
> > of the command
> >   # while true; do find / -exec file {} \;; done
> > is keeping the filesystem activity and IRQ rate reasonably high.
> 
> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Again you are attempt to work around the fact that fixup_irqs
> is broken.
> 
> fixup_irqs is what needs to be fixed to call these functions properly.
> 
> We have several intense debug sessions by various people including
> myself that show that your delayed_irq_move function will simply not
> work reliably.
> 
> Frankly simply looking at it gives me the screaming heebie jeebies.
> 
> The fact you can't reproduce the old failure cases which demonstrated
> themselves as lockups in the ioapic state machines gives me no
> confidence in your testing of this code.

Correct, after the fix was applied my testing did _not_ show
the lockups that you are referring to.  I wonder if there is a
chance that the root cause of those old failures and the root
cause of issue that my fix addresses are the same?

Can you provide the test case that demonstrated the old failure
cases so I can try it on our systems?  Also, do you recall what
mainline version demonstrated the old failure cases?

Thanks,
Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
