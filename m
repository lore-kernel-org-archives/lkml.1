Return-Path: <linux-kernel-owner+w=401wt.eu-S1763944AbXK2SF4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763944AbXK2SF4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:05:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762844AbXK2SFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:05:46 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:50890 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761575AbXK2SFo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:05:44 -0500
Date: Thu, 29 Nov 2007 18:57:43 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129185743.46daa8ad@morte>
In-Reply-To: <20071129174548.GC12481@redhat.com>
References: <20071124175112.58193424@morte>
	<200711241948.58881.rjw@sisk.pl>
	<20071124194635.58f5a44b@morte>
	<200711242031.26134.rjw@sisk.pl>
	<20071129095034.24b3fc59@morte>
	<20071129103511.GD10577@elte.hu>
	<20071129174548.GC12481@redhat.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.29.94432
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 12:45:48 -0500
Dave Jones <davej@redhat.com> wrote:

> Hmm, what's
> in /sys/devices/system/clocksource/clocksource0/current_clocksource  ?

morte st3 # cat /sys/devices/system/clocksource/clocksource0/current_clocksource
acpi_pm
 
> adjust_jiffies() always gets called on a speed transition. I'm wondering
> if perhaps we shouldn't do that if we're using something other than
> the tsc for timekeeping.

I gave other clocksources a try:

morte st3 # cat /sys/devices/system/clocksource/clocksource0/available_clocksource
acpi_pm pit jiffies tsc

Setting tsc as current clocksource:
morte st3 # echo tsc > /sys/devices/system/clocksource/clocksource0/current_clocksource
[13367.729060] Time: tsc clocksource has been installed.
didn't fix anything. Other weirdness here: it looks like it affects my
typematic delay and repeat rate.

Setting jiffies or pit as current clocksource didn't fix anything, but at
least it doesn't cause anything bad.

Do you want me to comment out adjust_jiffies() and see what happens?


-- 
Ciao
Stefano
