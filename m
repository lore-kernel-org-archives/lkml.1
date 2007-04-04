Return-Path: <linux-kernel-owner+w=401wt.eu-S1751771AbXDDVab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771AbXDDVab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbXDDVab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:30:31 -0400
Received: from www.osadl.org ([213.239.205.134]:49428 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751771AbXDDVaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:30:30 -0400
Subject: Re: [PATCH] hrtimer: prevent overrun DoS in hrtimer_forward()
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Adrian Bunk <bunk@stusta.de>
Cc: Chuck Ebbert <cebbert@redhat.com>, Johannes Bauer <JohannesBauer@gmx.de>,
       linux-kernel@vger.kernel.org, schwab@suse.de,
       Stable Kernel Team <stable@kernel.org>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@osdl.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <20070404211159.GT27660@stusta.de>
References: <45F6F3A6.9060405@gmx.de> <45F7033B.2030204@redhat.com>
	 <1173817985.13341.120.camel@localhost.localdomain>
	 <1173866413.13341.154.camel@localhost.localdomain>
	 <20070404211159.GT27660@stusta.de>
Content-Type: text/plain
Date: Wed, 04 Apr 2007 23:30:48 +0200
Message-Id: <1175722249.28263.343.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-04 at 23:11 +0200, Adrian Bunk wrote:
> On Wed, Mar 14, 2007 at 11:00:12AM +0100, Thomas Gleixner wrote:
> > hrtimer_forward() does not check for the possible overflow of
> > timer->expires. This can happen on 64 bit machines with large interval
> > values and results currently in an endless loop in the softirq because
> > the expiry value becomes negative and therefor the timer is expired all
> > the time.
> > 
> > Check for this condition and set the expiry value to the max. expiry
> > time in the future.
> > 
> > The fix should be applied to stable kernel series as well.
> 
> 
> Is this relevant for 2.6.16?
> 
> I'm asking since KTIME_SEC_MAX is not used in 2.6.16, and therefore the 
> check in ktime_set() is also missing.

KTIME_SEC_MAX was introduced with commit
96dd7421a06a5bc6eb731323b95efcb2fd864854

to fix a conversion problem on 64 bit machines, which is also present in
2.6.16 AFAICT.

The patch just makes use of this constant. So you need to pull it as
well.

	tglx


