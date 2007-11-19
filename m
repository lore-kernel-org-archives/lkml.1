Return-Path: <linux-kernel-owner+w=401wt.eu-S1752623AbXKSUFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbXKSUFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 15:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXKSUF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 15:05:29 -0500
Received: from ms.trustica.cz ([82.208.32.68]:34975 "EHLO ms.trustica.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbXKSUF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 15:05:28 -0500
Message-ID: <4741EB91.9080000@assembler.cz>
Date: Mon, 19 Nov 2007 21:01:21 +0100
From: Rudolf Marek <r.marek@assembler.cz>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Jiri Slaby <jirislaby@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       lm-sensors@lm-sensors.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: broken suspend [Was: 2.6.24-rc2-mm1]
References: <Pine.LNX.4.44L0.0711182156330.22727-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0711182156330.22727-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,
>>> gives coretemp_cpu_callback -> coretemp_device_remove ->
>>> platform_device_unregister, so coretemp seems to be what I have and you don't.
> 
> Yes.
> 
> For the coretemp developers: coretemp_cpu_callback() needs to be more 
> careful about what it does.  During a system sleep transition (suspend, 
> hibernate, resume) it isn't possible to register or unregister a 
> device.  Attempts to register will fail and attempts to unregister will 
> block until the system sleep is over -- and for this callback that 
> means hanging.

Well I wrote the driver. Thanks for the clarification. If I recall correctly I 
looked how this part should be done from others drivers. Now while checking
what happened to the file, seems Rafael added something related.

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=8bb7844286fb8c9fce6f65d8288aeb09d03a5e0d

> It's not clear what the best way is to fix this.  Perhaps the CPU 
> notification should be sent along with a special flag indicating that 
> the CPU transition is part of a system sleep (although this seems 
> racy).  Perhaps the driver should notice when a system sleep begins, 
> and defer all CPU-change handling until after the sleep is over.

maybe it does exist?  CPU_DOWN_PREPARE ?

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/cpu-hotplug.txt;hb=HEAD

Unfortunately I'm not very familiar with this, calling the 
coretemp_device_remove from CPU_DOWN_PREPARE would help? Looking at microcode 
driver, seems it just hide sysfs interface from user.

Thanks,
Rudolf
