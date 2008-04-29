Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbYD2W7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbYD2W7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:59:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbYD2W7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:59:03 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:64167 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbYD2W7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Y2Te6URq7SsCBxKOl4gCOD7YRBF9Yhs/dfkVm7chm/BpDighW5ldkXKtaE9CrN1wp6BXwRJbTmqEHvOPsyz7XM2X35J7zwWuIaQVawcCIAUxDeNOwuCLqtVRBk7owHtjzqb5FwzZczKW7axWGsY+a0ydWXL7Xt7o6r/XvzIZPQE=
Message-ID: <e85b9d30804291558r4051f1bbm9256aa2af2d86b6c@mail.gmail.com>
Date: Wed, 30 Apr 2008 00:58:50 +0200
From: Matthew <jackdachef@gmail.com>
To: "Rudolf Marek" <r.marek@assembler.cz>
Subject: Re: Linux 2.6.25 (coretemp reads high temperatures)
Cc: "Jean Delvare" <khali@linux-fr.org>,
       "Maxim Levitsky" <maximlevitsky@gmail.com>, trenn@suse.de,
       "Kasper Sandberg" <lkml@metanurb.dk>, "Len Brown" <lenb@kernel.org>,
       linux-acpi@vger.kernel.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Zhang, Rui" <rui.zhang@intel.com>
In-Reply-To: <48179DB4.8040701@assembler.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e85b9d30804180837y39c52e26i588e4b67c87a5e9d@mail.gmail.com>
	 <200804182151.49021.lenb@kernel.org>
	 <200804231143.10875.maximlevitsky@gmail.com>
	 <1209406784.11608.15.camel@localhost>
	 <1209474423.1784.837.camel@queen.suse.de>
	 <20080429170824.09540206@hyperion.delvare>
	 <48179DB4.8040701@assembler.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>  Hi all,
>
>  I already answered this thread while ago. I can just confirm what Jean told.
>
>
>  >>>> I confirm this.
>  >>>> I *know* that temperatures reported now are wrong.
>  >
>  > And how do you know? The newly reported temperatures could be correct
>  > and the previous ones were incorrect (that's actually the case.) The
>  > thing is, the temperature is stored as a relative value in the CPU.
>  > Relative to what, depends on the CPU model, can be 85°C or 100°C. Up to
>  > kernel 2.6.24 we had a set of rules to find out, in 2.6.25 we have a
>  > presumably better heuristic. So some people have seen their CPU
>  > temperature climb by 15°C and others drop by 15°C, that's expected.
>
>  Yes exactly. I decided to move to 0-100C scale, and move the limit too.
>  Of course some users with too low jumped to better scale some like you seems to
>  complain now.
>
>
>  >>> i have watercooling, and well :P when i touch the "tube", its normal
>  >>> room temperature, and believe me, i would notice if it was 45.. this is
>  >>> with my cpu at idle - at full load on all 4 cores, temp2 says 35, and
>  >>> ~60 on coretemp, and THIS i would surely be able to notice over room
>  >>> temp :)
>  >
>  > The coretemp driver reports the CPU _core_ temperature. That's not
>  > something you can touch, believe me (unless you are an electron.)
>  >
>  > Also note that the CPU temperature reported by the IT8718F may or may
>  > not match the reality. To make sure, you'd need to know the type of
>  > thermal diode expected by the IT8718F, the type of thermal diode in
>  > your CPU, compute the correction factor if there is one. And you'd need
>  > to know where the thermal diode is exactly. It is most certainly built
>  > into the CPU, but some motherboard makers are doing weird things.
>  >
>  > 22°C seems very low to me, even for water-cooling. Note that
>  > non-linearity of thermal diodes makes measurements inaccurate as they
>  > get away from the expected operating point. I guess that thermal diodes
>  > used in CPUs are calibrated for best results around the expected
>  > temperature when using air-cooling, rather than water-cooling.
>  >
>  >>> any progress on this bug?
>  >
>  > I still need to be convinced that there is a bug here.
>
>  It is not a bug, a max limit changed too, it is just matter how to scale it. The
>  temperature is non-physical so comparing it to physical temperature does not
>  make any sense. I'm sorry I did not invent this relative temp stuff - Complain
>  @intel. They have some calibration of TjMAX for mobiles, but this bit does not
>  work for desktops/servers. I tried really hard to get at LEAST some
>  documentation so the driver looks like it looks. And not
>  guessed/guessed/guessed/how it looked earlier.
>
>
>  >
>  >>>> The reason is that bios did report same temperatures as coretemp in 2.6.24,
>  >>>> moreover some time ago I have run a cpu tool (don't remember its name) on windows
>
>  It was most likely coretemp - I'm in contact with the guy. We share infos.
>
>
>  >>>> temperature of both cores
>  >>>> (I had to run this on windows - intel haven't released
>  >>>> drivers for their QST for temperature monitoring from bios - very sad)
>  >>>>
>  >>>> And the driver did say in kernel log that TJMAX is 85C
>  >
>  > Which driver, which kernel? As I wrote above, the coretemp heuristic
>  > changed in kernel 2.6.25, so the fact that a previous kernel was
>  > reporting a different tjmax value is irrelevant. Unless you have
>  > additional documentation from Intel, I would tend to believe that the
>  > coretemp driver in 2.6.25 is correct. But feel free to report the exact
>  > CPU model you have (with CPUID info) to Rudolf, if he gets enough
>  > reports about a specific CPU model which most people believe gets the
>  > wrong tjmax, he can fix the driver.
>
>  Well again, I tried hard at Intel and I really could not get any info on some
>  calibration bit. The temperature is non-physical on arbitrary scale. I changed
>  that so for some people it jumped to 100C, for some it remained.
>
>
>  >>>> Lets at least make a kernel option to override tjmax?
>  >
>  > That's a possibility for sure, but what we would really need is to
>  > adjust the coretemp driver heuristics to always get it right - if
>  > that's not already the case, that is. I'll let Rudolf decide anyway.
>
>  Well again, Intel swears there is no way how to get the TjMAX for
>  desktops/servers. It sucks but this is not my fault.
>
>  Thanks,
>  Rudolf
>


Hi Rudolf, hi @ all,

so we were just too concerned all the time & even though the
temperatures seem too high there's nothing to worry ?

I'd be more tranquilized if I had the old temperatures ;)
but like lm_sensors's output states - it's not bad until  I / we're
getting temperatures from 85°C (?) [in this particular case], ...


@lkml, Linus:

sorry for all the noise ;)



Len,

here's the output of sensors (lm_sensors):

with acpi thermal-support compiled in:

w83627ehf-isa-0290
Adapter: ISA adapter
VCore:       +1.12 V  (min =  +0.00 V, max =  +1.74 V)
in1:        +12.36 V  (min = +13.46 V, max = +13.46 V)   ALARM
AVCC:        +3.34 V  (min =  +4.08 V, max =  +2.03 V)   ALARM
3VCC:        +3.34 V  (min =  +3.92 V, max =  +3.95 V)   ALARM
in4:         +1.70 V  (min =  +1.53 V, max =  +2.04 V)
in5:         +1.59 V  (min =  +2.04 V, max =  +1.02 V)   ALARM
in6:         +5.12 V  (min =  +6.53 V, max =  +6.32 V)   ALARM
VSB:         +3.26 V  (min =  +3.06 V, max =  +4.08 V)
VBAT:        +3.20 V  (min =  +4.02 V, max =  +4.02 V)   ALARM
in9:         +1.61 V  (min =  +2.04 V, max =  +2.04 V)   ALARM
Case Fan:      0 RPM  (min =    0 RPM, div = 128)
CPU Fan:     969 RPM  (min =    0 RPM, div = 8)
Aux Fan:    3970 RPM  (min =    0 RPM, div = 2)
fan4:          0 RPM  (min =   83 RPM, div = 128)  ALARM
fan5:       1308 RPM  (min =    0 RPM, div = 8)
Sys Temp:    +39.0°C  (high = +123.0°C, hyst = -65.0°C)  sensor = thermistor
CPU Temp:    +29.0°C  (high = +80.0°C, hyst = +75.0°C)  sensor = diode
AUX Temp:   +121.5°C  (high = +80.0°C, hyst = +75.0°C)  ALARM  sensor
= thermistor
cpu0_vid:   +1.350 V

coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +60.0°C  (high = +84.0°C, crit = +100.0°C)

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +57.0°C  (high = +84.0°C, crit = +100.0°C)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

and without:

w83627ehf-isa-0290
Adapter: ISA adapter
VCore:       +1.30 V  (min =  +0.00 V, max =  +1.74 V)
in1:        +12.30 V  (min = +13.46 V, max = +13.46 V)   ALARM
AVCC:        +3.36 V  (min =  +4.08 V, max =  +2.03 V)   ALARM
3VCC:        +3.34 V  (min =  +3.92 V, max =  +3.95 V)   ALARM
in4:         +1.70 V  (min =  +1.53 V, max =  +2.04 V)
in5:         +1.59 V  (min =  +2.04 V, max =  +1.02 V)   ALARM
in6:         +5.12 V  (min =  +6.53 V, max =  +6.32 V)   ALARM
VSB:         +3.26 V  (min =  +3.06 V, max =  +4.08 V)
VBAT:        +3.20 V  (min =  +4.02 V, max =  +4.02 V)   ALARM
in9:         +1.61 V  (min =  +2.04 V, max =  +2.04 V)   ALARM
Case Fan:      0 RPM  (min =    0 RPM, div = 128)
CPU Fan:     986 RPM  (min =    0 RPM, div = 8)
Aux Fan:    3970 RPM  (min =    0 RPM, div = 2)
fan4:          0 RPM  (min =   83 RPM, div = 128)  ALARM
fan5:       1308 RPM  (min =    0 RPM, div = 8)
Sys Temp:    +39.0°C  (high = +123.0°C, hyst = -65.0°C)  sensor = thermistor
CPU Temp:    +29.0°C  (high = +80.0°C, hyst = +75.0°C)  sensor = diode
AUX Temp:   +117.0°C  (high = +80.0°C, hyst = +75.0°C)  ALARM  sensor
= thermistor
cpu0_vid:   +1.375 V

coretemp-isa-0000
Adapter: ISA adapter
Core 0:      +60.0°C  (high = +84.0°C, crit = +100.0°C)

coretemp-isa-0001
Adapter: ISA adapter
Core 1:      +58.0°C  (high = +84.0°C, crit = +100.0°C)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

it's the completely same temperatures - it had no effect on the
"correctness" of the output


thanks to everyone

Regards

Mat
