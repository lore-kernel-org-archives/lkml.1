Return-Path: <linux-kernel-owner+w=401wt.eu-S1751338AbXBMWSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338AbXBMWSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 17:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751335AbXBMWSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 17:18:53 -0500
Received: from styx.suse.cz ([82.119.242.94]:43546 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751338AbXBMWSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 17:18:52 -0500
Date: Tue, 13 Feb 2007 23:18:48 +0100
From: Vojtech Pavlik <vojtech@suse.cz>
To: Andi Kleen <ak@suse.de>
Cc: Christoph Lameter <clameter@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>, Jiri Bohac <jbohac@suse.cz>,
       linux-kernel@vger.kernel.org, ssouhlal@freebsd.org, tglx@linutronix.de,
       johnstul@us.ibm.com, zippel@linux-m68k.org, andrea@suse.de
Subject: Re: [patch 4/9] Remove the TSC synchronization on SMP machines
Message-ID: <20070213221848.GF9189@suse.cz>
References: <20070201095952.589234000@jet.suse.cz> <1171348808.12771.19.camel@laptopd505.fenrus.org> <Pine.LNX.4.64.0702130906530.23634@schroedinger.engr.sgi.com> <200702131820.15180.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702131820.15180.ak@suse.de>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 13, 2007 at 06:20:14PM +0100, Andi Kleen wrote:
> On Tuesday 13 February 2007 18:09, Christoph Lameter wrote:
> > On Tue, 13 Feb 2007, Arjan van de Ven wrote:
> > 
> > > no quite the opposite. gettimeofday() currently is NOT monotonic
> > > unfortunately. With this patchseries it actually has a better chance of
> > > becoming that...
> > 
> > It is monotonic on IA64 at least and we have found that subtle application 
> > bugs occur if it is not. IA64 (and other arches using time interpolation) 
> > can insure the monotoneity of time sources. Are you sure about this? I 
> > wonder why the new time of day subsystem does not have that?
> 
> Just to avoid spreading misinformation: modulo some new broken hardware
> (which we always try to work around when found) i386/x86-64 gettimeofday
> is monotonic.  AFAIK on the currently known hardware it should be generally
> ok.
> 
> However ntpd can always screw you up, but that's inherent in the design.

It's not inherent to ntpd's design, but the current (which may have been
fixed since I looked last) implementation of the NTP PLL in the kernel.

The interaction with ntpd can be fixed and I've done it in the past
once, although the fix wasn't all that nice.

> Safer in general is to use clock_gettime(CLOCK_MONOTONIC, ...) which
> guarantees no interference from ntpd

-- 
Vojtech Pavlik
Director SuSE Labs
