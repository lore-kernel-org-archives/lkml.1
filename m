Return-Path: <linux-kernel-owner+w=401wt.eu-S1753355AbYATKoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355AbYATKoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 05:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752481AbYATKoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 05:44:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65367 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475AbYATKoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 05:44:02 -0500
From: Hans-Peter Jansen <hpj@urpla.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: linux device ordering at boot time
Date: Sun, 20 Jan 2008 11:43:22 +0100
User-Agent: KMail/1.9.6 (enterprise 20071221.751182)
Cc: "Lars Callenbach" <lars.callenbach@gmx.de>, linux-kernel@vger.kernel.org,
       linux-dvb@linuxtv.org
References: <20080119185520.208350@gmx.net> <200801200007.00125.hpj@urpla.net> <20080119234804.3c58c77b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080119234804.3c58c77b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200801201143.23612.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/j0gLh3vakTMENri/ZD3cFQjR5eZKZaHP25AF
 s/FYgaKF8mnYsgLUaoJswMiRXAmRhfuaN8/d8rn6eCIGoSj6gd
 M/7umvNj6lYoqxExC+LMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan, dear kernel & dvb hackers,

Am Sonntag, 20. Januar 2008 schrieb Alan Cox:
> > Well, it's a major pain in the a**. I've no idea, what reversed the
> > order of PCI devices, but I had to disable the automatic dvb driver
> > loading in order
>
> It depends on the order you load the modules

Sure, but given, that userspace didn't changed meanwhile, I relied on some 
hotplug figure before (in openSUSE 10.2 with 2.6.18) to load the modules in 
the correct order which itself surely enumerates the PCI bus in some way.

After switching to 2.6.24-rc this order was reversed. At least, my budget 
card was first now, while the ff dvb card second, which resulted in a 
working vdr, unfortunately without picture and sound (that dropped the WAF 
immensely 8-|). 

I solved this issue by blacklisting both cards in /etc/modprobe.d/blacklist, 
and manually determined the order and which modules to load, only to 
discover, that the system won't wake up on the scheduled times anymore. 
Ahh, /proc/acpi/alarm disappeared and needed adaption 
to /sys/class/rtc/rtc0/wakealarm. That move seems to have (yet to examine, 
but easy to work around) timezone issues. On the bright side, this new 
interface doesn't interfere with setting the c-mos clock on power down 
anymore. One gross hack down. Cool.

The last regressions awaiting to get tackled are:
 - rewind is somewhat broken: after a few seconds rewinding correctly, the
   pictures stutter, and vdr uses cpu like mad.
 - from time to time, the same happens for a few seconds on simple replay.

Both issues _feel_ like locking artefacts, which 2.6.18 (with 
http://linuxtv.org/hg/v4l-dvb drivers) didn't suffer from (my vdr operates 
mostly on nfs3 mounted files). I'm trying to explore these problems in more 
detail and will come back. For the record, these issues happen with the 
factory drivers/media modules and with drivers from v4l-dvb tree.

Please don't get me wrong, I'm not whining about all this, it's just a 
report from user side about what happens, if one tries to follow a strong 
moving target. Take it as a reminder, that some decisions during (kernel) 
development does have an wider impact on us poor users out there, as it 
seems.

The only thing, what makes me really sad, is that current dvb development is 
distracted by political and emotional (ego-logical) reasons, repressing  
the full potential in this area.

Pete
