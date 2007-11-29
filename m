Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbXK2SZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbXK2SZX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:25:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932224AbXK2SZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:25:07 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932068AbXK2SZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:25:05 -0500
Date: Thu, 29 Nov 2007 13:24:02 -0500
From: Dave Jones <davej@redhat.com>
To: Stefano Brivio <stefano.brivio@polimi.it>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129182402.GE12481@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <lenb@kernel.org>
References: <20071124175112.58193424@morte> <200711241948.58881.rjw@sisk.pl> <20071124194635.58f5a44b@morte> <200711242031.26134.rjw@sisk.pl> <20071129095034.24b3fc59@morte> <20071129103511.GD10577@elte.hu> <20071129174548.GC12481@redhat.com> <20071129185743.46daa8ad@morte>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129185743.46daa8ad@morte>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 06:57:43PM +0100, Stefano Brivio wrote:

 > > adjust_jiffies() always gets called on a speed transition. I'm wondering
 > > if perhaps we shouldn't do that if we're using something other than
 > > the tsc for timekeeping.
 > 
 > I gave other clocksources a try:
 > 
 > morte st3 # cat /sys/devices/system/clocksource/clocksource0/available_clocksource
 > acpi_pm pit jiffies tsc
 > 
 > Setting tsc as current clocksource:
 > morte st3 # echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource
 > [13367.729060] Time: tsc clocksource has been installed.
 > didn't fix anything. Other weirdness here: it looks like it affects my
 > typematic delay and repeat rate.

*grumble*
 
 > Setting jiffies or pit as current clocksource didn't fix anything, but at
 > least it doesn't cause anything bad.
 > 
 > Do you want me to comment out adjust_jiffies() and see what happens?
 
Just for laughs, why not.

	Dave

-- 
http://www.codemonkey.org.uk
