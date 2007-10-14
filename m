Return-Path: <linux-kernel-owner+w=401wt.eu-S1764324AbXJNXlE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764324AbXJNXlE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 19:41:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753574AbXJNXky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 19:40:54 -0400
Received: from rtr.ca ([76.10.145.34]:3199 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbXJNXky (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 19:40:54 -0400
Message-ID: <4712A904.9010304@rtr.ca>
Date: Sun, 14 Oct 2007 19:40:52 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: crash@treysoft.com
Cc: Bart Samwel <bart@samwel.tk>, linux-kernel@vger.kernel.org
Subject: Re: hdparm standby timeout not working for WD raptors?
References: <71b295590710061011g3cd43317i8eff3a7dce2a188@mail.gmail.com>	 <470E7B90.5060203@rtr.ca>	 <71b295590710112207v72b9eb8aqc19e59c610f20dd@mail.gmail.com>	 <470F7705.3@rtr.ca>	 <71b295590710121519i55d3471fha16210e698094bec@mail.gmail.com>	 <47120D65.3080008@samwel.tk>	 <71b295590710141330g7a4779e5q2d6b8f50387ee971@mail.gmail.com>	 <471284A7.1060800@samwel.tk> <71b295590710141505x54ca0a8fwebfd75ab4fdf2e71@mail.gmail.com>
In-Reply-To: <71b295590710141505x54ca0a8fwebfd75ab4fdf2e71@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

1. How are you forcing the drives into standby?

2. Have you reproduced this with a stock kernel.org kernel yet?

One possibility is that these drives may be the kind that
generate a "spurious" interrupt when they spin-down via the timer,
and perhaps libata is "processing" that interrupt and sending
additional command(s) that then wake the drive up again immediately.

To rule this out, you could try using drivers/ide for a moment or two,
and see if the same problem persists with those drives.

You could also try dumping /proc/interrupts in conjunction with "hdparm -S1",
and we can compare that with a "known good" system.

Something like this:

hdparm -B255 /dev/sda
hdparm -S1 /dev/sda
cat /proc/interrupts
sleep 6
cat /proc/interrupts

Cheers
