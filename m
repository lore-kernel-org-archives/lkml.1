Return-Path: <linux-kernel-owner+w=401wt.eu-S1757838AbXHELXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbXHELXX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 07:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbXHELXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 07:23:14 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:55826 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974AbXHELXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 07:23:13 -0400
Message-ID: <46B5B277.8060402@gmail.com>
Date: Sun, 05 Aug 2007 13:20:23 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Joerg Sommrey <jo@sommrey.de>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: bad temperature values from w83781d in 2.6.22
References: <20070805102604.GA9123@sommrey.de>
In-Reply-To: <20070805102604.GA9123@sommrey.de>
Content-Type: multipart/mixed;
 boundary="------------050109000501070707060204"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050109000501070707060204
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit

On 08/05/2007 12:26 PM, Joerg Sommrey wrote:

> after upgrading from 2.6.21 to 2.6.22 the CPU temperatures shown by
> w83781d look unreal.  They were in a range from 40캜 when idle to
> 75캜 under full load with 2.6.21.  The values shown now are in a very
> small range from 77캜 to 82캜.  From the (low) noise of the fan I can
> tell that the temperature is <50캜.
> The third temperature shown is completely wrong.
> 
> I have a Tyan Tiger MPX board with a w83782d chip. Output from
> "sensors":
> 
> w83782d-i2c-0-2d
> Adapter: SMBus AMD768 adapter at 80e0

As a datapoint, the same W83782D on AMD756 (also I2C) works correctly with 
2.6.22:

w83782d-i2c-0-2d
Adapter: SMBus AMD756 adapter at 50e0

Jean Delvare recently worked on the ISA interface to these chips but it 
seems this would not be the cause if you are also using I2C. Our hardware 
appears rather identical...

I've attached (an excerpt of) my /etc/sensors.conf -- I once dug through the 
datasheets for those compute lines for example so perhaps its still useful 
even if 2.6.21 working for you probably means you don't have a config problem.

Rene.


--------------050109000501070707060204
Content-Type: text/plain;
 name="sensors.out"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="sensors.out"

w83782d-i2c-0-2d
Adapter: SMBus AMD756 adapter at 50e0
Vcore:     +1.79 V  (min =  +1.74 V, max =  +1.86 V)              (beep)
Vcache:    +2.54 V  (min =  +2.26 V, max =  +2.75 V)              (beep)
Vcc3:      +3.38 V  (min =  +2.98 V, max =  +3.63 V)              (beep)
+5V:       +4.92 V  (min =  +4.49 V, max =  +5.51 V)              (beep)
+12V:     +12.28 V  (min = +10.82 V, max = +13.19 V)              (beep)
-12V:     -12.28 V  (min = -14.42 V, max =  -9.57 V)              (beep)
-5V:       -5.45 V  (min =  -6.00 V, max =  -3.99 V)              (beep)
+5V SB:    +5.16 V  (min =  +4.49 V, max =  +5.51 V)              (beep)
Battery:   +3.31 V  (min =  +2.40 V, max =  +3.60 V)              (beep)
Sys Fan:  1548 RPM  (min = 1350 RPM, div = 4)                     (beep)
CPU Fan:  2191 RPM  (min = 1985 RPM, div = 4)                     (beep)
Sys Temp:    +47째C  (high =   +55째C, hyst =   +52째C)   sensor = thermistor           (beep)
CPU Temp:  +48.5째C  (high =   +60째C, hyst =   +57째C)   sensor = thermistor           (beep)
vid:      +1.750 V  (VRM Version 9.0)
alarms:   
beep_enable:
          Sound alarm enabled


--------------050109000501070707060204
Content-Type: text/plain;
 name="sensors.conf"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sensors.conf"

# Gigabyte GA-7IXE4
chip "w83782d-*"

#   BIOS labels
 
    label in0 "Vcore"
    label in1 "Vcache"
    label in2 "Vcc3"
    label in3 "+5V"
    label in4 "+12V"
    label in5 "-12V"
    label in6 "-5V"
    label in7 "+5V SB"
    label in8 "Battery"

#   W83782D datasheet

    compute in3 @ * (34 + 50) / 50 , @ * 50 / (34 + 50)
    compute in4 @ * (28 + 10) / 10 , @ * 10 / (28 + 10)
    compute in5 (@ - 3.6) * (232 + 56) / 56 + 3.6 , (@ - 3.6) * 56 / (232 + 56) + 3.6
    compute in6 (@ - 3.6) * (120 + 56) / 56 + 3.6 , (@ - 3.6) * 56 / (120 + 56) + 3.6
    compute in7 @ * (34 + 50) / 50 , @ * 50 / (34 + 50)

#   Duron datasheet, VID. D3 = 1.6 +/- .1, D7 = 1.75 +/- .05 (but do 1.80 +/- 0.05)

    set in0_min 1.75
    set in0_max 1.85

#   Duron datasheet, VCCA. D3 = D7 = 2.5 +/- .25
	
    set in1_min 2.25
    set in1_max 2.75

#   Leave 10% for all

    set in2_min 3.3 * 0.9
    set in2_max 3.3 * 1.1

    set in3_min 5.0 * 0.9
    set in3_max 5.0 * 1.1

    set in4_min 12.0 * 0.9
    set in4_max 12.0 * 1.1

#   20 % for negative voltages

    set in5_min -12.0 * 1.2 
    set in5_max -12.0 * 0.8

    set in6_min -5.0 * 1.2
    set in6_max -5.0 * 0.8

    set in7_min 5.0 * 0.9
    set in7_max 5.0 * 1.1

#   20% for battery

    set in8_min 3.0 * 0.8
    set in8_max 3.0 * 1.2		

    label temp1 "Sys Temp"
    label temp2 "CPU Temp"

    set temp1_over 55
    set temp1_hyst 52
		
#   Have temp2 (CPU) compliant with the BIOS readout
    compute temp2 @-10,@+10
						
    set temp2_over 60 
    set temp2_hyst 57

#   Not connected
    ignore temp3	

    label fan1 "Sys Fan"
    label fan2 "CPU Fan"
    label fan3 "Pow Fan"

    set fan1_div 4 # min RPM = 1.35 x 10^6 / (div * 255) = 1323 (255 == max count)
    set fan2_div 4 # min RPM = 1.35 x 10^6 / (div * 255) = 1323 (255 == max count)
    set fan3_div 4 # min RPM = 1.35 x 10^6 / (div * 255) = 1323 (255 == max count)

    set fan1_min 1500 * 0.9 # 1500 RPM fan
    set fan2_min 2200 * 0.9 # 2200 RPM fan
#   set fan3_min nnnn * 0.9 # nnnn RPM fan

#   No readout on HD (Pow) fan
    ignore fan3

#   0x000001: in0
#   0x000002: in1
#   0x000004: in2
#   0x000008: in3
#   0x000010: temp1
#   0x000020: temp2 (+temp3 on W83781D)
#   0x000040: fan1
#   0x000080: fan2
#   0x000100: in4
#   0x000200: in5
#   0x000400: in6 
#   0x000800: fan3 
#   0x001000: chassis
#   0x002000: temp3 (W83782D and W83627HF only)
#   0x010000: in7 (W83782D and W83627HF only)
#   0x020000: in8 (W83782D and W83627HF only)

    set beeps 198655 # 0x0307ff
    set beep_enable 1

--------------050109000501070707060204--
