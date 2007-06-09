Return-Path: <linux-kernel-owner+w=401wt.eu-S1762145AbXFIWA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762145AbXFIWA5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 18:00:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760711AbXFIWAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 18:00:48 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:43308 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759620AbXFIWAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 18:00:47 -0400
Date: Sat, 9 Jun 2007 23:57:12 +0200
From: Pavel Machek <pavel@ucw.cz>
To: kernel list <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org
Cc: ipw2100-admin@linux.intel.com
Subject: Re: ipw3945 driver in recent -mm kernels
Message-ID: <20070609215712.GA13678@elf.ucw.cz>
References: <20070609192703.GA6410@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070609192703.GA6410@elf.ucw.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I tried to use `subj`, but hit few problems:
> 
> There's no maintainers entry. Should
> 
>  James P. Ketrenos <ipw2100-admin@linux.intel.com> 
> 
> be listed as a maintainer?
> 
> Kconfig mentions...
> 
>           See <file:Documentation/networking/README.iwlwifi> for
>           information on the capabilities currently enabled in this
>           driver and for tips for debugging issues and problems.
> 
> ...but that file does not exist.

More problems: 

I managed to load the firmware and insert the module.... but I had
radio kill switch on. It complained that kill switch is on, but
turning it off did not help. Module unload/reload was neccessary to
get it to work.

I still do not see the wlan led. It seems to scan okay, but I can't
seem to connect, and I get this in logs:

Jun  9 23:53:21 amd kernel: wlan0: deauthenticated
Jun  9 23:53:21 amd kernel: wlan0: RX deauthentication from
00:11:2f:0e:95:a0 (reason=4)
Jun  9 23:53:21 amd last message repeated 2 times
Jun  9 23:53:22 amd kernel: wlan0: authenticate with AP
00:11:2f:0e:95:a0
Jun  9 23:53:22 amd kernel: wlan0: RX authentication from
00:11:2f:0e:95:a0 (alg=0 transaction=2 status=0)
Jun  9 23:53:22 amd kernel: wlan0: authenticated
Jun  9 23:53:22 amd kernel: wlan0: associate with AP 00:11:2f:0e:95:a0
Jun  9 23:53:22 amd kernel: wlan0: authentication frame received from
00:11:2f:0e:95:a0, but not in authenticate state - ignored
Jun  9 23:53:22 amd last message repeated 2 times
Jun  9 23:53:22 amd kernel: wlan0: RX ReassocResp from
00:11:2f:0e:95:a0 (capab=0x401 status=0 aid=2)
Jun  9 23:53:22 amd kernel: wlan0: associated
Jun  9 23:53:24 amd kernel: wlan0: No ProbeResp from current AP
00:11:2f:0e:95:a0 - assume out of range
Jun  9 23:53:43 amd kernel: e1000: eth0: e1000_watchdog: NIC Link is
Up 100 Mbps Full Duplex, Flow Control: RX/TX
Jun  9 23:53:43 amd kernel: e1000: eth0: e1000_watchdog: 10/100 speed:
disabling TSO
Jun  9 23:53:56 amd kernel: wlan0: No STA entry for own AP
00:11:2f:0e:95:a0
Jun  9 23:54:12 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000000.
Jun  9 23:54:12 amd kernel: iwl3945: Error Reply type 0x0000003A cmd
REPLY_RXON_ASSOC (0x11) seq 0x0447 ser 0x00000000
Jun  9 23:54:12 amd kernel: iwl3945: Error setting RXON_ASSOC
configuration (-5).
Jun  9 23:54:13 amd kernel: iwl3945: Error sending REPLY_RXON: time
out after 500ms.
Jun  9 23:54:13 amd kernel: iwl3945: Error setting new configuration
(-110).
Jun  9 23:54:15 amd kernel: iwl3945: Error sending REPLY_ADD_STA: time
out after 500ms.
Jun  9 23:54:15 amd kernel: iwl3945: ipw going down
Jun  9 23:54:15 amd kernel: iwl3945: Can't stop Rx DMA.
Jun  9 23:54:15 amd kernel: iwl3945: Grabbing access while already
held at line 825.
Jun  9 23:54:15 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000000.
Jun  9 23:54:15 amd kernel: iwl3945: Error Reply type 0x000004EB cmd
REPLY_TX_PWR_TABLE_CMD (0x97) seq 0x0402 ser 0x00000000
Jun  9 23:54:15 amd kernel: iwl3945: ipw going down
Jun  9 23:54:16 amd kernel: iwl3945: Can't stop Rx DMA.
Jun  9 23:54:16 amd kernel: iwl3945: Grabbing access while already
held at line 825.
Jun  9 23:54:16 amd kernel: iwl3945: Microcode SW error detected.
Restarting 0x82000000.
Jun  9 23:54:16 amd kernel: iwl3945: Error Reply type 0x000004EB cmd
REPLY_TX_PWR_TABLE_CMD (0x97) seq 0x0402 ser 0x00000000
Jun  9 23:54:16 amd kernel: iwl3945: ipw going down
Jun  9 23:54:17 amd kernel: iwl3945: Can't stop Rx DMA.
Jun  9 23:54:17 amd kernel: iwl3945: Grabbing access while already
held at line 825.

What are the next steps?

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
