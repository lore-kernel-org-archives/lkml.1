Return-Path: <linux-kernel-owner+w=401wt.eu-S1755158AbZHNCKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbZHNCKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 22:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbZHNCKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 22:10:34 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57881 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752923AbZHNCKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 22:10:33 -0400
X-Sasl-enc: tqMe9sljevbMPJXcUzs6sLCmwLnk/rI5tSy8sg1hTQLo 1250215832
Date: Thu, 13 Aug 2009 23:10:31 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Johannes Berg <johannes@sipsolutions.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi (4965) regression since 2.6.30
Message-ID: <20090814021031.GB4555@khazad-dum.debian.net>
References: <1249336021.30019.4304.camel@rc-desk> <20090804084903.GV3382@ics.muni.cz> <1249426183.30019.4581.camel@rc-desk> <20090804225626.GZ3382@ics.muni.cz> <1249429081.30019.4588.camel@rc-desk> <20090806132244.GC15867@khazad-dum.debian.net> <20090806224110.GJ3382@ics.muni.cz> <20090806230704.GA14381@khazad-dum.debian.net> <20090807213508.GN3382@ics.muni.cz> <1250204399.30019.6344.camel@rc-desk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1250204399.30019.6344.camel@rc-desk>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, 13 Aug 2009, reinette chatre wrote:
> On Fri, 2009-08-07 at 14:35 -0700, Lukas Hejtmanek wrote:
> > On Thu, Aug 06, 2009 at 08:07:04PM -0300, Henrique de Moraes Holschuh wrote:
> > > On Fri, 07 Aug 2009, Lukas Hejtmanek wrote:
> > > > 0x0004 = 238  # KEY_WLAN
> > > 
> > > This means any rfkill input handler (be it in kernel or userspace) will
> > > toggle your WLAN cards when fn+f5 is pressed.  You can just assign a
> > > different keycode to it (use KEY_RESERVED or KEY_UNKNOWN if you don't want
> > > the key to do anything).
> > 
> > Could you give me some hints how to do the mapping?
> 
> On my system this key is mapped to 385 (KEY_RADIO) - so that can explain

And KEY_RADIO is the key to select the radio tuner... heh.  The
bogosity never ends.  At least it is unlikely that anything would care
for KEY_RADIO.

> why we are seeing different behavior. Perhaps you can try to change your
> key mapping to this if you just want bluetooth to be affected?

That would be the correct thing to do, yes.

> >From what I understand you can use input-kbd to change the key mappings.
> The map file you can provide to it is in same format as the one it
> prints for you.

You can also add a HAL fdi file.  I will attach one I found on my
system, modify to your taste and find out where you should drop it on
/etc for HAL to use...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="30-keymap-module-thinkpad-acpi.fdi"

<?xml version="1.0" encoding="ISO-8859-1"?> <!-- -*- SGML -*- -->

<deviceinfo version="0.2">
  <device>
    <!-- These are buttons synthesized in the thinkpad-acpi kernel module -->
    <match key="input.product" string="ThinkPad Extra Buttons">
      <match key="/org/freedesktop/Hal/devices/computer:system.hardware.vendor" prefix="IBM">
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains="600">
          <append key="input.keymap.data" type="strlist">0x02:screenlock</append> <!-- Fn+F3 lock -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x07:search</append> <!-- Fn+F8 screen expand -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains="750">
          <append key="input.keymap.data" type="strlist">0x02:battery</append> <!-- Fn+F3 battery -->
          <append key="input.keymap.data" type="strlist">0x02:screenlock</append> <!-- Fn+F3 lock -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x07:search</append> <!-- Fn+F8 screen expand -->
          <append key="input.keymap.data" type="strlist">0x0a:mode</append> <!-- Fn+F11 power mode -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains="R5">
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x04:radio</append> <!-- Fn+F5 switch wifi -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains_outof="T3;X2;R3;A2">
          <append key="input.keymap.data" type="strlist">0x02:screenlock</append> <!-- Fn+F3 lock -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains="T4">
          <append key="input.keymap.data" type="strlist">0x02:screenlock</append> <!-- Fn+F3 lock -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x04:radio</append> <!-- Fn+F5 switch radio -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains_outof="X3;G40">
          <append key="input.keymap.data" type="strlist">0x02:screenlock</append> <!-- Fn+F3 lock -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x07:radio</append> <!-- Fn+F8 switch radio -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains="X4">
          <append key="input.keymap.data" type="strlist">0x02:screenlock</append> <!-- Fn+F3 lock -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x04:radio</append> <!-- Fn+F5 switch radio -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x08:f24</append> <!-- Fn+F9 undock -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
      </match>

      <match key="/org/freedesktop/Hal/devices/computer:system.hardware.vendor" prefix="LENOVO">
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains_outof="X6;Z6">
          <append key="input.keymap.data" type="strlist">0x01:screenlock</append> <!-- Fn+F2 lock -->
          <append key="input.keymap.data" type="strlist">0x02:battery</append> <!-- Fn+F3 battery -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x04:radio</append> <!-- Fn+F5 wifi -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x07:f22</append> <!-- Fn+F8 touchpadtoggle -->
          <append key="input.keymap.data" type="strlist">0x08:f24</append> <!-- Fn+F9 undock -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains="T6">
          <append key="input.keymap.data" type="strlist">0x01:screenlock</append> <!-- Fn+F2 lock -->
          <append key="input.keymap.data" type="strlist">0x02:battery</append> <!-- Fn+F3 battery -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x04:radio</append> <!-- Fn+F5 wifi -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x07:f22</append> <!-- Fn+F8 touchpadtoggle -->
          <append key="input.keymap.data" type="strlist">0x08:f24</append> <!-- Fn+F9 undock -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x11:kbdillumtoggle</append> <!-- Fn+PgUp - ThinkLight -->
          <append key="input.keymap.data" type="strlist">0x14:volumeup</append> <!-- Volume Up button -->
	  <append key="input.keymap.data" type="strlist">0x15:volumedown</append> <!-- Volume Down button -->
          <append key="input.keymap.data" type="strlist">0x16:mute</append> <!-- Mute button -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
        <match key="/org/freedesktop/Hal/devices/computer:system.hardware.version" contains="R6">
          <append key="input.keymap.data" type="strlist">0x01:screenlock</append> <!-- Fn+F2 lock -->
          <append key="input.keymap.data" type="strlist">0x02:battery</append> <!-- Fn+F3 battery -->
          <append key="input.keymap.data" type="strlist">0x03:sleep</append> <!-- Fn+F4 suspend -->
          <append key="input.keymap.data" type="strlist">0x04:radio</append> <!-- Fn+F5 wifi -->
          <append key="input.keymap.data" type="strlist">0x06:switchvideomode</append> <!-- Fn+F7 switch video output device -->
          <append key="input.keymap.data" type="strlist">0x07:prog1</append> <!-- Fn+F8 ultranav -->
          <append key="input.keymap.data" type="strlist">0x08:ejectcd</append> <!-- Fn+F9 eject -->
          <append key="input.keymap.data" type="strlist">0x0b:suspend</append> <!-- Fn+F12 hibernate -->
          <append key="input.keymap.data" type="strlist">0x0f:brightnessup</append> <!-- Fn+Home -->
          <append key="input.keymap.data" type="strlist">0x10:brightnessdown</append> <!-- Fn+End -->
          <append key="input.keymap.data" type="strlist">0x13:zoom</append> <!-- Fn+Space -->
          <append key="input.keymap.data" type="strlist">0x17:vendor</append> <!-- ThinkPad/ThinkVantage button -->
          <append key="info.capabilities" type="strlist">input.keymap</append>
        </match>
      </match>
    </match>
  </device>
</deviceinfo>


--ReaqsoxgOBHFXBhH--
