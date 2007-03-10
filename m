Return-Path: <linux-kernel-owner+w=401wt.eu-S1766903AbXCJMQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766903AbXCJMQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 07:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766916AbXCJMQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 07:16:06 -0500
Received: from lucidpixels.com ([75.144.35.66]:39980 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766903AbXCJMQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 07:16:04 -0500
Date: Sat, 10 Mar 2007 07:16:03 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: debian-user@lists.debian.org, bytes@linuxgazette.net
Subject: Intel Core Duo/Solo Temperature Monitoring Working On Intel DG965
 Motherboard
Message-ID: <Pine.LNX.4.64.0703100707320.3807@p34.internal.lan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-583885355-1173528963=:3807"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-583885355-1173528963=:3807
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE

DISCLAIMER: This patch is still experimental.=20
AUTHOR: Rudolf Marek has written the coretemp module for Intel Core Duo/Sol=
o
processors.

Without this patch, you cannot monitor your CPU temperature, at least not=
=20
on a DG965 motherboard.

From=20the readme (second patch):

+Kernel driver coretemp
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Supported chips:
+  * All Intel Core family
+    Prefix: 'coretemp'
+    Addresses scanned: CPUID (family 0x6, models 0xe, 0xf)
+    Datasheet: Intel 64 and IA-32 Architectures Software Developer's Manua=
l
+               Volume 3A: System Programming Guide
+
+Author: Rudolf Marek
+Contact: Rudolf Marek <edited_out>

+Description
+-----------
+
+This driver permits reading temperature sensor embedded inside Intel Core =
CPU.
+Temperature is measured in degrees Celsius and measurement resolution is
+1 degree C. Valid temperatures are from 0 to TjMax degrees C, because
+the actual temperature is in fact a delta from TjMax.
+
+Temperature known as TjMax is the maximum junction temperature of processo=
r.
+Intel defines this temperature as 85C or 100C. At this temperature, protec=
tion
+mechanism will perform actions to forcibly cool down the processor. Alarm
+may be raised, if the temperature grows enough (more than TjMax) to trigge=
r
+the Out-Of-Spec bit. Following table summarizes the exported sysfs files:
+
+temp1_input     - Core temperature (in milidegrees of Celsius).
+temp1_crit      - Maximum junction temperature  (in milidegrees of Celsius=
).
+temp1_crit_alarm - Set when Out-of-spec bit is set, never clears.
+                  Correct CPU operation is no longer guaranteed.
+temp1_label     - Contains string with the "Core X", where X is processor
+                  number.
+
+The TjMax temperature is set to 85C if undocumented model specific registe=
r
+(UMSR) 0xee has bit 30 set. If not the TjMax is 100C as documented in proc=
essor
+datasheet. Intel will not disclose this information to individuals.

How to get it working:
---------------------------------------------------------------------------=
-
Per: http://www.lm-sensors.org/wiki/Devices

Scroll down to:
Intel  =09 Core/Core2 =09 yes =09 coretemp =09 =09 =09 Integrated
sensor in CPU, patch is here.

Here is the post:
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-January/018676.html

Patch1:=20
http://lists.lm-sensors.org/pipermail/lm-sensors/attachments/20070114/e6669=
82f/attachment-0002.bin

Patch2:=20
http://lists.lm-sensors.org/pipermail/lm-sensors/attachments/20070114/e6669=
82f/attachment-0003.bin

Applies clean under 2.6.20.2:
p34:/usr/src/linux-2.6.20.2# patch -p1 < /home/user/attachment-0002.bin
patching file drivers/hwmon/coretemp.c
patching file drivers/hwmon/Kconfig
patching file drivers/hwmon/Makefile
p34:/usr/src/linux-2.6.20.2# patch -p1 < /home/user/attachment-0003.bin
patching file Documentation/hwmon/coretemp
p34:/usr/src/linux-2.6.20.2#

In the Kernel I selected the following two options under:
-> Hardware Monitoring support
    <M> Hardware Monitoring support
    <M> Intel Core (2) Duo/Solo temperature sensor

Then recompile/reboot/etc.

You will need:
http://dl.lm-sensors.org/lm-sensors/releases/lm_sensors-2.10.2.tar.gz

1. You will need to remove or overwrite your old libsensors3 if you have it
installed.
2. You need to make sure you have libsysfs-dev and flex installed to compil=
e
the latest lm_sensors.

Once everything is compiled, load the modules and run sensors:

p34:~# modprobe coretemp
p34:~# lsmod
Module                  Size  Used by
coretemp                5120  0
hwmon                   2372  1 coretemp
p34:~#

root@p34:~/lm_sensors-2.10.2/prog/sensors# ./sensors=20
coretemp-isa-0000
Adapter: ISA adapter
temp1:       +40=B0C  (high =3D   +85=B0C) (Core 1/2)

coretemp-isa-0001
Adapter: ISA adapter
temp1:       +39=B0C  (high =3D   +85=B0C) (Core 2/2)

Run 10 bzip2s to test to make sure its working correctly.

root@p34:~/lm_sensors-2.10.2/lib$ ps auxww | grep -v grep | grep -c bzip2
10
root@p34:~/lm_sensors-2.10.2/lib$

Watch temps:

root@p34:~/lm_sensors-2.10.2/prog/sensors# ./sensors=20
Adapter: ISA adapter
temp1:       +54=B0C  (high =3D   +85=B0C)
temp1:       +53=B0C  (high =3D   +85=B0C)

( .. a few minutes later .. )

temp1:       +57=B0C  (high =3D   +85=B0C)=20
temp1:       +55=B0C  (high =3D   +85=B0C)

( .. a few minutes later .. )

temp1:       +58=B0C  (high =3D   +85=B0C)=20
temp1:       +57=B0C  (high =3D   +85=B0C)

( .. a few minutes later .. )

temp1:       +60=B0C  (high =3D   +85=B0C)=20
temp1:       +58=B0C  (high =3D   +85=B0C)

( .. a few minutes later .. )

temp1:       +62=B0C  (high =3D   +85=B0C)=20
temp1:       +60=B0C  (high =3D   +85=B0C)

root@p34:~/lm_sensors-2.10.2/lib$ killall -9 bzip2

temp1:       +52=B0C  (high =3D   +85=B0C)=20
temp1:       +51=B0C  (high =3D   +85=B0C)

( .. a few minutes later .. )

temp1:       +48=B0C  (high =3D   +85=B0C)=20
temp1:       +48=B0C  (high =3D   +85=B0C)

Setup:

p34:~# sensors=20
coretemp-isa-0000
Adapter: ISA adapter
temp1:       +41=B0C  (high =3D   +85=B0C)

coretemp-isa-0001
Adapter: ISA adapter
temp1:       +39=B0C  (high =3D   +85=B0C)

p34:~#

Commentary:
It will probably be a few weeks until this is incorporated into Linus'=20
tree, hopefully it can make it into 2.6.22, then userland support should=20
follow over time.

p34:~# mbmon
No Hardware Monitor found!!
InitMBInfo: Success
p34:~#

Justin.


---1463747160-583885355-1173528963=:3807--
