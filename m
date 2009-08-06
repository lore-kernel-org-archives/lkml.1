Return-Path: <linux-kernel-owner+w=401wt.eu-S1756883AbZHFXHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756883AbZHFXHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 19:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756875AbZHFXHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 19:07:09 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43448 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756849AbZHFXHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 19:07:07 -0400
X-Sasl-enc: nS4rkxZ3DBc0+slN7YJ7/N1RlhWRwKJR7coaIwZUqc7q 1249600026
Date: Thu, 6 Aug 2009 20:07:04 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: reinette chatre <reinette.chatre@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090806230704.GA14381@khazad-dum.debian.net>
References: <1248710618.1216.452.camel@rc-desk>
 <1248710775.9958.0.camel@johannes.local>
 <20090728112102.GA3382@ics.muni.cz>
 <1249336021.30019.4304.camel@rc-desk>
 <20090804084903.GV3382@ics.muni.cz>
 <1249426183.30019.4581.camel@rc-desk>
 <20090804225626.GZ3382@ics.muni.cz>
 <1249429081.30019.4588.camel@rc-desk>
 <20090806132244.GC15867@khazad-dum.debian.net>
 <20090806224110.GJ3382@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806224110.GJ3382@ics.muni.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Aug 2009, Lukas Hejtmanek wrote:
> 0x0004 = 238  # KEY_WLAN

This means any rfkill input handler (be it in kernel or userspace) will
toggle your WLAN cards when fn+f5 is pressed.  You can just assign a
different keycode to it (use KEY_RESERVED or KEY_UNKNOWN if you don't want
the key to do anything).

If you unmask the key on hotkey_mask, it will revert to BIOS actions, which
depending on the thinkpad, might cause it to operate on bluetooth, wwan,
etc...

> 0x0007 = 192  # KEY_F22
> 0x0008 = 194  # KEY_F24

Hmm? What does that do in your distro?  That's fn+f8 and fn+f9, BTW.

> 0x0011 = 228  # KEY_KBDILLUMTOGGLE

Didn't know this one existed!  Heh.  Still, it should not be enabled in
thinkpad-acpi, the thinkpad will react to it by itself, and the input layer
is not to be used for status reports...

> well, at least, I would like behavior where Fn+F5 does not do rfkill silently
> (I guess in kernel?). I would prefer an event or just a key code. This is not
> possible any more?

> CONFIG_RFKILL=m
> CONFIG_RFKILL_LEDS=y
> CONFIG_RFKILL_INPUT=y

Disable CONFIG_RFKILL_INPUT, then.  Otherwise, the kernel WILL react to any
of the keycodes it knows about.  And also to the radio-kill switch (in more
ways than the strictly enforced by the firmware and thinkpad-acpi, that is).

I think you should add a HAL .fdi file to your system to reprogram fn+f5 to
something else: this is likely the best way to go about it in the long run,
as I bet userspace will start grokking rfkill input events really soon
now...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
