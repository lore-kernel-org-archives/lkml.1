Return-Path: <linux-kernel-owner+w=401wt.eu-S1763278AbYEGGpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763278AbYEGGpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 02:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757005AbYEGGpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 02:45:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:48930 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbYEGGpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 02:45:21 -0400
Date: Wed, 7 May 2008 08:45:07 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: tockar <tockar@o2.pl>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Problem with sensors on linux 2.6.25
Message-ID: <20080507084507.77764325@hyperion.delvare>
In-Reply-To: <20080506231838.563c9dcd.akpm@linux-foundation.org>
References: <200805042334.03574.tockar@o2.pl>
	<20080506231838.563c9dcd.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 23:18:38 -0700, Andrew Morton wrote:
> On Sun, 4 May 2008 23:34:03 +0200 tockar <tockar@o2.pl> wrote:
> 
> > Hello,
> > I've strange problem with Linux 2.6.25 and later (I've compiled 2.6.26-rc1 and 
> > I have same problem). In 'sensors' command result, I get ALARMs. 
> > Here's 'sensors' result on Linux 2.6.24:
> > 
> > it87-isa-0290
> > Adapter: ISA adapter
> > VCore 1:     +1,71 V  (min =  +3,97 V, max =  +1,95 V)
> > VCore 2:     +3,09 V  (min =  +3,82 V, max =  +1,01 V)
> > +3.3V:       +3,07 V  (min =  +3,82 V, max =  +3,06 V)
> > +5V:         +5,59 V  (min =  +4,27 V, max =  +5,11 V)
> > +12V:       +13,31 V  (min = +15,62 V, max =  +7,74 V)
> > -12V:        -2,69 V  (min =  -0,61 V, max =  +3,44 V)
> > -5V:         -9,14 V  (min =  +3,82 V, max =  -2,62 V)
> > Stdby:       +0,00 V  (min =  +6,37 V, max =  +5,03 V)
> > VBat:        +3,25 V
> > fan1:       5152 RPM  (min =    0 RPM, div = 2)
> > fan2:          0 RPM  (min =    0 RPM, div = 2)
> > M/B Temp:    +34,0__C  (low  =  -7,0°C, high = -11,0°C)  sensor = transistor
> > CPU Temp:    +33,0__C  (low  = -66,0°C, high = +127,0°C)  sensor = transistor
> > Temp3:       +31,0__C  (low  = -33,0°C, high = -101,0°C)  sensor = transistor
> > 
> > Two minutes later, on Linux 2.6.25:
> > 
> > it87-isa-0290
> > Adapter: ISA adapter
> > VCore 1:     +1,71 V  (min =  +3,97 V, max =  +1,95 V)   ALARM
> > VCore 2:     +3,09 V  (min =  +3,82 V, max =  +1,01 V)   ALARM
> > +3.3V:       +3,07 V  (min =  +3,82 V, max =  +3,06 V)   ALARM
> > +5V:         +5,59 V  (min =  +4,27 V, max =  +5,11 V)   ALARM
> > +12V:       +13,31 V  (min = +15,62 V, max =  +7,74 V)   ALARM
> > -12V:        -2,69 V  (min =  -0,61 V, max =  +3,44 V)   ALARM
> > -5V:         -9,14 V  (min =  +3,82 V, max =  -2,62 V)   ALARM
> > Stdby:       +0,00 V  (min =  +6,37 V, max =  +5,03 V)   ALARM
> > VBat:        +3,25 V
> > fan1:       5152 RPM  (min =    0 RPM, div = 2)
> > fan2:          0 RPM  (min =    0 RPM, div = 2)
> > M/B Temp:    +35,0__C  (low  =  -7,0°C, high = -11,0°C)  sensor = transistor
> > CPU Temp:    +33,0__C  (low  = -66,0°C, high = +127,0°C)  sensor = transistor
> > Temp3:       +32,0__C  (low  = -33,0°C, high = -101,0°C)  sensor = transistor
> > 
> > Results are almost identical, but I get those ALARMs. I've Pentium4 1,4Ghz 
> > processor, module for my mainboard is BLK_DEV_VIA82CXXX. Is that a bug? Can I 
> > safely use Linux 2.6.25 or later?

No, it's not a bug. Yes, 2.6.25 can be safely used, do not worry.

The it87 driver in kernel 2.6.24 did not implement the standard alarm
reporting, so sensors 3.x (which I guess you are using) couldn't report
the alarms. This was fixed in 2.6.25, so now you see the alarms, but in
fact they were already there before.

All these alarms really mean is that you didn't bother fine-tuning your
sensors3.conf file, or you did but you forgot to run "sensors -s"
afterwards, so the low and high limits for each sensor aren't set
properly. So, if you care about the alarms, you have to edit the
configuration file. If you are lucky, we might have one for your board
already, check at http://www.lm-sensors.org/wiki/Configurations and
http://khali.linux-fr.org/devel/lm-sensors/ . But more likely you'll
have to do the work by yourself.

Note: I see that you are using a locale where a comma is used to
display decimal numbers. There's a bug in libsensors which causes some
statements of the configuration file to be parsed improperly in this
case. This is fixed in SVN already, but until 3.0.2 is released and you
upgrade to it, you should force your locale to C when running "sensors"
or "sensors -s".

-- 
Jean Delvare
