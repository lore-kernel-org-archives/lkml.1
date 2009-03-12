Return-Path: <linux-kernel-owner+w=401wt.eu-S1755051AbZCLErk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051AbZCLErk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 00:47:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbZCLErb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 00:47:31 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42378 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbZCLEra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 00:47:30 -0400
Subject: Re: [BUG,2.6.28,s390] Fails to boot in Hercules S/390 emulator
From: john stultz <johnstul@us.ibm.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-s390@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1236818044.7680.153.camel@localhost.localdomain>
References: <200903080230.10099.elendil@planet.nl>
	 <1236733226.6080.28.camel@localhost> <200903111703.41663.elendil@planet.nl>
	 <200903112005.38181.elendil@planet.nl>
	 <1236818044.7680.153.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 21:47:25 -0700
Message-Id: <1236833245.7680.266.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 17:34 -0700, john stultz wrote:
> I'm still a little baffled, but I figure I can try to reproduce this
> myself. So I'm working setting up hercules environment here to see if I
> can't trigger it. Any help with config or links to your environment
> would be great.

Ok. I've got this up and reproduced with the hercules emulator. 

A couple of interesting  hints:
*  The issue seems to go away if we disable NO_HZ/dynticks in
the .config

*  nohz=off does not affect the issue.

*  The issue also seems to go away if HZ is anything except 250

*  Commenting out clocksource_adjust(), which does the clock steering,
seems to avoid the issue.

*  When the problem triggers we don't seem to transfer to the TOD clock,
and the jiffies clocksource seems to be in use.

* The jiffies clocksource mult value seems to be ever increasing, again
pointing to something wrong in the clock steering.

* Reverting both 6c9bacb41c10 and 5cd1c9c5cf30 against 2.6-git did not
seem to help the issue, as originally reported. I also reverted
49b5cf34727a as well just in case, and it didn't help either.


That's about all I can get for today. I'm out of town until Monday, so
I'll start digging back into it then.

thanks
-john


