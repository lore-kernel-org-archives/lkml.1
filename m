Return-Path: <linux-kernel-owner+w=401wt.eu-S1751890AbZIWVaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751890AbZIWVaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 17:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZIWVab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 17:30:31 -0400
Received: from gate.crashing.org ([63.228.1.57]:55522 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751206AbZIWVab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 17:30:31 -0400
Subject: Re: [regression, bisected] adb trackpad disappears after suspend
 to ram
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jan Scholz <scholz@fias.uni-frankfurt.de>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <200909231538.51227.rjw@sisk.pl>
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de>
	 <200906032200.55563.rjw@sisk.pl> <1253676745.7103.268.camel@pasglop>
	 <200909231538.51227.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 07:28:52 +1000
Message-Id: <1253741332.7103.324.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-23 at 15:38 +0200, Rafael J. Wysocki wrote:
> > This patch fixes it by using IRQF_TIMER for both the PMU and the I2C
> > interrupts. I prefer doing it this way than moving the call sites since
> > I really want those platform functions to still be called after all
> > drivers (and before sysdevs).
> 
> Alternatively, you could introduce a new flag IRQF_NOSUSPEND and use that
> instead of IRQF_TIMER.  That would be cleaner than using IRQF_TIMER for
> non-timer interrupts IMHO.

I totally agree. The current patch is still good for stable though.

I'll send it to Greg after I've upstreamed it, we can introduce IRQF_NOSUSPEND
in a second patch.

Ben.


