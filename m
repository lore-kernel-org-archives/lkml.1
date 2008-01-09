Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYAIWXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYAIWXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 17:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751555AbYAIWXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 17:23:39 -0500
Received: from aleve.media.mit.edu ([18.85.2.171]:2276 "EHLO
	aleve.media.mit.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYAIWXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 17:23:38 -0500
Message-ID: <47854916.4080703@reed.com>
Date: Wed, 09 Jan 2008 17:22:14 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20071115 Fedora/2.0.0.9-1.fc8 Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Zachary Amsden <zach@vmware.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@quramnet.com>,
       Christer Weinigel <christer@weinigel.se>,
       Ondrej Zary <linux@rainbow-software.org>,
       Rene Herman <rene.herman@keyaccess.nl>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	 <200801081810.58904.linux@rainbow-software.org> <4783B1B2.6070005@reed.com>	 <200801081838.16241.linux@rainbow-software.org> <4783C4A6.9060402@reed.com>	 <20080108185120.3ff7ed18@lxorguk.ukuu.org.uk> <4783CBD9.7020709@reed.com>	 <1199847162.7369.323.camel@bodhitayantram.eng.vmware.com>	 <47845972.9090803@zytor.com> <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>
In-Reply-To: <1199915614.7369.367.camel@bodhitayantram.eng.vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zachary Amsden wrote:
>
> According to Phoenix Technologies book "System BIOS for IBM PCs,
> Compatibles and EISA Computers, 2nd Edition", the I/O port list gives
>
> port 0080h   R/W  Extra page register (temporary storage)
>
> Despite looking, I've never seen it documented anywhere else, but I
> believe it works on just about every PC platform.  Except, apparently,
> my laptop.
>
>
>   
The port 80 problem was discovered by me, after months of "bisecting" 
the running code around a problem with hanging when using hwclock in 
64-bit mode when ACPI is on.  So it kills my laptop, too, and many 
currentlaptop motherboards designed by Quanta for HP and Compaq (dv6000, 
dv9000, tx1000, apparently)

In the last couple of weeks, I was able with luck to discover that the 
problem is the ENE KB3920 chip, which is the "big brother" of the KB3700 
chip included in the OLPC XO "$100 laptop" made also by Quanta.  I 
verified this by taking my laptop apart - a fun and risky experience.  
Didn't break any connectors, but I don't recommend it for those who are 
not experienced disassembling laptops and cellphones, etc.  The KB3920 
contains an EC, an SMBus, a KBC, some watchdog timers, and a variety of 
other functions that keep the laptop going, coordinating the 
relationships among various peripherals.  The firmware is part standard 
from ENE, part OEM-specific, in this case coded by Quanta or a BIOS 
subcontractor.

You can read the specsheet for the KB3700 online at laptop.org, since 
the specs of the laptop are "open".  The 3920's spec is confidential.  
And the firmware is confidential as well for both the 3700 and 3920.  
Clues as to what it does can be gleaned by reading the disassembler 
output of the DSDT code in the particular laptops - though the SMM BIOS 
probably also talks to it.

Modern machines have many subsystems, and the ACPI and SMBIOS coordinate 
to run them; blade servers also have drawer controllers and backplane 
management buses.  The part that runs Linux is only part of the machine.

Your laptop isn't an aberration.  It's part of the new generation of 
evolved machines that take advantage of the capabilities of ACPI and 
SMBIOS and DMI standards that are becoming core parts of the market.


