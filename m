Return-Path: <linux-kernel-owner+w=401wt.eu-S1754039AbZDVAF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbZDVAF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbZDVAFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:05:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60296 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbZDVAFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:05:18 -0400
Subject: Re: [RFC][PATCH] Dynamic Tick: Allow 32-bit machines to sleep for
 more than 2.15 seconds
From: john stultz <johnstul@us.ibm.com>
To: Jon Hunter <jon-hunter@ti.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49EE54B4.9020700@ti.com>
References: <49ECE615.2010800@ti.com>  <20090421063523.GA8020@elte.hu>
	 <1240345936.6080.6.camel@localhost>  <49EE54B4.9020700@ti.com>
Content-Type: text/plain
Date: Tue, 21 Apr 2009 17:05:15 -0700
Message-Id: <1240358715.6080.42.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-21 at 18:20 -0500, Jon Hunter wrote:
> john stultz wrote:
> > The concern is many clocksources wrap after a handful of seconds. The
> > acpi_pm is the best example (its only 24 bits wide). 
> > 
> > I brought this issue up earlier, and provided some example code that
> > could be used to limit the idle time appropriately for the current
> > clocksource here:
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0901.3/02693.html
> > 
> > Jon: Did you see that mail, or is there a reason you didn't adapt this
> > code into your patch? 
> 
> Hi John, yes I did read this email and thanks for bringing this up.
> 
> As I looked at this more I noticed that for 64-bit machines that the 
> max_delta_ns would be a 64-bit integer already and so this change would 
> only have an impact for 32-bit machines. I understand that there are 
> more 32-bit machines that 64-bit. However, I was trying to understand 
> how the wrapping of clocksources, such as the one you mention above, is 
> handled today for 64-bit machines that could theoretically sleep for 
> longer periods.

One other minor comment nit, if we're really meaning that max_delta_ns
is a 64bit value, should we not just be using s64 and be explicit
instead of converting longs to long longs?

thanks
-john


