Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZDMCFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZDMCFE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 22:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750758AbZDMCEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 22:04:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:8721 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750734AbZDMCEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 22:04:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,178,1239001200"; 
   d="scan'208";a="505872561"
Subject: Re: 2.6.30-rc1 A few issues and a stall
From: Zhang Rui <rui.zhang@intel.com>
To: Ed Tomlinson <edt@aei.ca>
Cc: LKML <linux-kernel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <200904121124.07193.edt@aei.ca>
References: <200904121124.07193.edt@aei.ca>
Content-Type: text/plain
Date: Mon, 13 Apr 2009 10:05:07 +0800
Message-Id: <1239588307.7661.209.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-04-12 at 23:24 +0800, Ed Tomlinson wrote:
> Hi,
> 
> I got tired of building out of tree DRM drivers so decided to try 2.6.30-rc1.  For simple tasks
> it works fine, for slightly more complex ones it is not quite as good...
> 
> Here is an example.  I normally start a kvm session with the commands below:
> 
> ed@grover ~/vm $ sudo modprobe tun
> ed@grover ~/vm $ sudo brctl addbr br0
> ed@grover ~/vm $ sudo ifconfig br0 192.168.100.254 netmask 255.255.255.0 up
> ed@grover ~/vm $ sudo tunctl -b -u ed -t qtap0
> qtap0
> ed@grover ~/vm $ sudo brctl addif br0 qtap0
> ed@grover ~/vm $ sudo ifconfig qtap0 up 0.0.0.0 promisc
> ed@grover ~/vm $ sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> iptables v1.4.2: can't initialize iptables table `nat': Table does not exist (do you need to insmod?)
> Perhaps iptables or your kernel needs to be upgraded.
> 
> Issue 1 - I need to manually modprobe be get iptables to work.  This exact procedure worked in 2.6.29.
> 
> ed@grover ~/vm $ sudo modprobe nf_nat
> ed@grover ~/vm $ sudo modprobe ipt_MASQUERADE
> ed@grover ~/vm $ sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> 
> Once the above networking stuff is setup I start kvm with the command below
> 
> QEMU_AUDIO_DRV=alsa kvm -m 1024 -cdrom /mnt/sdc4/divx/archlinux-2009.02-ftp-i686.iso -boot c -smp 3 -usb -usbdevice tablet -vga std -drive file=arch.img -net nic,macaddr=52:54:00:12:34:23 -net tap,ifname=qtap0,script=no -soundhw all -mem-path /hugepages
> 
> which works and the kvm session boots just fine.  
> 
> Issue 2.  When I attempt to ping outside the kvm session the pc (not just the kvm session) hangs.
> Its impossible to kill the kvm session and there are numerious info messages from RCU (tree RCU enabled)
> about stalls.  
> 
> Issue 3.  ACPI is having fun during startup.  This does not seem to cause problems later but is 
> noisy and probably should be fixed before .30's release.
> 
this is a duplicate of bug
http://bugzilla.kernel.org/show_bug.cgi?id=13036
please try the patch in comment #6 there and see if it helps.

thanks,
rui

