Return-Path: <linux-kernel-owner+w=401wt.eu-S1751677AbXLAHob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbXLAHob (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 02:44:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbXLAHoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 02:44:17 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58608 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019AbXLAHoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 02:44:17 -0500
Date: Sat, 1 Dec 2007 08:44:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Brownell <david-b@pacbell.net>
Cc: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.24-rc3] rtc-cmos alarm acts as oneshot
Message-ID: <20071201074400.GA14709@elte.hu>
References: <200711301418.24033.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711301418.24033.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Brownell <david-b@pacbell.net> wrote:

> Start making the rtc-cmos alarm act more like a oneshot alarm by 
> disabling that alarm after its IRQ fires.  (ACPI hooks are also 
> needed.)
> 
> The Linux RTC framework has previously been a bit vague in this area, 
> but any other behavior is problematic and not very portable.  RTCs 
> with full YYYY-MM-DD HH:MM[:SS] alarms won't have a problem here.  
> Only ones with partial match criteria, with the most visible example 
> being the PC RTC, get confused.  (Because the criteria will match 
> repeatedly.)
> 
> Update comments relating to that oneshot behavior and timezone 
> handling. (Timezones are another issue that's mostly visible with 
> rtc-cmos.  That's because PCs often dual-boot MS-Windows, which likes 
> its RTC to match local wall-clock time instead of UTC.)

Cool. I'm still wondering about:

  http://bugzilla.kernel.org/show_bug.cgi?id=7014

basically, we had universally working /dev/rtc before, now it appears we 
dont have it anymore. Or were the problems in this bugzilla present with 
the old code too?

	Ingo
