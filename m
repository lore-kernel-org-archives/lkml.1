Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYCUJ3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYCUJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 05:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944AbYCUJ3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 05:29:11 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:51752 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817AbYCUJ3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 05:29:09 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47E37F86.2080804@s5r6.in-berlin.de>
Date: Fri, 21 Mar 2008 10:27:34 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       David Brownell <david-b@pacbell.net>,
       Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Geert Uytterhoeven <geert@linux-m68k.org>,
       netdev@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>, linux-usb@vger.kernel.org,
       linux-wireless@vger.kernel.org, video4linux-list@redhat.com,
       lm-sensors@lm-sensors.org
Subject: Re: use of preempt_count instead of in_atomic() at leds-gpio.c
References: <20080316184349.GA28543@khazad-dum.debian.net>	<200803161246.23909.david-b@pacbell.net>	<20080318001429.896acf51.akpm@linux-foundation.org>	<20080320225612.GB20788@khazad-dum.debian.net>	<20080320164741.734e838c.akpm@linux-foundation.org>	<20080321003604.GC20788@khazad-dum.debian.net> <20080320180802.426ad2d1.akpm@linux-foundation.org> <47E37E04.3080303@s5r6.in-berlin.de>
In-Reply-To: <47E37E04.3080303@s5r6.in-berlin.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote:
> Andrew Morton wrote:
>> ./drivers/ieee1394/ieee1394_transactions.c
>>
>>   Possibly buggy: deadlockable
> 
> That's in hpsb_get_tlabel(), an exported symbol of the ieee1394 core.
> 
> The in_atomic() there didn't cause problems yet and is unlikely to do so 
> in the future, because there are no plans for substantial changes to the 
> whole drivers/ieee1394/ anymore (because of drivers/firewire/).
> 
> Nevertheless I shall look into replacing the in_atomic() by in_softirq() 
> or something like that.

Or extend the API to have separate calls for callers which can sleep and 
callers which can't.  But that may be thwarted by deep call chains.

> Touching this legacy code is dangerous though.
-- 
Stefan Richter
-=====-==--- --== =-=-=
http://arcgraph.de/sr/
