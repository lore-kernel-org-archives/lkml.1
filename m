Return-Path: <linux-kernel-owner+w=401wt.eu-S1753508AbXCSVwx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbXCSVwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 17:52:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030587AbXCSVka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 17:40:30 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48919 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965042AbXCSVk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 17:40:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Subject: Re: Suspend to RAM doesn't work anymore in 2.6.21
Date: Mon, 19 Mar 2007 22:43:20 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200703191350.44105.tobias.doerffel@gmail.com>
In-Reply-To: <200703191350.44105.tobias.doerffel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703192243.20836.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday, 19 March 2007 13:50, Tobias Doerffel wrote:
> Hi,
> 
> Suspend to RAM used to work fine on my computer (Intel Core Duo, 1 GB RAM, 
> Intel 82801G (ICH7-chipset) mainboard, NVIDIA-gfx-card, tg3-ethernet) up to 
> 2.6.20.3. But no matter which rc of 2.6.21 I use, suspend to RAM doesn't work 
> anymore. Up to rc3 even suspending stopped at "suspending console" which 
> appearently seems to be fixed in rc4. I tried rc4-git4 with minimal config 
> (no dyndicks, no HRT, no MSI, no sound, no bluetooth, no PCMCIA, no WLAN, no 
> USB, no cpufreq) but still I can't resume properly. Caps works and I can 
> login through SSH. Back to a more complete config (sound, MMC, WLAN, PCMCIA - 
> still no dynticks or HRT - see attachment "config") I get exactly the same 
> behaviour.
> 
> When logged in through SSH after resume I saved output of dmesg (which 
> includes full power management debug messages), see 
> attachement "dmesg-resume". The system basically seems to be back but lot of 
> things do not work such as loading/unloading e.g. my WLAN-driver (ipw3945), 
> running "top" or "dstat" etc.   "uptime" always returns 0 min, even with 
> power management debug disabled.
> 
> Kernel:
> Linux version 2.6.21-rc4 (gcc version 4.1.2 20061115 (prerelease) (Debian 
> 4.1.1-21)) #23 SMP PREEMPT Mon Mar 19 12:27:56 CET 2007

Can you please do

# echo test > /sys/power/disk
# echo disk > /sys/power/state

(the system should freeze tasks, suspend devices, disable nonboot CPUs,
wait for 5 seconds, enable nonboot CPUs, resume devices, thaw tasks and return
to your command prompt) and see if you can reproduce the problem?

Greetings,
Rafael


-- 
If you don't have the time to read,
you don't have the time or the tools to write.
		- Stephen King
