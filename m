Return-Path: <linux-kernel-owner+w=401wt.eu-S1760721AbZDIEwW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760721AbZDIEwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 00:52:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZDIEwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 00:52:10 -0400
Received: from sycorax.lbl.gov ([128.3.11.121]:36395 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbZDIEwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 00:52:08 -0400
X-Greylist: delayed 666 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Apr 2009 00:52:08 EDT
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Justin Madru <jdm64@gawab.com>,
       lkml <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.30-rc1: intel 3945 no wireless
References: <49DC37F0.2040408@gawab.com>
	<20090408201414.9161568f.akpm@linux-foundation.org>
	<49DD6BF7.3040400@lwfinger.net>
Date: Wed, 08 Apr 2009 21:39:47 -0700
In-Reply-To: <49DD6BF7.3040400@lwfinger.net> (message from Larry Finger on
	Wed, 08 Apr 2009 22:31:03 -0500)
Message-ID: <87myaql9t8.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Larry Finger <Larry.Finger@lwfinger.net> writes:

> Andrew Morton wrote:
>> (cc linux-wireless)
>> 
>> On Tue, 07 Apr 2009 22:36:48 -0700 Justin Madru <jdm64@gawab.com> wrote:
>> 
>>> Hi,
>>>
>>> Decided to test out .30-rc1, but I've run into some bugs.
>>> My intel 3945 wireless card doesn't work. Bellow is the relevant 
>>> portions of dmesg
>>> The full dmesg and config can be found at: 
>>> http://jdserver.homelinux.org/bugreports/003/
>>>
>>> iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver for 
>>> Linux, 1.2.26ks
>>> iwl3945: Copyright(c) 2003-2009 Intel Corporation
>>> iwl3945 0000:0b:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
>>> iwl3945 0000:0b:00.0: setting latency timer to 64
>>> input: SynPS/2 Synaptics TouchPad as 
>>> /devices/platform/i8042/serio1/input/input6
>>> iwl3945 0000:0b:00.0: Tunable channels: 11 802.11bg, 13 802.11a channels
>>> iwl3945 0000:0b:00.0: Detected Intel Wireless WiFi Link 3945ABG
>>>   alloc irq_desc for 26 on cpu 0 node 0
>>>   alloc kstat_irqs on cpu 0 node 0
>>> iwl3945 0000:0b:00.0: irq 26 for MSI/MSI-X
>>> phy0: Selected rate control algorithm 'iwl-3945-rs'
>>> input: HDA Intel Mic at Ext Right Jack as 
>>> /devices/pci0000:00/0000:00:1b.0/input/input7
>>> input: HDA Intel HP Out at Ext Right Jack as 
>>> /devices/pci0000:00/0000:00:1b.0/input/input8
>>> phy0: Failed to initialize wep: -2
>>> iwl3945 0000:0b:00.0: Failed to register hw (error -2)
>>> iwl3945 0000:0b:00.0: PCI INT A disabled
>>> iwl3945: probe of 0000:0b:00.0 failed with error -2
>>>
>> 
>> I assume this is a regression?  2.6.29 was OK?
>
> See the discussion in the thread containing
> http://marc.info/?l=linux-kernel&m=123922531327539&w=2. This one also contains
> the fix that was accepted by Rusty Russell.

i have the same problem. 2.6.29 was fine, 2.6.30-rc1 doesn't work. i
tried applying the above mentioned patch but it didn't make any
difference. at any rate, i have iwl3945 compiled in the kernel and not
as a module and i don't use wep. this is the relevant part from syslog:

iwl3945 0000:03:00.0: firmware: requesting iwlwifi-3945-2.ucode
iwl3945 0000:03:00.0: loaded firmware version 15.28.2.8
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
iwl3945 0000:03:00.0: Microcode SW error detected. Restarting 0x82000008.
iwl3945 0000:03:00.0: Error Reply type 0x00000005 cmd REPLY_PHY_CALIBRATION_CMD (0xB0) seq 0x013A ser 0x004E0000
Registered led device: iwl-phy0::radio
Registered led device: iwl-phy0::assoc
Registered led device: iwl-phy0::RX
Registered led device: iwl-phy0::TX
wlan0: authenticate with AP XX:XX:XX:XX:XX:XX
wlan0: authentication with AP XX:XX:XX:XX:XX:XX timed out

looking through the logs i also noticed this:

REISERFS warning (device sda4): jdm-20004 reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)

REISERFS warning (device sda4): jdm-20004 reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)

REISERFS warning (device sda2): jdm-20004 reiserfs_delete_xattrs: Couldn't delete all xattrs (-13)

--alex--


-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
