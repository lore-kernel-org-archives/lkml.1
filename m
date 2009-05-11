Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbZEKHmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbZEKHmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:42:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbZEKHmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:42:06 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:52640 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453AbZEKHmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:42:05 -0400
Date: Mon, 11 May 2009 09:42:03 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
cc: Michael Abbott <michael@araneidae.co.uk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <20090511093512.38ba9b70@skybase>
Message-ID: <alpine.LSU.2.00.0905110938210.667@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr> <20090510191229.71f43f3c@skybase> <alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0905110656180.6983@venus.araneidae.co.uk>
 <20090511093512.38ba9b70@skybase>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2009-05-11 09:35, Martin Schwidefsky wrote:
>> I have to confess I don't really understand the logic of what's going on 
>> here -- in particular, what does the idle process do other than account 
>> for time when the processor has nothing useful to do?  It does seem to me 
>> now that the .utime and .stime fields are now less than useful -- maybe 
>> they can be deleted now?
>
>The idle task does not just sleep, it will do "real" work, e.g. softirq
>handling for interrupts / network traffic.

With an RT kernel, SIRQ and such are separate tasks. That should also
be play a role while 0 is displayed.

>> I've always assumed that the second field of /proc/uptime was a simple 
>> measure of time not spent doing real work, in other words a crude measure 
>> of spare CPU resources.  My instrument basically uses the the two fields 
>> of this file to compute a measure of CPU loading so it can raise an alert 
>> if the CPU doesn't have enough spare (idle) capacity.
>
>But it wasn't.. the old style stime of idle is a mixture of true idle
>time and some system time.

Then I would say let's show the idle time only (but still inculde
the idle time when the CPU is halted).

