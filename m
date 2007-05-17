Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbXEQW0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbXEQW0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 18:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756921AbXEQW0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 18:26:39 -0400
Received: from soda.ext.ti.com ([198.47.26.145]:59135 "EHLO soda.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756766AbXEQW0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 18:26:38 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
Date: Thu, 17 May 2007 17:24:55 -0500
Message-ID: <3B6D69C3A9EBCA4BA5DA60D913027429010259ED@dlee13.ent.ti.com>
In-Reply-To: <1179434296.12981.14.camel@chaos>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: bug seen with dynticks from CONFIG_HARDIRQS_SW_RESEND
Thread-Index: AceYwqIsCifIHhhFQhiWt+UPgMdkeQADibwg
References: <3B6D69C3A9EBCA4BA5DA60D913027429010253CD@dlee13.ent.ti.com> <1179396659.3764.40.camel@chaos> <3B6D69C3A9EBCA4BA5DA60D913027429010258E8@dlee13.ent.ti.com> <1179434296.12981.14.camel@chaos>
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
X-OriginalArrivalTime: 17 May 2007 22:24:56.0286 (UTC) FILETIME=[329A0FE0:01C798D2]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This is the original ARM dyntick stuff, right ?

Yes this is a version is not using clocksource.

> The dyntick support on your architecture is broken. Why does it fiddle
> with the timer, when the system is not idle ?

I can't yet run the test sequence on the latest kernel so I'll have to
wait to experiment.  A brief look at the new code seems to show a
similar path but I need to actually run though it to understand better.


On the irq_resend() path handle_dynamic_tick() is still called as
before.  The difference now is the handler looks like it will jump into
some generic event code in tick-common.c.  This still calls
ticker_periodic() which calls profile_tick() in and out of one-shot
mode.

It might be the path still exists or I've just not spent enough time
understanding the real flow.

Thanks for the insight and the nice code.

> This stuff should go away ASAP. A lot of ARMs are already converted to
> clock events are using the generic NOHZ implementation, which does not
> have those problems at all.

Ok. Thanks. I look forward to using that when I can.

Regards,
Richard W. 
