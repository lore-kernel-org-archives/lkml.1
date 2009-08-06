Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbZHFNbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbZHFNbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 09:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755412AbZHFNbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 09:31:21 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53693 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755325AbZHFNbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 09:31:20 -0400
X-Greylist: delayed 514 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 09:31:20 EDT
X-Sasl-enc: /1wEkFSbGmAAi6N9sCcUmPE1KewYzKEKIMtizhRnF9M2 1249564967
Date: Thu, 6 Aug 2009 10:22:44 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090806132244.GC15867@khazad-dum.debian.net>
References: <20090726075738.GA21333@ics.muni.cz>
 <1248710618.1216.452.camel@rc-desk>
 <1248710775.9958.0.camel@johannes.local>
 <20090728112102.GA3382@ics.muni.cz>
 <1249336021.30019.4304.camel@rc-desk>
 <20090804084903.GV3382@ics.muni.cz>
 <1249426183.30019.4581.camel@rc-desk>
 <20090804225626.GZ3382@ics.muni.cz>
 <1249429081.30019.4588.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249429081.30019.4588.camel@rc-desk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Aug 2009, reinette chatre wrote:
> > My problem is, that since 2.6.31-rcX Fn+F5 toggles soft rfkill state. It
> > did not happen in 2.6.30 and earlier. In that case, Fn+F5 triggered an
> > acpi event (key press). Now, it triggers acpi eveny *and* touches soft
> > rfkill of WIFI.  I like the previous behavior, i.e., don't touch
> > anything, just report acpi event.
> 
> I do not know why your Lenovo T61 gets wifi software rfkill when you press
> Fn-F5 and mine does not. I am adding Henrique and hope he can tell us what
> is going on. 

Well, if you really want to get to the bottom of the matter, I need:

1. .config from both of you

2. the output of "grep . /sys/bus/platform/devices/thinkpad_acpi/hotkey_*";

3. the keymap of the thinkpad-acpi input device.  On Debian, "lsinput and
input-kbd" from package "input-utils" can be used to locate the correct
input device and dump its keymap.  Other distros have similar input-device
utilities, I think.


I guess 2.6.31 has the new rfkill code, and this likely enabled rfkill-input
or something.

If you *really* want to make sure fn+f5 will never give you surprises, you
either:

1. switch bit 4 off from /sys/bus/platform/devices/thinkpad_acpi/hotkey_mask

or

2. program scancode 4 on the thinkpad-acpi input device to something that is
not KEY_WLAN, KEY_BLUETOOTH, etc.


ACPI events for fn+f5 will be generated *only* on the deprecated, outdated
/proc/acpi/event interface.  hotkey_mask gets rid of those too.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
