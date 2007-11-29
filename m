Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbXK2RrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbXK2RrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:47:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932082AbXK2RrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:47:11 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbXK2RrK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:47:10 -0500
Date: Thu, 29 Nov 2007 12:45:48 -0500
From: Dave Jones <davej@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Michael Buesch <mb@bu3sch.de>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129174548.GC12481@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Ingo Molnar <mingo@elte.hu>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
	Michael Buesch <mb@bu3sch.de>, Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <lenb@kernel.org>
References: <20071124175112.58193424@morte> <200711241948.58881.rjw@sisk.pl> <20071124194635.58f5a44b@morte> <200711242031.26134.rjw@sisk.pl> <20071129095034.24b3fc59@morte> <20071129103511.GD10577@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071129103511.GD10577@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 11:35:11AM +0100, Ingo Molnar wrote:
 
 > * Stefano Brivio <stefano.brivio@polimi.it> wrote:
 > 
 > > Ok, I found out how to reliably reproduce this bug. The root session issue
 > > was a bit weird, but I noticed I usually switch to root only when I need to
 > > change the CPU frequency. And here's what happens:
 > > 
 > > # cpuspeedy min
 > > [after some time...]
 > > Nov 29 09:42:31 morte [ 4408.722597] b43-phy0 ERROR: PHY transmission error
 > > 
 > > # cpuspeedy max
 > > Nov 29 09:42:41 morte [ 1177.238599] wmaster0: STA 00:14:c1:35:8d:eb Average rate: 540 (2160/4)
 > > 
 > > It looks like jiffies get scaled exactly by a 3.75 factor, which is
 > > <max_frequency>/<min_frequency> here. I use acpi-cpufreq and this is my
 > 
 > ah, the cpufreq/acpi/acpi-cpufreq angle is indeed a big clue. I've 
 > Cc:-ed various interested parties.
 
Hmm, what's in /sys/devices/system/clocksource/clocksource0/current_clocksource  ?

adjust_jiffies() always gets called on a speed transition. I'm wondering
if perhaps we shouldn't do that if we're using something other than
the tsc for timekeeping.

	Dave

-- 
http://www.codemonkey.org.uk
