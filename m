Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYFBWVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYFBWVE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 18:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752517AbYFBWUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 18:20:52 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52341 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138AbYFBWUv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 18:20:51 -0400
Date: Tue, 3 Jun 2008 00:21:42 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Justin Mattock <justinmattock@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, marcel@holtmann.org,
       linux-bluetooth@vger.kernel.org
Subject: hci_usb strikes again (was Re: BUG kmalloc-2048: Poison
	overwritten)
Message-ID: <20080602222142.GB18599@elf.ucw.cz>
References: <dd18b0c30806011613l6c8c1863rd237f7de06a6b33a@mail.gmail.com> <200806020125.25918.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806020125.25918.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-06-02 01:25:25, Rafael J. Wysocki wrote:
> On Monday, 2 of June 2008, Justin Mattock wrote:
> > I received this after the second simultaneous suspend: (I will try and
> > see if this is re creatable or not)
> 
> Suspend to RAM or hibernation?

hci_usb... that beast is known to corrupt random data on suspend and
surprise removal.

> > [  232.270737] BUG: unable to handle kernel paging request at 6b6b6c6b
> > [  232.270743] IP: [<c013f96d>] module_put+0x12/0x2b
> > [  232.270750] *pde = 00000000
> > [  232.270753] Oops: 0002 [#1] SMP
> > [  232.270757] Modules linked in: hci_usb cpufreq_ondemand
> > cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth fan
> > ipmi_watchdog ipmi_msghandler uinput wlan_tkip ieee80211_crypt_tkip
> > ieee80211_crypt arpt_mangle arptable_filter arp_tables
> > nf_conntrack_ipv4 nf_conntrack iptable_mangle iptable_filter ip_tables
> > x_tables intelfb i2c_i810 i2c_algo_bit coretemp eeprom acpi_cpufreq
> > fglrx(P) applesmc joydev uvcvideo appletouch wlan_scan_sta
> > ath_rate_sample firewire_ohci firewire_core snd_hda_intel ath_pci
> > snd_pcm wlan ohci1394 intel_agp evdev ath_hal(P) snd_timer ieee1394
> > pata_acpi thermal ehci_hcd uhci_hcd snd_page_alloc snd_hwdep agpgart
> > video button processor
> > [  232.270800]
> > [  232.270802] Pid: 2690, comm: btdelconn Tainted: P
> > (2.6.26-rc4-00033-g5463508 #4)

...and we get oops in bluetooth.

Use btusb, instead.

Actually, I guess we should mark hci_usb as broken. I don't see why we
should debug the same problem over and over again.
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
