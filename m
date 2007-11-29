Return-Path: <linux-kernel-owner+w=401wt.eu-S932855AbXK2UVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932855AbXK2UVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:21:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932868AbXK2UUz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:20:55 -0500
Received: from mfe1.polimi.it ([131.175.12.23]:60680 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932085AbXK2UUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:20:54 -0500
Date: Thu, 29 Nov 2007 21:12:40 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Michael Buesch <mb@bu3sch.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [BUG] jiffies counter leaps in 2.6.24-rc3
Message-ID: <20071129211240.007fb459@morte>
In-Reply-To: <20071129193624.GA15245@elte.hu>
References: <20071124175112.58193424@morte>
	<200711241948.58881.rjw@sisk.pl>
	<20071124194635.58f5a44b@morte>
	<200711242031.26134.rjw@sisk.pl>
	<20071129095034.24b3fc59@morte>
	<20071129103511.GD10577@elte.hu>
	<20071129174548.GC12481@redhat.com>
	<20071129185743.46daa8ad@morte>
	<20071129182402.GE12481@redhat.com>
	<20071129202546.7a65a13c@morte>
	<20071129193624.GA15245@elte.hu>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-PMX-Version: 5.3.3.310218, Antispam-Engine: 2.5.2.311128, Antispam-Data: 2007.11.6.30824
X-PerlMx-Spam: Gauge=II, Probability=22%, Report='RELAY_IN_PBL_11 2.5, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, RELAY_IN_PBL 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __HAS_MSGID 0, __HAS_X_MAILER 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __SANE_MSGID 0'
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007 20:36:24 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> just to make sure there is no tsc impact, does booting with "notsc" 
> change anything?

No, it doesn't.

> if not, does booting with idle=halt or idle=poll help? [your power usage 
> will go up so it's not very useful - but it could help exclude a few 
> sources of trouble.]

With idle=poll nothing changes, except that - as soon as I switch the CPU
frequency - I get this in the logs:

[  297.562722] Marking TSC unstable due to: cpufreq changes.
[  297.566677] Time: acpi_pm clocksource has been installed.

With idle=halt, changing frequency just freezes the system. I can't even use
the magic Sys Rq keys then.

I observed another thing. When I don't use any of the parameters you
suggested for debugging, I get this at boot:

[    6.530752] Marking TSC unstable due to: possible TSC halt in C2.
[    6.530761] Time: acpi_pm clocksource has been installed.
[    6.620700] Clocksource tsc unstable (delta = -456217276 ns)


-- 
Ciao
Stefano
