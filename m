Return-Path: <linux-kernel-owner+w=401wt.eu-S933846AbZHGUc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933846AbZHGUc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933749AbZHGUcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:32:25 -0400
Received: from bar.sig21.net ([80.81.252.164]:54404 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbZHGUcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:32:24 -0400
Date: Fri, 7 Aug 2009 22:32:26 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       reinette chatre <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090807203226.GA13867@sig21.net>
References: <1248710775.9958.0.camel@johannes.local>
 <20090728112102.GA3382@ics.muni.cz>
 <1249336021.30019.4304.camel@rc-desk>
 <20090804084903.GV3382@ics.muni.cz>
 <1249426183.30019.4581.camel@rc-desk>
 <20090804225626.GZ3382@ics.muni.cz>
 <1249429081.30019.4588.camel@rc-desk>
 <20090806132244.GC15867@khazad-dum.debian.net>
 <20090806224110.GJ3382@ics.muni.cz>
 <20090806230704.GA14381@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806230704.GA14381@khazad-dum.debian.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-21-Score: -3.5 (---)
X-Spam-21-Report: No, score=-3.5 required=5.0 tests=ALL_TRUSTED=-1.8,AWL=0.868,BAYES_00=-2.599 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 06, 2009 at 08:07:04PM -0300, Henrique de Moraes Holschuh wrote:
> On Fri, 07 Aug 2009, Lukas Hejtmanek wrote:
> > 0x0004 = 238  # KEY_WLAN
> 
> This means any rfkill input handler (be it in kernel or userspace) will
> toggle your WLAN cards when fn+f5 is pressed.  You can just assign a
> different keycode to it (use KEY_RESERVED or KEY_UNKNOWN if you don't want
> the key to do anything).
> 
> If you unmask the key on hotkey_mask, it will revert to BIOS actions, which
> depending on the thinkpad, might cause it to operate on bluetooth, wwan,
> etc...

I have a related question, sorry if I hijack the thread...

When thinkpad-acpi grew rfkill support a few kernel versions back
it forced Bluetooth on at boot time. Since I almost never use
Bluetooth I want it off to save power. The workaround I came up
with was to enable CONFIG_RFKILL and add rfkill.default_state=0
to the kernel cmdline.  Now this workaround also disables WLAN :-(
My workaround for my workaround (heh!) was to add
  pre-up echo 1 > `ls /sys/class/ieee80211/phy0/rfkill*/state`
in /etc/network/interfaces.  It would be nice to have a better
way to select boot-up defaults.


In Documentation/laptops/thinkpad-acpi.txt there is this comment
for FN+F5:

   Should be used to turn on/off all radios (Bluetooth+W-WAN+WLAN), really.

I disagree.  Why would anyone turn off all radios at once?
What I want is to disable the radios I don't need to save power,
so IMHO there should be different keys for Bluetooth and WLAN
(and W-WAN where present).

The BIOS does the right thing for me, it disables Bluetoth by default
until enabled with Fn-F5, and WLAN is always enabled.  For me
the rfkill support is a regression, not progress.


Johannes
