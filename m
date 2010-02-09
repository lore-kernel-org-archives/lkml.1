Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754252Ab0BIWNw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:13:52 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:48077 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab0BIWNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:13:50 -0500
Date: Tue, 9 Feb 2010 23:13:49 +0100
From: Andreas Mohr <andi@lisas.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, John Stultz <johnstul@us.ibm.com>
Subject: Re: clocksource mutex deadlock, cat current_clocksource
	(2.6.33-rc6/7)
Message-ID: <20100209221349.GA19683@rhlx01.hs-esslingen.de>
References: <20100208053830.GA7128@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081010330.2811@localhost.localdomain> <20100208093719.GA15428@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002081038430.2811@localhost.localdomain> <20100208194734.GA20316@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002082117210.2811@localhost.localdomain> <alpine.LFD.2.00.1002082139360.2811@localhost.localdomain> <20100208205105.GA16990@rhlx01.hs-esslingen.de> <20100208210219.GA22039@rhlx01.hs-esslingen.de> <alpine.LFD.2.00.1002091034500.2811@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1002091034500.2811@localhost.localdomain>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 09, 2010 at 11:02:02AM +0100, Thomas Gleixner wrote:
> Just verified, that there is no timekeeping related patch after
> 2.6.33-rc4 except the kgdb lockup prevention patch, which is
> not touching any code which is relevant  at boot time.
> 
> So bisecting between rc4 and now is probably the best thing to do.

Despairing is the best thing to do methinks.

-rc5 gcc 4.4 new .config: acpi_pm lockup
-rc4 gcc 4.4 new .config: reboot (directly after unpacking kernel)
-rc4 gcc 4.4 old (trusted) .config: reboot!! (dito)
-rc4 gcc 4.3 old (trusted) .config: reboot!!! (dito)

I'm currently zeroing in on the libgcc1 upgrade that I did on
2010-02-04 (which also made gcc-4.4 the default system compiler).
I don't have any friggin' idea what else could have caused this.

gcc 4.3 has been configured using CC=gcc-4.3 HOSTCC=gcc-4.3
, but as said, this also failed.

Andreas Mohr
