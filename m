Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276AbYJSWMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbYJSWMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 18:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYJSWMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 18:12:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39980 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038AbYJSWMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 18:12:42 -0400
Date: Sun, 19 Oct 2008 23:40:37 +0200
From: Pavel Machek <pavel@suse.cz>
To: jbenc@suse.cz, kernel list <linux-kernel@vger.kernel.org>, i.zhu@intel.com,
       reinette.chatre@intel.com, linux-wireless@vger.kernel.org,
       ipw3945-devel@lists.sourceforge.net
Subject: iwl3945: if I leave my machine running overnight, wifi will not
	work in the morning
Message-ID: <20081019214035.GA30485@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Kernel 2.6.27-rc8; happened few times already.

root@amd:~# ifconfig wlan0 down
root@amd:~# SysRq : Changing Loglevel
Loglevel set to 9

root@amd:~# ifconfig wlan0 up
iwl3945 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwl3945 0000:03:00.0: restoring config space at offset 0x1 (was
0x100102, writing 0x100106)
Registered led device: iwl-phy0:radio
Registered led device: iwl-phy0:assoc
Registered led device: iwl-phy0:RX
Registered led device: iwl-phy0:TX
wlan0: authenticate with AP 00:11:2f:0e:95:a0
root@amd:~# wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX AssocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0
aid=1)
wlan0: associated

root@amd:~# ping 10.0.0.2
PING 10.0.0.2 (10.0.0.2): 56 data bytes
wlan0: deauthenticated
wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0
aid=1)
wlan0: associated

^C  ##### ping will not reply.

--- 10.0.0.2 ping statistics ---
23 packets transmitted, 0 packets received, 100% packet loss
root@amd:~#

#### iwlist works:

root@amd:~# iwlist wlan0 scan
Warning: Driver for device wlan0 has been compiled with version 22
of Wireless Extension, while this program supports up to version 17.
Some things may be broken...

wlan0     Scan completed :
          Cell 01 - Address: 00:11:2F:0E:95:A0
                    ESSID:"pavel"
                    Mode:Master
                    Channel:1
                    Frequency:2.412 GHz (Channel 1)
                    Quality=43/100  Signal level:-83 dBm  Noise
level=-99 dBm
                    Encryption key:off
                    Bit Rate:1 Mb/s
                    Bit Rate:2 Mb/s
                    Bit Rate:5.5 Mb/s
                    Bit Rate:11 Mb/s
...

root@amd:~# iwconfig wlan0 essid pavel
root@amd:~# wlan0: authenticate with AP 00:11:2f:0e:95:a0
wlan0: authenticated
wlan0: associate with AP 00:11:2f:0e:95:a0
wlan0: RX ReassocResp from 00:11:2f:0e:95:a0 (capab=0x401 status=0
aid=1)
wlan0: associated

root@amd:~# ping hobit
PING hobit.ucw.cz (10.0.0.2): 56 data bytes
^C
--- hobit.ucw.cz ping statistics ---
34 packets transmitted, 0 packets received, 100% packet loss
root@amd:~#

Is there documentation of
/sys/module/iwl3945/drivers/pci:iwl3945/{un,}bind somewhere? I believe
that's the next step, but could not figure it out.

After reboot, network will work (I believe ;-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
