Return-Path: <linux-kernel-owner+w=401wt.eu-S1755542AbYACVmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbYACVmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:42:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752519AbYACVmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:42:25 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:45321 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752159AbYACVmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:42:24 -0500
X-Belgacom-Dynamic: yes
Date: Thu, 3 Jan 2008 22:42:22 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Andrew Dyer <amdyer@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: watchdog behaviour on close? (watchdog-api.txt)
Message-ID: <20080103214222.GB2930@infomag.infomag.iguana.be>
References: <c166aa9f0712180941o765cba7fxf31705560a51a06c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c166aa9f0712180941o765cba7fxf31705560a51a06c@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Sorry for the late response.

> Hi, I am trying to implement a watchdog driver in 2.6.23 for the i.MXL
> cpu (based off of drivers/char/watchdog/s3c2410_wdt.c).
> 
> I had a question about the api doc for the watchdog
> (Documentation/watchdog-api.txt).  Line 37 says "When the device is
> closed, the watchdog is disabled."  Later on (Line 56) it says
> "Drivers will not disable the watchdog, unless a specific magic
> character 'V' has been sent /dev/watchdog just before closing the
> file."
> 
> I would assume that from reading L37 that the driver would
> unconditionally shut down the watchdog when closing (unless
> CONFIG_WATCHDOG_NOWAYOUT or the nowayout module param is specified),
> but line 56 seems to contradict that.
> 
> Can you clarify the intended behaviour?

Line 56 describes the Magic Close feature that has been introduced by
(I believe) Jakob Oestergaard. This feature is an extra safety that was
added to make sure that if the watchdog daemon crashes the system is not
left "uncontrolled".

So what should the behaviour be:
1) when the watchdog driver is initialized it should make sure that
the watchdog driver is not running for userspace.
2) when /dev/watchdog is opened the watchdog device should start
3) the watchdog is being kept alive by pinging it
4) when /dev/watchdog is closed and the driver received the magic char "V"
(this is when you support the magic-close feature off-course) then the
watchdog device should stop.
5) if you unload the watchdog driver module then you normally stop
the watchdog device also (unless CONFIG_WATCHDOG_NOWAYOUT or the nowayout
module param is specified).

Hope this makes it clear now,
Greetings,
Wim.

