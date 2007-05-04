Return-Path: <linux-kernel-owner+w=401wt.eu-S964988AbXEDXk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964988AbXEDXk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 19:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964821AbXEDXkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 19:40:25 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:55420 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422863AbXEDXiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 19:38:24 -0400
Date: Sat, 5 May 2007 01:37:29 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Johnson <dj@david-web.co.uk>
cc: linux-kernel@vger.kernel.org, cpufreq@lists.linux.org.uk
Subject: Re: cpufreq longhaul locks up
In-Reply-To: <200705042320.41278.dj@david-web.co.uk>
Message-ID: <Pine.LNX.4.61.0705050132410.18504@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705041200370.18504@yvahk01.tjqt.qr>
 <200705042320.41278.dj@david-web.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 4 2007 23:20, David Johnson wrote:
>
>longhaul: VIA C3 'Nehemiah C' [C5P] CPU detected.  Powersaver supported.
>longhaul: Using ACPI support.
>
>It seems that longhaul on my system is 'using ACPI support' whereas on yours 
>it is 'using northbridge support'. I'm getting lockups after approx. 2-3 
>hours using the ondemand governor. It has no problem changing the clock 
>speed, and runs at the minimum speed most of the time.

I had tried this:

-  if (enable_arbiter_disable()) {
+  if (0 && enable_arbiter_disable()) {

to skip enabling the northbridge. Unfortunately, I do not seem to have
southbridge or ACPI support.

>I seem to recall that I get an oops when my system locks-up (the system runs 
>headless normally, so it isn't easy to check). I'll investigate.

I think I did not see any oops, though I (1) did not redirect the
kernel output back to tty0 [the distro moves it away to tty11]
so I might have missed something, but (2) netconsole did not send
anything. IIRC, the kernel still catches sysrq if it paniced, i.e.
as a result of not finding a proper root device during startup;
but no sysrq, so it seems a harder lockup. Maybe I should try
without all the modules loaded and/or disable some hw in the bios.


Jan
-- 
