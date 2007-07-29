Return-Path: <linux-kernel-owner+w=401wt.eu-S933051AbXG2RVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933051AbXG2RVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 13:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764685AbXG2RVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 13:21:42 -0400
Received: from smtpout.mac.com ([17.250.248.178]:61789 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764653AbXG2RVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 13:21:41 -0400
In-Reply-To: <46AA5E1A.8020303@garzik.org>
References: <20070724162805.76ea8328@frecb000686.frec.bull.fr> <200707271256.17025.bjorn.helgaas@hp.com> <86802c440707271335y29ca79ccq844b5cb457bd2314@mail.gmail.com> <200707271458.44391.bjorn.helgaas@hp.com> <46AA5E1A.8020303@garzik.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A2444507-569E-4D35-A694-C8F0CD24ED00@mac.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, ambx1@neo.rr.com,
       akpm@linux-foundation.org, lenb@kernel.org, rmk@arm.linux.org.uk,
       mjg59@srcf.ucam.org, castet.matthieu@free.fr
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: commit 7e92b4fc34 - x86, serial: convert legacy COM ports to platform devices - broke my serial console
Date: Sun, 29 Jul 2007 13:21:33 -0400
To: Jeff Garzik <jeff@garzik.org>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 27, 2007, at 17:05:30, Jeff Garzik wrote:
> Bjorn Helgaas wrote:
>> And couldn't we use udev to associate a fixed name with a MAC  
>> address?  Then the user could use the same persistent name,  
>> regardless of the order in which the driver found the devices.
>
> I don't know about udev, but people are definitely using fixed  
> names based on MAC address for ethernet devices already:  nameif(8)  
> and /etc/mactab, iftab(5) and ifrename(8).

I was doing that for a while, but now Debian and RedHat and most  
other modern distros have a udev rules file called something like: / 
etc/udev/rules.d/z30-persistent-net-generator.rules  Under Debian it  
generates a file /etc/udev/rules.d/z25-persistent-net.rules which  
automatically renames net devices based on their mac address.  The  
persistent-net-generator takes the current name and MAC and stuffs  
them in an appropriate file.  So really once you've booted with the  
network card in, all you have to do is modify the persistent- 
net.rules file to change the name of your NIC and rerun udevtrigger.   
I've gotten into the habit of using descriptive names lately (7 chars  
is the most that ifconfig will show without truncating, and it seems  
to be unable to properly sort/display/operate-on longer ones).

For example, my Debian firewall box has:
   world: Connection to the cable modem
   switch: Connection to my VLAN-capable switch
   main0: "Primary" VLAN on my switch.
   main1: A local gigabit switch for connections to a couple other  
systems
   main: A bridge of main0 and main1 which is used as the primary LAN  
interface
   hbeat: Dedicated NIC for Linux-HA (HeartBeat)
   debian: A Debian netinst net-boot VLAN with support for PXE and  
OpenFirmware
   radius: A VLAN used by my wireless AP for radius traffic
   wifi: A VLAN used for private wireless traffic

Most of those interfaces are virtual and created by custom "/etc/ 
network/if-pre-up.d/*" scripts, but you can see the "world",  
"switch", "main1", and "hbeat" interfaces are actual physical  
interfaces.  Such naming (with appropriate comments in /etc/network/ 
interfaces) vastly eases the management of a box with a shitton of  
interfaces.  The fact that ifconfig has some outstanding bugs with  
big interface names is mostly irrelevant since I use the iproute2  
tool ("ip") to do almost all administration.

Cheers,
Kyle Moffett
