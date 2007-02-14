Return-Path: <linux-kernel-owner+w=401wt.eu-S932134AbXBNG7L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbXBNG7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 01:59:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbXBNG7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 01:59:10 -0500
Received: from styx.suse.cz ([82.119.242.94]:49560 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751504AbXBNG7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 01:59:09 -0500
Date: Wed, 14 Feb 2007 07:59:05 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Andrea Arcangeli <andrea@suse.de>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
       linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Message-ID: <20070214065905.GA10887@suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <1171348808.12771.19.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com> <200702131820.15180.ak@suse.de> <20070213221848.GF9189@suse.cz> <20070213223833.GB7615@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070213223833.GB7615@v2.random>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 11:38:33PM +0100, Andrea Arcangeli wrote:
> Hi,
> 
> On Tue, Feb 13, 2007 at 11:18:48PM +0100, Vojtech Pavlik wrote:
> > It's not inherent to ntpd's design, but the current (which may have been
> > fixed since I looked last) implementation of the NTP PLL in the kernel.
> > 
> > The interaction with ntpd can be fixed and I've done it in the past
> > once, although the fix wasn't all that nice.
> 
> Yep, it can slowly move towards the correct time, but ntpdate (or more
> generally settimeofday) remains a fundamental issue (and I prefer time
> skews to be fixed ASAP, not slowly).

Skipping forward is trivial. For going backward, you can stop time (or
make it go forward very slowly). Still the output will be strictly
monotonic (but not more than that).

For small changes you simply change your estimate of the base clock
frequency to be different from what the specs say. Tuning that in a PLL
will get you to sync with true atomic GMT.

-- 
Vojtech Pavlik
Director SuSE Labs
