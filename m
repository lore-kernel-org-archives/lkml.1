Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYIBQLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYIBQLs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753339AbYIBQL3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:11:29 -0400
Received: from mail.vyatta.com ([216.93.170.194]:33479 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597AbYIBQL2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:11:28 -0400
X-Spam-Flag: NO
X-Spam-Score: -3.086
Date: Tue, 2 Sep 2008 09:11:26 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: forcedeth: option to disable 100Hz timer
Message-ID: <20080902091126.232ee570@extreme>
In-Reply-To: <48BC8BC8.4030308@shaw.ca>
References: <fa.zbmDQFBw5U2qR0I4VSAlvj/j2ek@ifi.uio.no>
	<48BC8BC8.4030308@shaw.ca>
Organization: Linux Foundation
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2008 18:41:44 -0600
Robert Hancock <hancockr@shaw.ca> wrote:

> Mikhail Kshevetskiy wrote:
> > On some hardware no TX done interrupts are generated, thus special
> > 100Hz timer interrupt is required to handle this situation properly.
> > Other device do not require that timer interrupt feature.
> > 
> > Patch add a "disable_timerirq" option to disable interrupt timer 
> > mentioned above. This may be extremely usefull for laptop users.
> > 
> > Mikhail Kshevetskiy
> > 
> 
> Someone (ideally NVIDIA) should really find out what hardware actually 
> requires this timer IRQ and only set the flag on those chipsets rather 
> than blindingly setting it on everything. This patch would be useful to 
> test whether a chipset does need it, however.

Some drivers run without TX done interrupts at all. It can be done, it just
requires cleaning up the ring in the start of the next transmit, and starting
a longer interval timer to cleanup leftover frames at the end of a burst.
