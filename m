Return-Path: <linux-kernel-owner+w=401wt.eu-S1757196AbYIAUXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196AbYIAUXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 16:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYIAUXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 16:23:07 -0400
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:59050 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544AbYIAUXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 16:23:06 -0400
Message-ID: <48BC4F3A.9020608@lwfinger.net>
Date: Mon, 01 Sep 2008 15:23:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alok Kataria <akataria@vmware.com>, Michael Buesch <mb@bu3sch.de>
Subject: Re: Regression in 2.6.27 caused by commit bfc0f59
References: <48BB2116.1060904@lwfinger.net> <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de> <48BC2A03.9000104@lwfinger.net> <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de> <48BC444D.5030601@lwfinger.net> <alpine.LFD.1.10.0809012208010.3243@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0809012208010.3243@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 1 Sep 2008, Larry Finger wrote:
>> The timed sleep is as accurate as I can measure.
>>
>> I put in some test prints. The value of pm2 is zero when the else branch of
>> the "if (hpet)" is entered; however, pm1 is 15768471. When we reach the
>> do_div(tsc2, tsc1) statement, tsc2 is zero, which I think means that the two
>> calls to tsc_read_refs() are returning the same junk value.
> 
> Ok, so the pmtimer is probably detected later as unusable and disabled.
> Please check your logs for: 
> "PM-Timer had inconsistent results:"

Booting 2.6.26, the dmesg output has a line that says:

PM-Timer running at invalid rate: 200% of normal - aborting.

Amazing that it should be exactly 200%. Why is the CPU running at half 
speed when the PM-Timer rate is measured?

Larry
