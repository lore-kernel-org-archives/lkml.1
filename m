Return-Path: <linux-kernel-owner+w=401wt.eu-S1754397AbYFBEbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397AbYFBEbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 00:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYFBEa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 00:30:57 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46624 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYFBEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 00:30:56 -0400
Date: Sun, 1 Jun 2008 21:15:36 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Justin Mattock" <justinmattock@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: BUG kmalloc-2048: Poison overwritten
Message-ID: <20080601211536.1e3ba47c@infradead.org>
In-Reply-To: <dd18b0c30806012053q27b00fd6p40fa63bcb4bb19a3@mail.gmail.com>
References: <dd18b0c30806011613l6c8c1863rd237f7de06a6b33a@mail.gmail.com>
	<20080601190138.4d86dc66@infradead.org>
	<dd18b0c30806012053q27b00fd6p40fa63bcb4bb19a3@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 03:53:43 +0000
"Justin Mattock" <justinmattock@gmail.com> wrote:

> On Mon, Jun 2, 2008 at 2:01 AM, Arjan van de Ven
> <arjan@infradead.org> wrote:
> > On Sun, 1 Jun 2008 23:13:51 +0000
> > "Justin Mattock" <justinmattock@gmail.com> wrote:
> >
> >> I received this after the second simultaneous suspend: (I will try
> >> and see if this is re creatable or not)
> >>
> >> [  232.270737] BUG: unable to handle kernel paging request at
> >> 6b6b6c6b
> >
> > bad bad bad
> >
> >
> >> [  232.270743] IP: [<c013f96d>] module_put+0x12/0x2b
> >> [  232.270750] *pde = 00000000
> >> [  232.270753] Oops: 0002 [#1] SMP
> >> [  232.270757] Modules linked in: hci_usb cpufreq_ondemand
> >> cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth
> >> fan ipmi_watchdog ipmi_msghandler uinput wlan_tkip
> >> ieee80211_crypt_tkip ieee80211_crypt arpt_mangle arptable_filter
> >> arp_tables nf_conntrack_ipv4 nf_conntrack iptable_mangle
> >> iptable_filter ip_tables x_tables intelfb i2c_i810 i2c_algo_bit
> >> coretemp eeprom acpi_cpufreq fglrx(P) applesmc joydev uvcvideo
> >> appletouch wlan_scan_sta
> >   ^^^^^
> >
> > naughty
> >
> >> ath_rate_sample firewire_ohci firewire_core snd_hda_intel ath_pci
> >> snd_pcm wlan ohci1394 intel_agp evdev ath_hal(P) snd_timer ieee1394
> >                                        ^^^^^^^^^^
> >
> > worse
> >
> >
> >> Hopefully this is nothing serious,
> >> regards;
> >
> > actually it's very serious, something is scribbling all over your
> > memory, it's just a matter of time before that overwrites something
> > important on your filesystem, and then you have a high risk of
> > losing most of your data.
> >
> > However, since  you're using 2 proprietary kernel modules, you
> > really ought to contact the vendors for those modules for support;
> > they're a very likely cause for problems
> > (for example, these two are the cause for the number 1, 2, 5 and 7
> > of the top 10 kernel oopses/crashes for the last week)
> >
> >
> >
> great!!!  Well The problem I have with these modules is A) madwifi
> "waiting until support is in the kernel for this one,

you mean the ath5k driver which already is in the kernel?
If it doesnt work for you, have you filed a bugzilla ?

> for now I
> just have to deal with risking loosing any data". B) graphics driver I
> can unload the driver but then loose suspend to mem "argh!!"

A current ATI driver in X.org ought to be close to getting this one
right.

> aside from that, I just performed the test again of simultaneously
> suspending to memory and didn't receive this message,

sure the corruption this time wasn't in a redzone.. but maybe elsewhere.

> so now I'm at a
> lost for words as to what is happening. The positive side is there
> isn't any important data on my system i.g. important doc's etc..., but
>

good luck.


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
