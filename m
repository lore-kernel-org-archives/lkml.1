Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbYJUTp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbYJUTp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYJUTpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:45:49 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41101 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbYJUTps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:45:48 -0400
Date: Tue, 21 Oct 2008 21:40:31 +0200
From: Pavel Machek <pavel@suse.cz>
To: jbenc@suse.cz, kernel list <linux-kernel@vger.kernel.org>, i.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: Re: iwl3945: if I leave my machine running overnight, wifi will
	not work in the morning
Message-ID: <20081021194031.GB17255@elf.ucw.cz>
References: <20081019214035.GA30485@elf.ucw.cz> <20081019220655.GA1827@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081019220655.GA1827@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-10-20 00:06:55, Pavel Machek wrote:
> On Sun 2008-10-19 23:40:35, Pavel Machek wrote:
> > Hi!
> > 
> > Kernel 2.6.27-rc8; happened few times already.
> 
> ...
> > After reboot, network will work (I believe ;-).
> 
> Hmm, it did not this time.

Happened again...

root@amd:/mnt# ifconfig wlan0 down
root@amd:/mnt# iwlist wlan0 scan
Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 17.
Some things may be broken...

wlan0     Interface doesn't support scanning : Network is down

root@amd:/mnt# ifconfig wlan0 10.0.0.6 up
root@amd:/mnt# iwlist wlan0 scan
Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 17.
Some things may be broken...

wlan0     Scan completed :
          Cell 01 - Address: 00:11:2F:0E:95:A0
                    ESSID:"pavel"
                    Mode:Master
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=95/100  Signal level:-34 dBm  Noise
level=-68 dBm
                    Encryption key:off
                    Bit Rate:1 Mb/s
                    Bit Rate:2 Mb/s
                    Bit Rate:5.5 Mb/s
                    Bit Rate:11 Mb/s
                    Bit Rate:6 Mb/s
                    Bit Rate:9 Mb/s
                    Bit Rate:12 Mb/s
                    Bit Rate:18 Mb/s
                    Bit Rate:24 Mb/s
                    Bit Rate:36 Mb/s
                    Bit Rate:48 Mb/s
                    Bit Rate:54 Mb/s
                    Extra:tsf=000000262894417f
                    Extra: Last beacon: 76ms ago

root@amd:/mnt# iwconfig wlan0 essid pavel
root@amd:/mnt# ping hobit
PING hobit.ucw.cz (10.0.0.2): 56 data bytes
^C
--- hobit.ucw.cz ping statistics ---
4 packets transmitted, 0 packets received, 100% packet loss
root@amd:/mnt# 


This time I tried rebooting the AP, but it did not help. dmesg says:

wlan0: No ProbeResp from current AP 00:11:2f:0e:95:a0 - assume out of
range
wlan0: deauthenticated
iwl3945 0000:03:00.0: PCI INT A disabled
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was
0x100102, writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX AssocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0
aid=1)
wlan0: associated
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0
aid=1)
wlan0: associated
wlan0: No ProbeResp from current AP 00:11:2f:0e:95:a0 - assume out of
range
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0
aid=1)
wlan0: associated
root@amd:/mnt# 


									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
