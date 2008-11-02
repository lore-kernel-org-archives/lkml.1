Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbYKBUag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbYKBUag (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 15:30:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYKBUa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 15:30:27 -0500
Received: from qw-out-2122.google.com ([74.125.92.25]:18979 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbYKBUaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 15:30:21 -0500
Date: Sun, 2 Nov 2008 15:30:09 -0500
From: "Michael B. Trausch" <mike@trausch.us>
To: linux-kernel@vger.kernel.org
Subject: AMD64 reboot regression
Message-ID: <20081102153009.6b1f2ab4@zest>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
X-Face: V.VYf~Py*A]A=Ig&q'ryc:4rZ;J![}&08<H1=7E_.O\dF8Pbw,VE~_9QSzcs]DSM%TGA4j\
 .0/Sz8G(4s<D2VQ/uwq$dEL]LbY/y5TYyD$/6It5Yv#c=zo>wpW.<5dFb>I:aB^uO~EL+FT]m5[I4H
 s,s=
X-Operating-System: Ubuntu 8.10 (Intrepid Ibex)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/x+KKzZfuFzZhjhakHNub3ZX";
 protocol="application/pgp-signature"; micalg=PGP-RIPEMD160
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/x+KKzZfuFzZhjhakHNub3ZX
Content-Type: multipart/mixed; boundary="MP_/d8yPooacxzVcitpxRML4kKi"

--MP_/d8yPooacxzVcitpxRML4kKi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I started testing 2.6.28 with -rc1 on my system (x86-64, AMD Phenom
9500 Quad Core CPU) and found that I was unable to reboot, though I was
able to with the Ubuntu-provided 2.6.27 kernel.  I have found that a
commit on 17-Oct-2008 (commit 8fd145917fb62368a9b80db59562c20576238f5a)
is responsible for this failure to reboot.  Reversing this single change
on my local kernel (current git tree plus this patch) has enabled me to
reboot again.

System board information is attached in the hopes that it will be found
helpful; if any other information is necessary please let me know.

The patch that reverts this change is attached, with stat:

 drivers/acpi/reboot.c |   25 +++----------------------
 1 files changed, 3 insertions(+), 22 deletions(-)

	--- Mike

--=20
My sigfile ran away and is on hiatus.
http://www.trausch.us/

--MP_/d8yPooacxzVcitpxRML4kKi
Content-Type: text/plain; name=lshal.output
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=lshal.output


Dumping 132 device(s) from the Global Device List:
-------------------------------------------------
udi =3D '/org/freedesktop/Hal/devices/computer'
  info.addons =3D {'hald-addon-cpufreq', 'hald-addon-acpi'} (string list)
  info.callouts.add =3D {'hal-acl-tool --remove-all', 'hal-storage-cleanup-=
all-mountpoints'} (string list)
  info.callouts.session_active =3D {'hal-acl-tool --reconfigure'} (string l=
ist)
  info.callouts.session_add =3D {'hal-acl-tool --reconfigure'} (string list)
  info.callouts.session_inactive =3D {'hal-acl-tool --reconfigure'} (string=
 list)
  info.callouts.session_remove =3D {'hal-acl-tool --reconfigure'} (string l=
ist)
  info.capabilities =3D {'cpufreq_control'} (string list)
  info.interfaces =3D {'org.freedesktop.Hal.Device.SystemPowerManagement', =
'org.freedesktop.Hal.Device.CPUFreq'} (string list)
  info.product =3D 'Computer'  (string)
  info.subsystem =3D 'unknown'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer'  (string)
  org.freedesktop.Hal.Device.SystemPowerManagement.method_argnames =3D {'nu=
m_seconds_to_sleep', 'num_seconds_to_sleep', '', '', '', 'enable_power_save=
'} (string list)
  org.freedesktop.Hal.Device.SystemPowerManagement.method_execpaths =3D {'h=
al-system-power-suspend', 'hal-system-power-suspend-hybrid', 'hal-system-po=
wer-hibernate', 'hal-system-power-shutdown', 'hal-system-power-reboot', 'ha=
l-system-power-set-power-save'} (string list)
  org.freedesktop.Hal.Device.SystemPowerManagement.method_names =3D {'Suspe=
nd', 'SuspendHybrid', 'Hibernate', 'Shutdown', 'Reboot', 'SetPowerSave'} (s=
tring list)
  org.freedesktop.Hal.Device.SystemPowerManagement.method_signatures =3D {'=
i', 'i', '', '', '', 'b'} (string list)
  power_management.acpi.linux.version =3D '20080926'  (string)
  power_management.can_hibernate =3D false  (bool)
  power_management.can_suspend =3D false  (bool)
  power_management.can_suspend_hybrid =3D false  (bool)
  power_management.is_powersave_set =3D false  (bool)
  power_management.type =3D 'acpi'  (string)
  system.chassis.manufacturer =3D 'To Be Filled By O.E.M.'  (string)
  system.chassis.type =3D 'Desktop'  (string)
  system.firmware.release_date =3D '01/22/2008'  (string)
  system.firmware.vendor =3D 'American Megatrends Inc.'  (string)
  system.firmware.version =3D 'P2.20'  (string)
  system.formfactor =3D 'desktop'  (string)
  system.hardware.primary_video.product =3D 1339  (0x53b)  (int)
  system.hardware.primary_video.vendor =3D 4318  (0x10de)  (int)
  system.hardware.product =3D 'To Be Filled By O.E.M.'  (string)
  system.hardware.serial =3D 'To Be Filled By O.E.M.'  (string)
  system.hardware.uuid =3D '00020003-0004-0005-0006-000700080009'  (string)
  system.hardware.vendor =3D 'To Be Filled By O.E.M.'  (string)
  system.hardware.version =3D 'To Be Filled By O.E.M.'  (string)
  system.kernel.machine =3D 'x86_64'  (string)
  system.kernel.name =3D 'Linux'  (string)
  system.kernel.version =3D '2.6.28-rc2-00474-g4129d53'  (string)

udi =3D '/org/freedesktop/Hal/devices/acpi_P001'
  info.capabilities =3D {'processor'} (string list)
  info.category =3D 'processor'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'AMD Phenom(tm) 9500 Quad-Core Processor'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/acpi_P001'  (string)
  linux.acpi_path =3D '/proc/acpi/processor/P001'  (string)
  linux.acpi_type =3D 1  (0x1)  (int)
  linux.hotplug_type =3D 4  (0x4)  (int)
  processor.can_throttle =3D false  (bool)
  processor.number =3D 0  (0x0)  (int)

udi =3D '/org/freedesktop/Hal/devices/acpi_P002'
  info.capabilities =3D {'processor'} (string list)
  info.category =3D 'processor'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'AMD Phenom(tm) 9500 Quad-Core Processor'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/acpi_P002'  (string)
  linux.acpi_path =3D '/proc/acpi/processor/P002'  (string)
  linux.acpi_type =3D 1  (0x1)  (int)
  linux.hotplug_type =3D 4  (0x4)  (int)
  processor.can_throttle =3D false  (bool)
  processor.number =3D 1  (0x1)  (int)

udi =3D '/org/freedesktop/Hal/devices/acpi_P003'
  info.capabilities =3D {'processor'} (string list)
  info.category =3D 'processor'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'AMD Phenom(tm) 9500 Quad-Core Processor'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/acpi_P003'  (string)
  linux.acpi_path =3D '/proc/acpi/processor/P003'  (string)
  linux.acpi_type =3D 1  (0x1)  (int)
  linux.hotplug_type =3D 4  (0x4)  (int)
  processor.can_throttle =3D false  (bool)
  processor.number =3D 2  (0x2)  (int)

udi =3D '/org/freedesktop/Hal/devices/acpi_P004'
  info.capabilities =3D {'processor'} (string list)
  info.category =3D 'processor'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'AMD Phenom(tm) 9500 Quad-Core Processor'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/acpi_P004'  (string)
  linux.acpi_path =3D '/proc/acpi/processor/P004'  (string)
  linux.acpi_type =3D 1  (0x1)  (int)
  linux.hotplug_type =3D 4  (0x4)  (int)
  processor.can_throttle =3D false  (bool)
  processor.number =3D 3  (0x3)  (int)

udi =3D '/org/freedesktop/Hal/devices/computer_alsa_timer'
  access_control.file =3D '/dev/snd/timer'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.device_file =3D '/dev/snd/timer'  (string)
  alsa.type =3D 'timer'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'ALSA Timer Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer_alsa_timer'  (string)
  linux.device_file =3D '/dev/snd/timer'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/virtual/sound/timer'  (string)

udi =3D '/org/freedesktop/Hal/devices/computer_oss_sequencer_0'
  access_control.file =3D '/dev/sequencer2'  (string)
  access_control.type =3D 'sound'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'oss', 'access_control'} (string list)
  info.category =3D 'oss'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'OSS Sequencer Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer_oss_sequencer_0'  (st=
ring)
  linux.device_file =3D '/dev/sequencer2'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/virtual/sound/sequencer2'  (string)
  oss.device_file =3D '/dev/sequencer2'  (string)
  oss.type =3D 'sequencer'  (string)

udi =3D '/org/freedesktop/Hal/devices/computer_oss_sequencer'
  access_control.file =3D '/dev/sequencer'  (string)
  access_control.type =3D 'sound'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'oss', 'access_control'} (string list)
  info.category =3D 'oss'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'OSS Sequencer Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer_oss_sequencer'  (stri=
ng)
  linux.device_file =3D '/dev/sequencer'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/virtual/sound/sequencer'  (string)
  oss.device_file =3D '/dev/sequencer'  (string)
  oss.type =3D 'sequencer'  (string)

udi =3D '/org/freedesktop/Hal/devices/computer_alsa_sequencer'
  access_control.file =3D '/dev/snd/seq'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.device_file =3D '/dev/snd/seq'  (string)
  alsa.type =3D 'sequencer'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'ALSA Sequencer Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer_alsa_sequencer'  (str=
ing)
  linux.device_file =3D '/dev/snd/seq'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/virtual/sound/seq'  (string)

udi =3D '/org/freedesktop/Hal/devices/computer_logicaldev_input_0'
  button.has_state =3D false  (bool)
  button.type =3D 'power'  (string)
  info.addons.singleton =3D {'hald-addon-input'} (string list)
  info.capabilities =3D {'input', 'button'} (string list)
  info.category =3D 'input'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Power Button (CM)'  (string)
  info.subsystem =3D 'input'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer_logicaldev_input_0'  =
(string)
  input.device =3D '/dev/input/event1'  (string)
  input.product =3D 'Power Button (CM)'  (string)
  linux.device_file =3D '/dev/input/event1'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'input'  (string)
  linux.sysfs_path =3D '/sys/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input=
/input1/event1'  (string)

udi =3D '/org/freedesktop/Hal/devices/computer_logicaldev_input'
  button.has_state =3D false  (bool)
  button.type =3D 'power'  (string)
  info.addons.singleton =3D {'hald-addon-input'} (string list)
  info.capabilities =3D {'input', 'button'} (string list)
  info.category =3D 'input'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Power Button (FF)'  (string)
  info.subsystem =3D 'input'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/computer_logicaldev_input'  (s=
tring)
  input.device =3D '/dev/input/event0'  (string)
  input.product =3D 'Power Button (FF)'  (string)
  linux.device_file =3D '/dev/input/event0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'input'  (string)
  linux.sysfs_path =3D '/sys/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0/e=
vent0'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c01'
  info.linux.driver =3D 'system'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'System Board'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c01'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:0d'  (string)
  pnp.description =3D 'System Board'  (string)
  pnp.id =3D 'PNP0c01'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02_2'
  info.linux.driver =3D 'system'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'General ID for reserving resources required by PnP moth=
erboard registers. (Not device specific.)'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02_2'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:0c'  (string)
  pnp.description =3D 'General ID for reserving resources required by PnP m=
otherboard registers. (Not device specific.)'  (string)
  pnp.id =3D 'PNP0c02'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02_1'
  info.linux.driver =3D 'system'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'General ID for reserving resources required by PnP moth=
erboard registers. (Not device specific.)'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02_1'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:0b'  (string)
  pnp.description =3D 'General ID for reserving resources required by PnP m=
otherboard registers. (Not device specific.)'  (string)
  pnp.id =3D 'PNP0c02'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0501'
  info.linux.driver =3D 'serial'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D '16550A-compatible COM port'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0501'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:0a'  (string)
  pnp.description =3D '16550A-compatible COM port'  (string)
  pnp.id =3D 'PNP0501'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0501_serial_platform_0'
  info.capabilities =3D {'serial'} (string list)
  info.category =3D 'serial'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pnp_PNP0501'  (string)
  info.product =3D '16550A-compatible COM port'  (string)
  info.subsystem =3D 'tty'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0501_serial_platform_0'=
  (string)
  linux.device_file =3D '/dev/ttyS0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'tty'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:0a/tty/ttyS0'  (string)
  serial.device =3D '/dev/ttyS0'  (string)
  serial.originating_device =3D '/org/freedesktop/Hal/devices/pnp_PNP0501' =
 (string)
  serial.port =3D 0  (0x0)  (int)
  serial.type =3D 'platform'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0303'
  info.linux.driver =3D 'i8042 kbd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'IBM Enhanced (101/102-key, PS/2 mouse support)'  (strin=
g)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0303'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:09'  (string)
  pnp.description =3D 'IBM Enhanced (101/102-key, PS/2 mouse support)'  (st=
ring)
  pnp.id =3D 'PNP0303'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02_0'
  info.linux.driver =3D 'system'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'General ID for reserving resources required by PnP moth=
erboard registers. (Not device specific.)'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02_0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:08'  (string)
  pnp.description =3D 'General ID for reserving resources required by PnP m=
otherboard registers. (Not device specific.)'  (string)
  pnp.id =3D 'PNP0c02'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0b00'
  info.linux.driver =3D 'rtc_cmos'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'AT Real-Time Clock'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0b00'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:07'  (string)
  pnp.description =3D 'AT Real-Time Clock'  (string)
  pnp.id =3D 'PNP0b00'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02'
  info.linux.driver =3D 'system'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'General ID for reserving resources required by PnP moth=
erboard registers. (Not device specific.)'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c02'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:06'  (string)
  pnp.description =3D 'General ID for reserving resources required by PnP m=
otherboard registers. (Not device specific.)'  (string)
  pnp.id =3D 'PNP0c02'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0401'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'ECP printer port'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0401'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:05'  (string)
  pnp.description =3D 'ECP printer port'  (string)
  pnp.id =3D 'PNP0401'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0700'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'PC standard floppy disk controller'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0700'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:04'  (string)
  pnp.description =3D 'PC standard floppy disk controller'  (string)
  pnp.id =3D 'PNP0700'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c04'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Math Coprocessor'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0c04'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:03'  (string)
  pnp.description =3D 'Math Coprocessor'  (string)
  pnp.id =3D 'PNP0c04'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0800'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'AT-style speaker sound'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0800'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:02'  (string)
  pnp.description =3D 'AT-style speaker sound'  (string)
  pnp.id =3D 'PNP0800'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0200'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'AT DMA Controller'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0200'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:01'  (string)
  pnp.description =3D 'AT DMA Controller'  (string)
  pnp.id =3D 'PNP0200'  (string)

udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0a03'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'PCI Bus'  (string)
  info.subsystem =3D 'pnp'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pnp_PNP0a03'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pnp'  (string)
  linux.sysfs_path =3D '/sys/devices/pnp0/00:00'  (string)
  pnp.description =3D 'PCI Bus'  (string)
  pnp.id =3D 'PNP0a03'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_w83627ehf_656'
  info.linux.driver =3D 'w83627ehf'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Platform Device (w83627ehf.656)'  (string)
  info.subsystem =3D 'platform'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_w83627ehf_656'  (stri=
ng)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'platform'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/w83627ehf.656'  (string)
  platform.id =3D 'w83627ehf.656'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_vesafb_0'
  info.linux.driver =3D 'vesafb'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Platform Device (vesafb.0)'  (string)
  info.subsystem =3D 'platform'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_vesafb_0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'platform'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/vesafb.0'  (string)
  platform.id =3D 'vesafb.0'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_serial8250'
  info.linux.driver =3D 'serial8250'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Platform Device (serial8250)'  (string)
  info.subsystem =3D 'platform'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_serial8250'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'platform'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/serial8250'  (string)
  platform.id =3D 'serial8250'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_pcspkr'
  info.linux.driver =3D 'pcspkr'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Platform Device (pcspkr)'  (string)
  info.subsystem =3D 'platform'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_pcspkr'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'platform'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/pcspkr'  (string)
  platform.id =3D 'pcspkr'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_pcspkr_logicaldev_input'
  info.capabilities =3D {'input'} (string list)
  info.category =3D 'input'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/platform_pcspkr'  (string)
  info.product =3D 'PC Speaker'  (string)
  info.subsystem =3D 'input'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_pcspkr_logicaldev_inp=
ut'  (string)
  input.device =3D '/dev/input/event2'  (string)
  input.originating_device =3D '/org/freedesktop/Hal/devices/platform_pcspk=
r'  (string)
  input.product =3D 'PC Speaker'  (string)
  linux.device_file =3D '/dev/input/event2'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'input'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/pcspkr/input/input2/event2'  =
(string)

udi =3D '/org/freedesktop/Hal/devices/platform_microcode'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Platform Device (microcode)'  (string)
  info.subsystem =3D 'platform'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_microcode'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'platform'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/microcode'  (string)
  platform.id =3D 'microcode'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_i8042'
  info.linux.driver =3D 'i8042'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Platform Device (i8042)'  (string)
  info.subsystem =3D 'platform'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_i8042'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'platform'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/i8042'  (string)
  platform.id =3D 'i8042'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port'
  info.linux.driver =3D 'atkbd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/platform_i8042'  (string)
  info.product =3D 'i8042 KBD port'  (string)
  info.subsystem =3D 'serio'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port'=
  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'serio'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/i8042/serio0'  (string)
  serio.description =3D 'i8042 KBD port'  (string)
  serio.id =3D 'serio0'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port_logical=
dev_input'
  info.addons.singleton =3D {'hald-addon-input'} (string list)
  info.callouts.add =3D {'debian-setup-keyboard'} (string list)
  info.capabilities =3D {'input', 'input.keyboard', 'input.keypad', 'input.=
keys', 'button'} (string list)
  info.category =3D 'input'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_po=
rt'  (string)
  info.product =3D 'AT Translated Set 2 keyboard'  (string)
  info.subsystem =3D 'input'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_i8042_i8042_KBD_port_=
logicaldev_input'  (string)
  input.device =3D '/dev/input/event3'  (string)
  input.originating_device =3D '/org/freedesktop/Hal/devices/platform_i8042=
_i8042_KBD_port'  (string)
  input.product =3D 'AT Translated Set 2 keyboard'  (string)
  input.x11_driver =3D 'evdev'  (string)
  input.xkb.layout =3D 'us'  (string)
  input.xkb.model =3D 'pc105'  (string)
  input.xkb.options =3D 'lv3:ralt_switch'  (string)
  input.xkb.rules =3D 'evdev'  (string)
  input.xkb.variant =3D 'intl'  (string)
  linux.device_file =3D '/dev/input/event3'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'input'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/i8042/serio0/input/input3/eve=
nt3'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_floppy_0'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Platform Device (floppy.0)'  (string)
  info.subsystem =3D 'platform'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_floppy_0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'platform'  (string)
  linux.sysfs_path =3D '/sys/devices/platform/floppy.0'  (string)
  platform.id =3D 'floppy.0'  (string)

udi =3D '/org/freedesktop/Hal/devices/platform_floppy_0_storage_platform_fl=
oppy'
  access_control.file =3D '/dev/fd0'  (string)
  access_control.type =3D 'removable-block'  (string)
  block.device =3D '/dev/fd0'  (string)
  block.is_volume =3D false  (bool)
  block.major =3D 2  (0x2)  (int)
  block.minor =3D 0  (0x0)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/platform_floppy_0_=
storage_platform_floppy'  (string)
  info.addons =3D {'hald-addon-storage'} (string list)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'storage', 'block', 'access_control'} (string list)
  info.category =3D 'storage'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Volume', 'org.freedeskto=
p.Hal.Device.Storage.Removable'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/platform_floppy_0'  (string)
  info.product =3D 'PC Floppy Drive'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/platform_floppy_0_storage_plat=
form_floppy'  (string)
  info.vendor =3D ''  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/platform/floppy.0/block/fd0'  (string)
  org.freedesktop.Hal.Device.Volume.method_argnames =3D {'mount_point fstyp=
e extra_options', 'extra_options', 'extra_options'} (string list)
  org.freedesktop.Hal.Device.Volume.method_execpaths =3D {'hal-storage-moun=
t', 'hal-storage-unmount', 'hal-storage-eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_names =3D {'Mount', 'Unmount', '=
Eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_signatures =3D {'ssas', 'as', 'a=
s'} (string list)
  storage.automount_enabled_hint =3D true  (bool)
  storage.bus =3D 'platform'  (string)
  storage.drive_type =3D 'floppy'  (string)
  storage.hotpluggable =3D false  (bool)
  storage.media_check_enabled =3D false  (bool)
  storage.model =3D ''  (string)
  storage.no_partitions_hint =3D true  (bool)
  storage.originating_device =3D '/org/freedesktop/Hal/devices/platform_flo=
ppy_0'  (string)
  storage.removable =3D true  (bool)
  storage.removable.media_available =3D false  (bool)
  storage.requires_eject =3D false  (bool)
  storage.size =3D 0  (0x0)  (uint64)
  storage.vendor =3D 'PC Floppy Drive'  (string)
  volume.mount.valid_options =3D {'ro', 'sync', 'dirsync', 'noatime', 'nodi=
ratime', 'noexec', 'quiet', 'remount', 'exec', 'utf8', 'shortname=3D', 'cod=
epage=3D', 'iocharset=3D', 'umask=3D', 'uid=3D'} (string list)

udi =3D '/org/freedesktop/Hal/devices/pci_1022_1204'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Family 10h [Opteron, Athlon64, Sempron] Link Control'  =
(string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1022_1204'  (string)
  info.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.4'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.4'  (string)
  pci.product =3D 'Family 10h [Opteron, Athlon64, Sempron] Link Control'  (=
string)
  pci.product_id =3D 4612  (0x1204)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  pci.vendor_id =3D 4130  (0x1022)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_1022_1203'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Family 10h [Opteron, Athlon64, Sempron] Miscellaneous C=
ontrol'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1022_1203'  (string)
  info.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.3'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.3'  (string)
  pci.product =3D 'Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Co=
ntrol'  (string)
  pci.product_id =3D 4611  (0x1203)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  pci.vendor_id =3D 4130  (0x1022)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_1022_1202'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Family 10h [Opteron, Athlon64, Sempron] DRAM Controller=
'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1022_1202'  (string)
  info.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.2'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.2'  (string)
  pci.product =3D 'Family 10h [Opteron, Athlon64, Sempron] DRAM Controller'=
  (string)
  pci.product_id =3D 4610  (0x1202)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  pci.vendor_id =3D 4130  (0x1022)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_1022_1201'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Family 10h [Opteron, Athlon64, Sempron] Address Map'  (=
string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1022_1201'  (string)
  info.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.1'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.1'  (string)
  pci.product =3D 'Family 10h [Opteron, Athlon64, Sempron] Address Map'  (s=
tring)
  pci.product_id =3D 4609  (0x1201)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  pci.vendor_id =3D 4130  (0x1022)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_1022_1200'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'Family 10h [Opteron, Athlon64, Sempron] HyperTransport =
Configuration'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1022_1200'  (string)
  info.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:18.0'  (string)
  pci.product =3D 'Family 10h [Opteron, Athlon64, Sempron] HyperTransport C=
onfiguration'  (string)
  pci.product_id =3D 4608  (0x1200)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'Advanced Micro Devices [AMD]'  (string)
  pci.vendor_id =3D 4130  (0x1022)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_53b'
  info.linux.driver =3D 'nvidia'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'GeForce 7050 PV / nForce 630a'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_53b'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:12.0'  (string)
  pci.device_class =3D 3  (0x3)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:12.0'  (string)
  pci.product =3D 'GeForce 7050 PV / nForce 630a'  (string)
  pci.product_id =3D 1339  (0x53b)  (int)
  pci.subsys_product_id =3D 1339  (0x53b)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_4'
  info.linux.driver =3D 'pcieport-driver'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Express Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_4'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:11.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:11.0'  (string)
  pci.product =3D 'MCP67 PCI Express Bridge'  (string)
  pci.product_id =3D 1379  (0x563)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_3'
  info.linux.driver =3D 'pcieport-driver'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Express Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_3'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:10.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:10.0'  (string)
  pci.product =3D 'MCP67 PCI Express Bridge'  (string)
  pci.product_id =3D 1379  (0x563)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_2'
  info.linux.driver =3D 'pcieport-driver'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Express Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_2'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0f.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0f.0'  (string)
  pci.product =3D 'MCP67 PCI Express Bridge'  (string)
  pci.product_id =3D 1379  (0x563)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_1'
  info.linux.driver =3D 'pcieport-driver'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Express Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_1'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0e.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0e.0'  (string)
  pci.product =3D 'MCP67 PCI Express Bridge'  (string)
  pci.product_id =3D 1379  (0x563)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_0'
  info.linux.driver =3D 'pcieport-driver'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Express Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_563_0'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0d.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0d.0'  (string)
  pci.product =3D 'MCP67 PCI Express Bridge'  (string)
  pci.product_id =3D 1379  (0x563)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_563'
  info.linux.driver =3D 'pcieport-driver'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Express Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_563'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0c.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0c.0'  (string)
  pci.product =3D 'MCP67 PCI Express Bridge'  (string)
  pci.product_id =3D 1379  (0x563)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_562'
  info.linux.driver =3D 'pcieport-driver'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Express Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_562'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0b.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0b.0'  (string)
  pci.product =3D 'MCP67 PCI Express Bridge'  (string)
  pci.product_id =3D 1378  (0x562)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_54c'
  info.linux.driver =3D 'forcedeth'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 Ethernet'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_54c'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0a.0'  (string)
  pci.device_class =3D 2  (0x2)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0a.0'  (string)
  pci.product =3D 'MCP67 Ethernet'  (string)
  pci.product_id =3D 1356  (0x54c)  (int)
  pci.subsys_product_id =3D 1356  (0x54c)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/net_00_19_66_60_7b_2e'
  info.capabilities =3D {'net', 'net.80203', 'wake_on_lan'} (string list)
  info.category =3D 'net.80203'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.WakeOnLan'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_54c'  (string)
  info.product =3D 'Networking Interface'  (string)
  info.subsystem =3D 'net'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/net_00_19_66_60_7b_2e'  (strin=
g)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'net'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:0a.0/net/eth0'  (st=
ring)
  net.80203.mac_address =3D 109091781422  (0x1966607b2e)  (uint64)
  net.address =3D '00:19:66:60:7b:2e'  (string)
  net.arp_proto_hw_id =3D 1  (0x1)  (int)
  net.interface =3D 'eth0'  (string)
  net.linux.ifindex =3D 2  (0x2)  (int)
  net.originating_device =3D '/org/freedesktop/Hal/devices/pci_10de_54c'  (=
string)
  org.freedesktop.Hal.Device.WakeOnLan.method_argnames =3D {'', '', 'enable=
'} (string list)
  org.freedesktop.Hal.Device.WakeOnLan.method_execpaths =3D {'hal-system-wo=
l-supported', 'hal-system-wol-enabled', 'hal-system-wol-enable'} (string li=
st)
  org.freedesktop.Hal.Device.WakeOnLan.method_names =3D {'GetSupported', 'G=
etEnabled', 'SetEnabled'} (string list)
  org.freedesktop.Hal.Device.WakeOnLan.method_signatures =3D {'', '', 'b'} =
(string list)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550'
  info.linux.driver =3D 'ahci'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 AHCI Controller'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0'  (string)
  pci.device_class =3D 1  (0x1)  (int)
  pci.device_protocol =3D 133  (0x85)  (int)
  pci.device_subclass =3D 1  (0x1)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0'  (string)
  pci.product =3D 'MCP67 AHCI Controller'  (string)
  pci.product_id =3D 1360  (0x550)  (int)
  pci.subsys_product_id =3D 1360  (0x550)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_2'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_2'  (st=
ring)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host4/scsi_hos=
t/host4'  (string)
  scsi_host.host =3D 4  (0x4)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_1'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_1'  (st=
ring)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host3/scsi_hos=
t/host3'  (string)
  scsi_host.host =3D 3  (0x3)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0'  (st=
ring)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host2'  (strin=
g)
  scsi_host.host =3D 2  (0x2)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0'  =
(string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_scsi_=
host'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host2/scsi_hos=
t/host2'  (string)
  scsi_host.host =3D 2  (0x2)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_scsi_device_=
lun0'
  info.linux.driver =3D 'sr'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0'  =
(string)
  info.product =3D 'SCSI Device'  (string)
  info.subsystem =3D 'scsi'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_scsi_=
device_lun0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host2/target2:=
0:0/2:0:0:0'  (string)
  scsi.bus =3D 0  (0x0)  (int)
  scsi.host =3D 2  (0x2)  (int)
  scsi.lun =3D 0  (0x0)  (int)
  scsi.model =3D 'BDDVDRW GGC-H20L'  (string)
  scsi.target =3D 0  (0x0)  (int)
  scsi.type =3D 'cdrom'  (string)
  scsi.vendor =3D 'HL-DT-ST'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_scsi_device_=
lun0_scsi_generic'
  info.capabilities =3D {'scsi_generic'} (string list)
  info.category =3D 'scsi_generic'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_sc=
si_device_lun0'  (string)
  info.product =3D 'SCSI Generic Interface'  (string)
  info.subsystem =3D 'scsi_generic'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_scsi_=
device_lun0_scsi_generic'  (string)
  linux.device_file =3D '/dev/sg2'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_generic'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host2/target2:=
0:0/2:0:0:0/scsi_generic/sg2'  (string)
  scsi_generic.device =3D '/dev/sg2'  (string)

udi =3D '/org/freedesktop/Hal/devices/storage_model_BDDVDRW_GGC_H20L'
  access_control.file =3D '/dev/scd0'  (string)
  access_control.type =3D 'cdrom'  (string)
  block.device =3D '/dev/scd0'  (string)
  block.is_volume =3D false  (bool)
  block.major =3D 11  (0xb)  (int)
  block.minor =3D 0  (0x0)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_model_BDDV=
DRW_GGC_H20L'  (string)
  info.addons =3D {'hald-addon-storage'} (string list)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'storage', 'block', 'storage.cdrom', 'access_contr=
ol', 'access_control'} (string list)
  info.category =3D 'storage'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Storage', 'org.freedeskt=
op.Hal.Device.Storage', 'org.freedesktop.Hal.Device.Storage.Removable'} (st=
ring list)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_0_sc=
si_device_lun0'  (string)
  info.product =3D 'BDDVDRW GGC-H20L'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/storage_model_BDDVDRW_GGC_H20L=
'  (string)
  info.vendor =3D 'HL-DT-ST'  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host2/target2:=
0:0/2:0:0:0/block/sr0'  (string)
  org.freedesktop.Hal.Device.Storage.method_argnames =3D {'extra_options', =
'extra_options'} (string list)
  org.freedesktop.Hal.Device.Storage.method_execpaths =3D {'hal-storage-eje=
ct', 'hal-storage-closetray'} (string list)
  org.freedesktop.Hal.Device.Storage.method_names =3D {'Eject', 'CloseTray'=
} (string list)
  org.freedesktop.Hal.Device.Storage.method_signatures =3D {'as', 'as'} (st=
ring list)
  storage.automount_enabled_hint =3D true  (bool)
  storage.bus =3D 'scsi'  (string)
  storage.cdrom.bd =3D true  (bool)
  storage.cdrom.bdr =3D false  (bool)
  storage.cdrom.bdre =3D false  (bool)
  storage.cdrom.cdr =3D true  (bool)
  storage.cdrom.cdrw =3D true  (bool)
  storage.cdrom.dvd =3D true  (bool)
  storage.cdrom.dvdplusr =3D true  (bool)
  storage.cdrom.dvdplusrdl =3D true  (bool)
  storage.cdrom.dvdplusrw =3D true  (bool)
  storage.cdrom.dvdplusrwdl =3D false  (bool)
  storage.cdrom.dvdr =3D true  (bool)
  storage.cdrom.dvdram =3D true  (bool)
  storage.cdrom.dvdrw =3D true  (bool)
  storage.cdrom.hddvd =3D true  (bool)
  storage.cdrom.hddvdr =3D false  (bool)
  storage.cdrom.hddvdrw =3D false  (bool)
  storage.cdrom.mo =3D false  (bool)
  storage.cdrom.mrw =3D true  (bool)
  storage.cdrom.mrw_w =3D true  (bool)
  storage.cdrom.read_speed =3D 7056  (0x1b90)  (int)
  storage.cdrom.support_media_changed =3D true  (bool)
  storage.cdrom.support_multisession =3D true  (bool)
  storage.cdrom.write_speed =3D 7056  (0x1b90)  (int)
  storage.cdrom.write_speeds =3D {'7056', '5645', '4234', '2822', '1411', '=
706'} (string list)
  storage.drive_type =3D 'cdrom'  (string)
  storage.hotpluggable =3D false  (bool)
  storage.lun =3D 0  (0x0)  (int)
  storage.media_check_enabled =3D true  (bool)
  storage.model =3D 'BDDVDRW GGC-H20L'  (string)
  storage.no_partitions_hint =3D true  (bool)
  storage.originating_device =3D '/org/freedesktop/Hal/devices/computer'  (=
string)
  storage.partitioning_scheme =3D ''  (string)
  storage.removable =3D true  (bool)
  storage.removable.media_available =3D false  (bool)
  storage.removable.support_async_notification =3D false  (bool)
  storage.requires_eject =3D true  (bool)
  storage.size =3D 0  (0x0)  (uint64)
  storage.vendor =3D 'HL-DT-ST'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host'  (stri=
ng)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1'  (strin=
g)
  scsi_host.host =3D 1  (0x1)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host'  (s=
tring)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi_ho=
st'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/scsi_hos=
t/host1'  (string)
  scsi_host.host =3D 1  (0x1)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi_device_lu=
n0'
  info.linux.driver =3D 'sd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host'  (s=
tring)
  info.product =3D 'SCSI Device'  (string)
  info.subsystem =3D 'scsi'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi_de=
vice_lun0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/target1:=
0:0/1:0:0:0'  (string)
  scsi.bus =3D 0  (0x0)  (int)
  scsi.host =3D 1  (0x1)  (int)
  scsi.lun =3D 0  (0x0)  (int)
  scsi.model =3D 'ST3320620AS'  (string)
  scsi.target =3D 0  (0x0)  (int)
  scsi.type =3D 'disk'  (string)
  scsi.vendor =3D 'ATA'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi_device_lu=
n0_scsi_generic'
  info.capabilities =3D {'scsi_generic'} (string list)
  info.category =3D 'scsi_generic'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi=
_device_lun0'  (string)
  info.product =3D 'SCSI Generic Interface'  (string)
  info.subsystem =3D 'scsi_generic'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi_de=
vice_lun0_scsi_generic'  (string)
  linux.device_file =3D '/dev/sg1'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_generic'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/target1:=
0:0/1:0:0:0/scsi_generic/sg1'  (string)
  scsi_generic.device =3D '/dev/sg1'  (string)

udi =3D '/org/freedesktop/Hal/devices/storage_serial_1ATA_ST3320620AS_6QF21=
1FQ'
  block.device =3D '/dev/sda'  (string)
  block.is_volume =3D false  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 0  (0x0)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_1AT=
A_ST3320620AS_6QF211FQ'  (string)
  info.capabilities =3D {'storage', 'block'} (string list)
  info.category =3D 'storage'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_550_scsi_host_scsi=
_device_lun0'  (string)
  info.product =3D 'ST3320620AS'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/storage_serial_1ATA_ST3320620A=
S_6QF211FQ'  (string)
  info.vendor =3D 'ATA'  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/target1:=
0:0/1:0:0:0/block/sda'  (string)
  storage.automount_enabled_hint =3D false  (bool)
  storage.bus =3D 'scsi'  (string)
  storage.drive_type =3D 'disk'  (string)
  storage.firmware_version =3D '3.AA'  (string)
  storage.hotpluggable =3D false  (bool)
  storage.lun =3D 0  (0x0)  (int)
  storage.media_check_enabled =3D false  (bool)
  storage.model =3D 'ST3320620AS'  (string)
  storage.no_partitions_hint =3D false  (bool)
  storage.originating_device =3D '/org/freedesktop/Hal/devices/computer'  (=
string)
  storage.partitioning_scheme =3D 'mbr'  (string)
  storage.removable =3D false  (bool)
  storage.removable.media_available =3D true  (bool)
  storage.removable.media_size =3D 320072933376  (0x4a85d56000)  (uint64)
  storage.requires_eject =3D false  (bool)
  storage.serial =3D '1ATA_ST3320620AS_6QF211FQ'  (string)
  storage.size =3D 320072933376  (0x4a85d56000)  (uint64)
  storage.vendor =3D 'ATA'  (string)

udi =3D '/org/freedesktop/Hal/devices/volume_uuid_vVU2dE_uLxj_OXWI_TdoJ_7Qi=
a_5USB_zNel0m'
  block.device =3D '/dev/sda4'  (string)
  block.is_volume =3D true  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 4  (0x4)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_1AT=
A_ST3320620AS_6QF211FQ'  (string)
  info.capabilities =3D {'volume', 'block'} (string list)
  info.category =3D 'volume'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/storage_serial_1ATA_ST33206=
20AS_6QF211FQ'  (string)
  info.product =3D 'Volume (LVM2_member)'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/volume_uuid_vVU2dE_uLxj_OXWI_T=
doJ_7Qia_5USB_zNel0m'  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/target1:=
0:0/1:0:0:0/block/sda/sda4'  (string)
  storage.model =3D ''  (string)
  volume.block_size =3D 512  (0x200)  (int)
  volume.fstype =3D 'LVM2_member'  (string)
  volume.fsusage =3D 'raid'  (string)
  volume.fsversion =3D 'LVM2 001'  (string)
  volume.is_disc =3D false  (bool)
  volume.is_mounted =3D false  (bool)
  volume.is_mounted_read_only =3D false  (bool)
  volume.is_partition =3D true  (bool)
  volume.label =3D ''  (string)
  volume.linux.is_device_mapper =3D false  (bool)
  volume.mount_point =3D ''  (string)
  volume.num_blocks =3D 455426685  (0x1b25427d)  (uint64)
  volume.partition.flags =3D {} (string list)
  volume.partition.label =3D ''  (string)
  volume.partition.media_size =3D 320072933376  (0x4a85d56000)  (uint64)
  volume.partition.number =3D 4  (0x4)  (int)
  volume.partition.scheme =3D 'mbr'  (string)
  volume.partition.start =3D 86891857920  (0x143b288800)  (uint64)
  volume.partition.type =3D '0x8e'  (string)
  volume.partition.uuid =3D ''  (string)
  volume.size =3D 233178462720  (0x364a84fa00)  (uint64)
  volume.uuid =3D 'vVU2dE-uLxj-OXWI-TdoJ-7Qia-5USB-zNel0m'  (string)

udi =3D '/org/freedesktop/Hal/devices/volume_uuid_932172fc_1e94_4756_a0b1_d=
4a89db9c5ca'
  block.device =3D '/dev/sda3'  (string)
  block.is_volume =3D true  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 3  (0x3)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_1AT=
A_ST3320620AS_6QF211FQ'  (string)
  info.capabilities =3D {'volume', 'block'} (string list)
  info.category =3D 'volume'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Volume'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/storage_serial_1ATA_ST33206=
20AS_6QF211FQ'  (string)
  info.product =3D 'Volume (ext3)'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/volume_uuid_932172fc_1e94_4756=
_a0b1_d4a89db9c5ca'  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/target1:=
0:0/1:0:0:0/block/sda/sda3'  (string)
  org.freedesktop.Hal.Device.Volume.method_argnames =3D {'mount_point fstyp=
e extra_options', 'extra_options', 'extra_options'} (string list)
  org.freedesktop.Hal.Device.Volume.method_execpaths =3D {'hal-storage-moun=
t', 'hal-storage-unmount', 'hal-storage-eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_names =3D {'Mount', 'Unmount', '=
Eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_signatures =3D {'ssas', 'as', 'a=
s'} (string list)
  storage.model =3D ''  (string)
  volume.block_size =3D 512  (0x200)  (int)
  volume.fstype =3D 'ext3'  (string)
  volume.fsusage =3D 'filesystem'  (string)
  volume.fsversion =3D '1.0'  (string)
  volume.ignore =3D false  (bool)
  volume.is_disc =3D false  (bool)
  volume.is_mounted =3D true  (bool)
  volume.is_mounted_read_only =3D false  (bool)
  volume.is_partition =3D true  (bool)
  volume.label =3D ''  (string)
  volume.linux.is_device_mapper =3D false  (bool)
  volume.mount.valid_options =3D {'ro', 'sync', 'dirsync', 'noatime', 'nodi=
ratime', 'noexec', 'quiet', 'remount', 'exec', 'acl', 'user_xattr', 'data=
=3D'} (string list)
  volume.mount_point =3D '/boot'  (string)
  volume.num_blocks =3D 1959930  (0x1de7fa)  (uint64)
  volume.partition.flags =3D {} (string list)
  volume.partition.label =3D ''  (string)
  volume.partition.media_size =3D 320072933376  (0x4a85d56000)  (uint64)
  volume.partition.number =3D 3  (0x3)  (int)
  volume.partition.scheme =3D 'mbr'  (string)
  volume.partition.start =3D 85888373760  (0x13ff589400)  (uint64)
  volume.partition.type =3D '0x83'  (string)
  volume.partition.uuid =3D ''  (string)
  volume.size =3D 1003484160  (0x3bcff400)  (uint64)
  volume.unmount.valid_options =3D {'lazy'} (string list)
  volume.uuid =3D '932172fc-1e94-4756-a0b1-d4a89db9c5ca'  (string)

udi =3D '/org/freedesktop/Hal/devices/volume_uuid_EF7F_5A45'
  block.device =3D '/dev/sda2'  (string)
  block.is_volume =3D true  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 2  (0x2)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_1AT=
A_ST3320620AS_6QF211FQ'  (string)
  info.capabilities =3D {'volume', 'block'} (string list)
  info.category =3D 'volume'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Volume'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/storage_serial_1ATA_ST33206=
20AS_6QF211FQ'  (string)
  info.product =3D 'Volume (vfat)'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/volume_uuid_EF7F_5A45'  (strin=
g)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/target1:=
0:0/1:0:0:0/block/sda/sda2'  (string)
  org.freedesktop.Hal.Device.Volume.method_argnames =3D {'mount_point fstyp=
e extra_options', 'extra_options', 'extra_options'} (string list)
  org.freedesktop.Hal.Device.Volume.method_execpaths =3D {'hal-storage-moun=
t', 'hal-storage-unmount', 'hal-storage-eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_names =3D {'Mount', 'Unmount', '=
Eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_signatures =3D {'ssas', 'as', 'a=
s'} (string list)
  storage.model =3D ''  (string)
  volume.block_size =3D 512  (0x200)  (int)
  volume.fstype =3D 'vfat'  (string)
  volume.fsusage =3D 'filesystem'  (string)
  volume.fsversion =3D 'FAT32'  (string)
  volume.ignore =3D false  (bool)
  volume.is_disc =3D false  (bool)
  volume.is_mounted =3D false  (bool)
  volume.is_mounted_read_only =3D false  (bool)
  volume.is_partition =3D true  (bool)
  volume.label =3D ''  (string)
  volume.linux.is_device_mapper =3D false  (bool)
  volume.mount.valid_options =3D {'ro', 'sync', 'dirsync', 'noatime', 'nodi=
ratime', 'noexec', 'quiet', 'remount', 'exec', 'utf8', 'shortname=3D', 'cod=
epage=3D', 'iocharset=3D', 'umask=3D', 'dmask=3D', 'fmask=3D', 'uid=3D', 'f=
lush'} (string list)
  volume.mount_point =3D ''  (string)
  volume.num_blocks =3D 3903795  (0x3b9133)  (uint64)
  volume.partition.flags =3D {} (string list)
  volume.partition.label =3D ''  (string)
  volume.partition.media_size =3D 320072933376  (0x4a85d56000)  (uint64)
  volume.partition.number =3D 2  (0x2)  (int)
  volume.partition.scheme =3D 'mbr'  (string)
  volume.partition.start =3D 83889630720  (0x1388362e00)  (uint64)
  volume.partition.type =3D '0x0b'  (string)
  volume.partition.uuid =3D ''  (string)
  volume.size =3D 1998743040  (0x77226600)  (uint64)
  volume.unmount.valid_options =3D {'lazy'} (string list)
  volume.uuid =3D 'EF7F-5A45'  (string)

udi =3D '/org/freedesktop/Hal/devices/volume_uuid_B2845BD8845B9E23'
  block.device =3D '/dev/sda1'  (string)
  block.is_volume =3D true  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 1  (0x1)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_1AT=
A_ST3320620AS_6QF211FQ'  (string)
  info.capabilities =3D {'volume', 'block'} (string list)
  info.category =3D 'volume'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Volume'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/storage_serial_1ATA_ST33206=
20AS_6QF211FQ'  (string)
  info.product =3D 'Volume (ntfs)'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/volume_uuid_B2845BD8845B9E23' =
 (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:09.0/host1/target1:=
0:0/1:0:0:0/block/sda/sda1'  (string)
  org.freedesktop.Hal.Device.Volume.method_argnames =3D {'mount_point fstyp=
e extra_options', 'extra_options', 'extra_options'} (string list)
  org.freedesktop.Hal.Device.Volume.method_execpaths =3D {'hal-storage-moun=
t', 'hal-storage-unmount', 'hal-storage-eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_names =3D {'Mount', 'Unmount', '=
Eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_signatures =3D {'ssas', 'as', 'a=
s'} (string list)
  storage.model =3D ''  (string)
  volume.block_size =3D 512  (0x200)  (int)
  volume.fstype =3D 'ntfs'  (string)
  volume.fsusage =3D 'filesystem'  (string)
  volume.fsversion =3D '3.1'  (string)
  volume.ignore =3D false  (bool)
  volume.is_disc =3D false  (bool)
  volume.is_mounted =3D false  (bool)
  volume.is_mounted_read_only =3D false  (bool)
  volume.is_partition =3D true  (bool)
  volume.label =3D ''  (string)
  volume.linux.is_device_mapper =3D false  (bool)
  volume.mount.valid_options =3D {'ro', 'sync', 'dirsync', 'noatime', 'nodi=
ratime', 'noexec', 'quiet', 'remount', 'exec', 'uid=3D', 'gid=3D', 'umask=
=3D', 'locale=3D', 'utf8'} (string list)
  volume.mount_point =3D ''  (string)
  volume.num_blocks =3D 163840000  (0x9c40000)  (uint64)
  volume.partition.flags =3D {'boot'} (string list)
  volume.partition.label =3D ''  (string)
  volume.partition.media_size =3D 320072933376  (0x4a85d56000)  (uint64)
  volume.partition.number =3D 1  (0x1)  (int)
  volume.partition.scheme =3D 'mbr'  (string)
  volume.partition.start =3D 1048576  (0x100000)  (uint64)
  volume.partition.type =3D '0x07'  (string)
  volume.partition.uuid =3D ''  (string)
  volume.size =3D 83886080000  (0x1388000000)  (uint64)
  volume.unmount.valid_options =3D {'lazy'} (string list)
  volume.uuid =3D 'B2845BD8845B9E23'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_561'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 PCI Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_561'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 1  (0x1)  (int)
  pci.device_subclass =3D 4  (0x4)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0'  (string)
  pci.product =3D 'MCP67 PCI Bridge'  (string)
  pci.product_id =3D 1377  (0x561)  (int)
  pci.subsys_product_id =3D 0  (0x0)  (int)
  pci.subsys_vendor_id =3D 0  (0x0)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7'
  info.linux.driver =3D 'CA0106'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_561'  (string)
  info.product =3D 'SB Audigy LS'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7'  (string)
  info.vendor =3D 'Creative Labs'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0' =
 (string)
  pci.device_class =3D 4  (0x4)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 1  (0x1)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a=
.0'  (string)
  pci.product =3D 'SB Audigy LS'  (string)
  pci.product_id =3D 7  (0x7)  (int)
  pci.subsys_product_id =3D 4106  (0x100a)  (int)
  pci.subsys_vendor =3D 'Creative Labs'  (string)
  pci.subsys_vendor_id =3D 4354  (0x1102)  (int)
  pci.vendor =3D 'Creative Labs'  (string)
  pci.vendor_id =3D 4354  (0x1102)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'
  info.capabilities =3D {'sound'} (string list)
  info.category =3D 'sound'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7'  (string)
  info.product =3D 'Audigy SE [SB0570] Sound Card'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (str=
ing)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0'  (string)
  sound.card =3D 0  (0x0)  (int)
  sound.card_id =3D 'Audigy SE [SB0570]'  (string)
  sound.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7'  (=
string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_playback=
_3'
  access_control.file =3D '/dev/snd/pcmC0D3p'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 3  (0x3)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D3p'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'playback'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Playback Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_p=
layback_3'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D3p'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D3p'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_capture_=
3'
  access_control.file =3D '/dev/snd/pcmC0D3c'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 3  (0x3)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D3c'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'capture'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Capture Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_c=
apture_3'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D3c'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D3c'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_playback=
_2'
  access_control.file =3D '/dev/snd/pcmC0D2p'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 2  (0x2)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D2p'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'playback'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Playback Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_p=
layback_2'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D2p'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D2p'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_capture_=
2'
  access_control.file =3D '/dev/snd/pcmC0D2c'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 2  (0x2)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D2c'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'capture'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Capture Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_c=
apture_2'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D2c'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D2c'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_playback=
_1'
  access_control.file =3D '/dev/snd/pcmC0D1p'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 1  (0x1)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D1p'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'playback'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Playback Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_p=
layback_1'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D1p'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D1p'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_capture_=
1'
  access_control.file =3D '/dev/snd/pcmC0D1c'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 1  (0x1)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D1c'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'capture'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Capture Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_c=
apture_1'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D1c'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D1c'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_playback=
_0'
  access_control.file =3D '/dev/snd/pcmC0D0p'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 0  (0x0)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D0p'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'playback'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Playback Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_p=
layback_0'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D0p'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D0p'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_capture_=
0'
  access_control.file =3D '/dev/snd/pcmC0D0c'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 0  (0x0)  (int)
  alsa.device_file =3D '/dev/snd/pcmC0D0c'  (string)
  alsa.device_id =3D 'CA0106'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.pcm_class =3D 'generic'  (string)
  alsa.type =3D 'capture'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 ALSA Capture Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_c=
apture_0'  (string)
  linux.device_file =3D '/dev/snd/pcmC0D0c'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/pcmC0D0c'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_mixer__1'
  access_control.file =3D '/dev/mixer'  (string)
  access_control.type =3D 'sound'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'oss', 'access_control'} (string list)
  info.category =3D 'oss'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 OSS Control Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_mi=
xer__1'  (string)
  linux.device_file =3D '/dev/mixer'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/mixer'  (string)
  oss.card =3D 0  (0x0)  (int)
  oss.card_id =3D 'Audigy SE [SB0570]'  (string)
  oss.device_file =3D '/dev/mixer'  (string)
  oss.device_id =3D 'CA0106'  (string)
  oss.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound=
_card_0'  (string)
  oss.type =3D 'mixer'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_midi_0'
  access_control.file =3D '/dev/snd/midiC0D0'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device =3D 0  (0x0)  (int)
  alsa.device_file =3D '/dev/snd/midiC0D0'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.type =3D 'midi'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'Audigy SE [SB0570] ALSA MIDI Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_m=
idi_0'  (string)
  linux.device_file =3D '/dev/snd/midiC0D0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/midiC0D0'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_midi_0'
  access_control.file =3D '/dev/midi'  (string)
  access_control.type =3D 'sound'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'oss', 'access_control'} (string list)
  info.category =3D 'oss'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 OSS MIDI Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_mi=
di_0'  (string)
  linux.device_file =3D '/dev/midi'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/midi'  (string)
  oss.card =3D 0  (0x0)  (int)
  oss.card_id =3D 'Audigy SE [SB0570]'  (string)
  oss.device =3D 0  (0x0)  (int)
  oss.device_file =3D '/dev/midi'  (string)
  oss.device_id =3D 'CA0106'  (string)
  oss.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound=
_card_0'  (string)
  oss.type =3D 'midi'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_pcm_0_0'
  access_control.file =3D '/dev/dsp'  (string)
  access_control.type =3D 'sound'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'oss', 'access_control'} (string list)
  info.category =3D 'oss'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 OSS PCM Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_pc=
m_0_0'  (string)
  linux.device_file =3D '/dev/dsp'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/dsp'  (string)
  oss.card =3D 0  (0x0)  (int)
  oss.card_id =3D 'Audigy SE [SB0570]'  (string)
  oss.device =3D 0  (0x0)  (int)
  oss.device_file =3D '/dev/dsp'  (string)
  oss.device_id =3D 'CA0106'  (string)
  oss.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound=
_card_0'  (string)
  oss.type =3D 'pcm'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_control_=
_1'
  access_control.file =3D '/dev/snd/controlC0'  (string)
  access_control.type =3D 'sound'  (string)
  alsa.card =3D 0  (0x0)  (int)
  alsa.card_id =3D 'Audigy SE [SB0570]'  (string)
  alsa.device_file =3D '/dev/snd/controlC0'  (string)
  alsa.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_soun=
d_card_0'  (string)
  alsa.type =3D 'control'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'alsa', 'access_control'} (string list)
  info.category =3D 'alsa'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'Audigy SE [SB0570] ALSA Control Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_alsa_c=
ontrol__1'  (string)
  linux.device_file =3D '/dev/snd/controlC0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/controlC0'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_pcm_0'
  access_control.file =3D '/dev/audio'  (string)
  access_control.type =3D 'sound'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'oss', 'access_control'} (string list)
  info.category =3D 'oss'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 OSS PCM Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_pc=
m_0'  (string)
  linux.device_file =3D '/dev/audio'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/audio'  (string)
  oss.card =3D 0  (0x0)  (int)
  oss.card_id =3D 'Audigy SE [SB0570]'  (string)
  oss.device =3D 0  (0x0)  (int)
  oss.device_file =3D '/dev/audio'  (string)
  oss.device_id =3D 'CA0106'  (string)
  oss.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound=
_card_0'  (string)
  oss.type =3D 'pcm'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_pcm_1'
  access_control.file =3D '/dev/adsp'  (string)
  access_control.type =3D 'sound'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'oss', 'access_control'} (string list)
  info.category =3D 'oss'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0'  (=
string)
  info.product =3D 'CA0106 OSS PCM Device'  (string)
  info.subsystem =3D 'sound'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound_card_0_oss_pc=
m_1'  (string)
  linux.device_file =3D '/dev/adsp'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'sound'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:0a.0/s=
ound/card0/adsp'  (string)
  oss.card =3D 0  (0x0)  (int)
  oss.card_id =3D 'Audigy SE [SB0570]'  (string)
  oss.device =3D 1  (0x1)  (int)
  oss.device_file =3D '/dev/adsp'  (string)
  oss.device_id =3D 'CA0106'  (string)
  oss.originating_device =3D '/org/freedesktop/Hal/devices/pci_1102_7_sound=
_card_0'  (string)
  oss.type =3D 'pcm'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078'
  info.linux.driver =3D 'aic7xxx'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_561'  (string)
  info.product =3D 'AIC-7850'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078'  (string)
  info.vendor =3D 'Adaptec'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:08.0' =
 (string)
  pci.device_class =3D 1  (0x1)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:08=
.0'  (string)
  pci.product =3D 'AIC-7850'  (string)
  pci.product_id =3D 20600  (0x5078)  (int)
  pci.subsys_product_id =3D 30800  (0x7850)  (int)
  pci.subsys_vendor =3D 'Adaptec'  (string)
  pci.subsys_vendor_id =3D 36868  (0x9004)  (int)
  pci.vendor =3D 'Adaptec'  (string)
  pci.vendor_id =3D 36868  (0x9004)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_9004_5078'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host'  (str=
ing)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:08.0/h=
ost0'  (string)
  scsi_host.host =3D 0  (0x0)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host'  (=
string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host_scsi_h=
ost'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:08.0/h=
ost0/scsi_host/host0'  (string)
  scsi_host.host =3D 0  (0x0)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host_scsi_device_l=
un0'
  info.parent =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host'  (=
string)
  info.product =3D 'SCSI Device'  (string)
  info.subsystem =3D 'scsi'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host_scsi_d=
evice_lun0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:08.0/h=
ost0/target0:0:1/0:0:1:0'  (string)
  scsi.bus =3D 0  (0x0)  (int)
  scsi.host =3D 0  (0x0)  (int)
  scsi.lun =3D 0  (0x0)  (int)
  scsi.model =3D 'C2520A'  (string)
  scsi.target =3D 1  (0x1)  (int)
  scsi.type =3D 'processor'  (string)
  scsi.vendor =3D 'HP'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host_scsi_device_l=
un0_scsi_generic'
  info.capabilities =3D {'scsi_generic'} (string list)
  info.category =3D 'scsi_generic'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host_scs=
i_device_lun0'  (string)
  info.product =3D 'SCSI Generic Interface'  (string)
  info.subsystem =3D 'scsi_generic'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_9004_5078_scsi_host_scsi_d=
evice_lun0_scsi_generic'  (string)
  linux.device_file =3D '/dev/sg0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_generic'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:08.0/0000:01:08.0/h=
ost0/target0:0:1/0:0:1:0/scsi_generic/sg0'  (string)
  scsi_generic.device =3D '/dev/sg0'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_560'
  info.linux.driver =3D 'pata_amd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 IDE Controller'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_560'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0'  (string)
  pci.device_class =3D 1  (0x1)  (int)
  pci.device_protocol =3D 138  (0x8a)  (int)
  pci.device_subclass =3D 1  (0x1)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0'  (string)
  pci.product =3D 'MCP67 IDE Controller'  (string)
  pci.product_id =3D 1376  (0x560)  (int)
  pci.subsys_product_id =3D 1376  (0x560)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_0'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_560'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_0'  (st=
ring)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0/host6/scsi_hos=
t/host6'  (string)
  scsi_host.host =3D 6  (0x6)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_560'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host'  (stri=
ng)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0/host5'  (strin=
g)
  scsi_host.host =3D 5  (0x5)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host'  (s=
tring)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi_ho=
st'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0/host5/scsi_hos=
t/host5'  (string)
  scsi_host.host =3D 5  (0x5)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi_device_lu=
n0'
  info.linux.driver =3D 'sr'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host'  (s=
tring)
  info.product =3D 'SCSI Device'  (string)
  info.subsystem =3D 'scsi'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi_de=
vice_lun0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0/host5/target5:=
0:0/5:0:0:0'  (string)
  scsi.bus =3D 0  (0x0)  (int)
  scsi.host =3D 5  (0x5)  (int)
  scsi.lun =3D 0  (0x0)  (int)
  scsi.model =3D 'DVDRRW GSA-H20L'  (string)
  scsi.target =3D 0  (0x0)  (int)
  scsi.type =3D 'cdrom'  (string)
  scsi.vendor =3D 'HL-DT-ST'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi_device_lu=
n0_scsi_generic'
  info.capabilities =3D {'scsi_generic'} (string list)
  info.category =3D 'scsi_generic'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi=
_device_lun0'  (string)
  info.product =3D 'SCSI Generic Interface'  (string)
  info.subsystem =3D 'scsi_generic'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi_de=
vice_lun0_scsi_generic'  (string)
  linux.device_file =3D '/dev/sg3'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_generic'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0/host5/target5:=
0:0/5:0:0:0/scsi_generic/sg3'  (string)
  scsi_generic.device =3D '/dev/sg3'  (string)

udi =3D '/org/freedesktop/Hal/devices/storage_model_DVDRRW_GSA_H20L'
  access_control.file =3D '/dev/scd1'  (string)
  access_control.type =3D 'cdrom'  (string)
  block.device =3D '/dev/scd1'  (string)
  block.is_volume =3D false  (bool)
  block.major =3D 11  (0xb)  (int)
  block.minor =3D 1  (0x1)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_model_DVDR=
RW_GSA_H20L'  (string)
  info.addons =3D {'hald-addon-storage'} (string list)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'storage', 'block', 'storage.cdrom', 'access_contr=
ol', 'access_control'} (string list)
  info.category =3D 'storage'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Storage', 'org.freedeskt=
op.Hal.Device.Storage', 'org.freedesktop.Hal.Device.Storage.Removable'} (st=
ring list)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_560_scsi_host_scsi=
_device_lun0'  (string)
  info.product =3D 'DVDRRW GSA-H20L'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/storage_model_DVDRRW_GSA_H20L'=
  (string)
  info.vendor =3D 'HL-DT-ST'  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0/host5/target5:=
0:0/5:0:0:0/block/sr1'  (string)
  org.freedesktop.Hal.Device.Storage.method_argnames =3D {'extra_options', =
'extra_options'} (string list)
  org.freedesktop.Hal.Device.Storage.method_execpaths =3D {'hal-storage-eje=
ct', 'hal-storage-closetray'} (string list)
  org.freedesktop.Hal.Device.Storage.method_names =3D {'Eject', 'CloseTray'=
} (string list)
  org.freedesktop.Hal.Device.Storage.method_signatures =3D {'as', 'as'} (st=
ring list)
  storage.automount_enabled_hint =3D true  (bool)
  storage.bus =3D 'scsi'  (string)
  storage.cdrom.bd =3D false  (bool)
  storage.cdrom.bdr =3D false  (bool)
  storage.cdrom.bdre =3D false  (bool)
  storage.cdrom.cdr =3D true  (bool)
  storage.cdrom.cdrw =3D true  (bool)
  storage.cdrom.dvd =3D true  (bool)
  storage.cdrom.dvdplusr =3D true  (bool)
  storage.cdrom.dvdplusrdl =3D true  (bool)
  storage.cdrom.dvdplusrw =3D true  (bool)
  storage.cdrom.dvdplusrwdl =3D false  (bool)
  storage.cdrom.dvdr =3D true  (bool)
  storage.cdrom.dvdram =3D true  (bool)
  storage.cdrom.dvdrw =3D true  (bool)
  storage.cdrom.hddvd =3D false  (bool)
  storage.cdrom.hddvdr =3D false  (bool)
  storage.cdrom.hddvdrw =3D false  (bool)
  storage.cdrom.mo =3D false  (bool)
  storage.cdrom.mrw =3D true  (bool)
  storage.cdrom.mrw_w =3D true  (bool)
  storage.cdrom.read_speed =3D 7056  (0x1b90)  (int)
  storage.cdrom.support_media_changed =3D true  (bool)
  storage.cdrom.support_multisession =3D true  (bool)
  storage.cdrom.write_speed =3D 2770  (0xad2)  (int)
  storage.cdrom.write_speeds =3D {'2770'} (string list)
  storage.drive_type =3D 'cdrom'  (string)
  storage.hotpluggable =3D false  (bool)
  storage.lun =3D 0  (0x0)  (int)
  storage.media_check_enabled =3D true  (bool)
  storage.model =3D 'DVDRRW GSA-H20L'  (string)
  storage.no_partitions_hint =3D true  (bool)
  storage.originating_device =3D '/org/freedesktop/Hal/devices/computer'  (=
string)
  storage.removable =3D true  (bool)
  storage.removable.media_available =3D true  (bool)
  storage.removable.media_size =3D 1403486208  (0x53a78000)  (uint64)
  storage.removable.support_async_notification =3D false  (bool)
  storage.requires_eject =3D true  (bool)
  storage.size =3D 0  (0x0)  (uint64)
  storage.vendor =3D 'HL-DT-ST'  (string)

udi =3D '/org/freedesktop/Hal/devices/volume_uuid_44FA_7FE3'
  access_control.file =3D '/dev/scd1'  (string)
  access_control.type =3D 'removable-block'  (string)
  block.device =3D '/dev/scd1'  (string)
  block.is_volume =3D true  (bool)
  block.major =3D 11  (0xb)  (int)
  block.minor =3D 1  (0x1)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_model_DVDR=
RW_GSA_H20L'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'volume.disc', 'volume', 'block', 'access_control'=
} (string list)
  info.category =3D 'volume'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Volume'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/storage_model_DVDRRW_GSA_H2=
0L'  (string)
  info.product =3D 'Volume (vfat)'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/volume_uuid_44FA_7FE3'  (strin=
g)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:06.0/host5/target5:=
0:0/5:0:0:0/block/sr1/fakevolume'  (string)
  org.freedesktop.Hal.Device.Volume.method_argnames =3D {'mount_point fstyp=
e extra_options', 'extra_options', 'extra_options'} (string list)
  org.freedesktop.Hal.Device.Volume.method_execpaths =3D {'hal-storage-moun=
t', 'hal-storage-unmount', 'hal-storage-eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_names =3D {'Mount', 'Unmount', '=
Eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_signatures =3D {'ssas', 'as', 'a=
s'} (string list)
  storage.model =3D ''  (string)
  volume.block_size =3D 2048  (0x800)  (int)
  volume.disc.capacity =3D 1403486208  (0x53a78000)  (uint64)
  volume.disc.has_audio =3D false  (bool)
  volume.disc.has_data =3D true  (bool)
  volume.disc.is_appendable =3D false  (bool)
  volume.disc.is_blank =3D false  (bool)
  volume.disc.is_blurayvideo =3D false  (bool)
  volume.disc.is_rewritable =3D true  (bool)
  volume.disc.is_svcd =3D false  (bool)
  volume.disc.is_vcd =3D false  (bool)
  volume.disc.is_videodvd =3D false  (bool)
  volume.disc.type =3D 'dvd_ram'  (string)
  volume.fstype =3D 'vfat'  (string)
  volume.fsusage =3D 'filesystem'  (string)
  volume.fsversion =3D 'FAT12'  (string)
  volume.ignore =3D false  (bool)
  volume.is_disc =3D true  (bool)
  volume.is_mounted =3D true  (bool)
  volume.is_mounted_read_only =3D false  (bool)
  volume.is_partition =3D false  (bool)
  volume.label =3D ''  (string)
  volume.linux.is_device_mapper =3D false  (bool)
  volume.mount.valid_options =3D {'ro', 'sync', 'dirsync', 'noatime', 'nodi=
ratime', 'noexec', 'quiet', 'remount', 'exec', 'utf8', 'shortname=3D', 'cod=
epage=3D', 'iocharset=3D', 'umask=3D', 'dmask=3D', 'fmask=3D', 'uid=3D', 'f=
lush'} (string list)
  volume.mount_point =3D '/media/cdrom0'  (string)
  volume.num_blocks =3D 2741184  (0x29d3c0)  (uint64)
  volume.size =3D 1403486208  (0x53a78000)  (uint64)
  volume.unmount.valid_options =3D {'lazy'} (string list)
  volume.uuid =3D '44FA-7FE3'  (string)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_55f_0'
  info.linux.driver =3D 'ehci_hcd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 EHCI USB 2.0 Controller'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_55f_0'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1'  (string)
  pci.device_class =3D 12  (0xc)  (int)
  pci.device_protocol =3D 32  (0x20)  (int)
  pci.device_subclass =3D 3  (0x3)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1'  (string)
  pci.product =3D 'MCP67 EHCI USB 2.0 Controller'  (string)
  pci.product_id =3D 1375  (0x55f)  (int)
  pci.subsys_product_id =3D 1375  (0x55f)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_04_1'
  info.linux.driver =3D 'usb'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_55f_0'  (string)
  info.product =3D '2.0 root hub'  (string)
  info.subsystem =3D 'usb_device'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_04_1=
'  (string)
  info.vendor =3D 'Linux Foundation'  (string)
  linux.device_file =3D '/dev/bus/usb/002/001'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2'  (string)
  usb_device.bus_number =3D 2  (0x2)  (int)
  usb_device.can_wake_up =3D true  (bool)
  usb_device.configuration_value =3D 1  (0x1)  (int)
  usb_device.device_class =3D 9  (0x9)  (int)
  usb_device.device_protocol =3D 0  (0x0)  (int)
  usb_device.device_revision_bcd =3D 518  (0x206)  (int)
  usb_device.device_subclass =3D 0  (0x0)  (int)
  usb_device.is_self_powered =3D true  (bool)
  usb_device.linux.device_number =3D 1  (0x1)  (int)
  usb_device.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb=
2'  (string)
  usb_device.max_power =3D 0  (0x0)  (int)
  usb_device.num_configurations =3D 1  (0x1)  (int)
  usb_device.num_interfaces =3D 1  (0x1)  (int)
  usb_device.num_ports =3D 5  (0x5)  (int)
  usb_device.product =3D '2.0 root hub'  (string)
  usb_device.product_id =3D 2  (0x2)  (int)
  usb_device.serial =3D '0000:00:04.1'  (string)
  usb_device.speed =3D 480.0 (480) (double)
  usb_device.vendor =3D 'Linux Foundation'  (string)
  usb_device.vendor_id =3D 7531  (0x1d6b)  (int)
  usb_device.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D414E4B3=
2323630343131'
  info.linux.driver =3D 'usb'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_0=
4_1'  (string)
  info.product =3D 'MyBook External HDD'  (string)
  info.subsystem =3D 'usb_device'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D=
414E4B32323630343131'  (string)
  info.vendor =3D 'Western Digital Technologies, Inc.'  (string)
  linux.device_file =3D '/dev/bus/usb/002/002'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1'  (st=
ring)
  usb_device.bus_number =3D 2  (0x2)  (int)
  usb_device.can_wake_up =3D false  (bool)
  usb_device.configuration_value =3D 1  (0x1)  (int)
  usb_device.device_class =3D 0  (0x0)  (int)
  usb_device.device_protocol =3D 0  (0x0)  (int)
  usb_device.device_revision_bcd =3D 518  (0x206)  (int)
  usb_device.device_subclass =3D 0  (0x0)  (int)
  usb_device.is_self_powered =3D true  (bool)
  usb_device.linux.device_number =3D 2  (0x2)  (int)
  usb_device.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb=
2/2-1'  (string)
  usb_device.max_power =3D 100  (0x64)  (int)
  usb_device.num_configurations =3D 1  (0x1)  (int)
  usb_device.num_interfaces =3D 1  (0x1)  (int)
  usb_device.num_ports =3D 0  (0x0)  (int)
  usb_device.product =3D 'MyBook External HDD'  (string)
  usb_device.product_id =3D 2305  (0x901)  (int)
  usb_device.serial =3D '57442D574D414E4B32323630343131'  (string)
  usb_device.speed =3D 480.0 (480) (double)
  usb_device.vendor =3D 'Western Digital Technologies, Inc.'  (string)
  usb_device.vendor_id =3D 4184  (0x1058)  (int)
  usb_device.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D414E4B3=
2323630343131_if0'
  info.linux.driver =3D 'usb-storage'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D5=
74D414E4B32323630343131'  (string)
  info.product =3D 'USB Mass Storage Interface'  (string)
  info.subsystem =3D 'usb'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D=
414E4B32323630343131_if0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0'  (string)
  usb.bus_number =3D 2  (0x2)  (int)
  usb.can_wake_up =3D false  (bool)
  usb.configuration_value =3D 1  (0x1)  (int)
  usb.device_class =3D 0  (0x0)  (int)
  usb.device_protocol =3D 0  (0x0)  (int)
  usb.device_revision_bcd =3D 518  (0x206)  (int)
  usb.device_subclass =3D 0  (0x0)  (int)
  usb.interface.class =3D 8  (0x8)  (int)
  usb.interface.number =3D 0  (0x0)  (int)
  usb.interface.protocol =3D 80  (0x50)  (int)
  usb.interface.subclass =3D 6  (0x6)  (int)
  usb.is_self_powered =3D true  (bool)
  usb.linux.device_number =3D 2  (0x2)  (int)
  usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2=
-1:1.0'  (string)
  usb.max_power =3D 100  (0x64)  (int)
  usb.num_configurations =3D 1  (0x1)  (int)
  usb.num_interfaces =3D 1  (0x1)  (int)
  usb.num_ports =3D 0  (0x0)  (int)
  usb.product =3D 'USB Mass Storage Interface'  (string)
  usb.product_id =3D 2305  (0x901)  (int)
  usb.serial =3D '57442D574D414E4B32323630343131'  (string)
  usb.speed =3D 480.0 (480) (double)
  usb.vendor =3D 'Western Digital Technologies, Inc.'  (string)
  usb.vendor_id =3D 4184  (0x1058)  (int)
  usb.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D414E4B3=
2323630343131_if0_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D5=
74D414E4B32323630343131_if0'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D=
414E4B32323630343131_if0_scsi_host'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0/host7'  (string)
  scsi_host.host =3D 7  (0x7)  (int)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D414E4B3=
2323630343131_if0_scsi_host_scsi_host'
  info.capabilities =3D {'scsi_host'} (string list)
  info.category =3D 'scsi_host'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D5=
74D414E4B32323630343131_if0_scsi_host'  (string)
  info.product =3D 'SCSI Host Adapter'  (string)
  info.subsystem =3D 'scsi_host'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D=
414E4B32323630343131_if0_scsi_host_scsi_host'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_host'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0/host7/scsi_host/host7'  (string)
  scsi_host.host =3D 7  (0x7)  (int)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D414E4B3=
2323630343131_if0_scsi_host_scsi_device_lun0'
  info.linux.driver =3D 'sd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D5=
74D414E4B32323630343131_if0_scsi_host'  (string)
  info.product =3D 'SCSI Device'  (string)
  info.subsystem =3D 'scsi'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D=
414E4B32323630343131_if0_scsi_host_scsi_device_lun0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0/host7/target7:0:0/7:0:0:0'  (string)
  scsi.bus =3D 0  (0x0)  (int)
  scsi.host =3D 7  (0x7)  (int)
  scsi.lun =3D 0  (0x0)  (int)
  scsi.model =3D '2500JB External'  (string)
  scsi.target =3D 0  (0x0)  (int)
  scsi.type =3D 'disk'  (string)
  scsi.vendor =3D 'WD'  (string)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D414E4B3=
2323630343131_if0_scsi_host_scsi_device_lun0_scsi_generic'
  info.capabilities =3D {'scsi_generic'} (string list)
  info.category =3D 'scsi_generic'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D5=
74D414E4B32323630343131_if0_scsi_host_scsi_device_lun0'  (string)
  info.product =3D 'SCSI Generic Interface'  (string)
  info.subsystem =3D 'scsi_generic'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D574D=
414E4B32323630343131_if0_scsi_host_scsi_device_lun0_scsi_generic'  (string)
  linux.device_file =3D '/dev/sg4'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'scsi_generic'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0/host7/target7:0:0/7:0:0:0/scsi_generic/sg4'  (string)
  scsi_generic.device =3D '/dev/sg4'  (string)

udi =3D '/org/freedesktop/Hal/devices/storage_serial_WD_2500JB_External_574=
42D574D414E4B32323630343131_0_0'
  block.device =3D '/dev/sdb'  (string)
  block.is_volume =3D false  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 16  (0x10)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_WD_=
2500JB_External_57442D574D414E4B32323630343131_0_0'  (string)
  info.capabilities =3D {'storage', 'block'} (string list)
  info.category =3D 'storage'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1058_901_57442D5=
74D414E4B32323630343131_if0_scsi_host_scsi_device_lun0'  (string)
  info.product =3D '2500JB External'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/storage_serial_WD_2500JB_Exter=
nal_57442D574D414E4B32323630343131_0_0'  (string)
  info.vendor =3D 'WD'  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0/host7/target7:0:0/7:0:0:0/block/sdb'  (string)
  storage.automount_enabled_hint =3D true  (bool)
  storage.bus =3D 'usb'  (string)
  storage.drive_type =3D 'disk'  (string)
  storage.firmware_version =3D '0107'  (string)
  storage.hotpluggable =3D true  (bool)
  storage.lun =3D 0  (0x0)  (int)
  storage.media_check_enabled =3D false  (bool)
  storage.model =3D '2500JB External'  (string)
  storage.no_partitions_hint =3D false  (bool)
  storage.originating_device =3D '/org/freedesktop/Hal/devices/usb_device_1=
058_901_57442D574D414E4B32323630343131_if0'  (string)
  storage.partitioning_scheme =3D 'mbr'  (string)
  storage.removable =3D false  (bool)
  storage.removable.media_available =3D true  (bool)
  storage.removable.media_size =3D 250059350016  (0x3a38b2e000)  (uint64)
  storage.requires_eject =3D false  (bool)
  storage.serial =3D 'WD_2500JB_External_57442D574D414E4B32323630343131-0:0=
'  (string)
  storage.size =3D 250059350016  (0x3a38b2e000)  (uint64)
  storage.vendor =3D 'WD'  (string)

udi =3D '/org/freedesktop/Hal/devices/volume_uuid_30FF27821566D335'
  block.device =3D '/dev/sdb2'  (string)
  block.is_volume =3D true  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 18  (0x12)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_WD_=
2500JB_External_57442D574D414E4B32323630343131_0_0'  (string)
  info.capabilities =3D {'volume', 'block'} (string list)
  info.category =3D 'volume'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Volume'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/storage_serial_WD_2500JB_Ex=
ternal_57442D574D414E4B32323630343131_0_0'  (string)
  info.product =3D 'Win (External)'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/volume_uuid_30FF27821566D335' =
 (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0/host7/target7:0:0/7:0:0:0/block/sdb/sdb2'  (string)
  org.freedesktop.Hal.Device.Volume.method_argnames =3D {'mount_point fstyp=
e extra_options', 'extra_options', 'extra_options'} (string list)
  org.freedesktop.Hal.Device.Volume.method_execpaths =3D {'hal-storage-moun=
t', 'hal-storage-unmount', 'hal-storage-eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_names =3D {'Mount', 'Unmount', '=
Eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_signatures =3D {'ssas', 'as', 'a=
s'} (string list)
  storage.model =3D ''  (string)
  volume.block_size =3D 512  (0x200)  (int)
  volume.fstype =3D 'ntfs'  (string)
  volume.fsusage =3D 'filesystem'  (string)
  volume.fsversion =3D '3.1'  (string)
  volume.ignore =3D false  (bool)
  volume.is_disc =3D false  (bool)
  volume.is_mounted =3D true  (bool)
  volume.is_mounted_read_only =3D false  (bool)
  volume.is_partition =3D true  (bool)
  volume.label =3D 'Win (External)'  (string)
  volume.linux.is_device_mapper =3D false  (bool)
  volume.mount.valid_options =3D {'ro', 'sync', 'dirsync', 'noatime', 'nodi=
ratime', 'noexec', 'quiet', 'remount', 'exec', 'uid=3D', 'gid=3D', 'umask=
=3D', 'locale=3D', 'utf8'} (string list)
  volume.mount_point =3D '/media/Win (External)'  (string)
  volume.num_blocks =3D 78798825  (0x4b25fe9)  (uint64)
  volume.partition.flags =3D {} (string list)
  volume.partition.label =3D ''  (string)
  volume.partition.media_size =3D 250059350016  (0x3a38b2e000)  (uint64)
  volume.partition.number =3D 2  (0x2)  (int)
  volume.partition.scheme =3D 'mbr'  (string)
  volume.partition.start =3D 209711738880  (0x30d3cb3000)  (uint64)
  volume.partition.type =3D '0x07'  (string)
  volume.partition.uuid =3D ''  (string)
  volume.size =3D 40344998400  (0x964bfd200)  (uint64)
  volume.unmount.valid_options =3D {'lazy'} (string list)
  volume.uuid =3D '30FF27821566D335'  (string)

udi =3D '/org/freedesktop/Hal/devices/volume_uuid_1c7fd67b_3213_4d8c_a416_b=
bcd2b7a6d61'
  block.device =3D '/dev/sdb1'  (string)
  block.is_volume =3D true  (bool)
  block.major =3D 8  (0x8)  (int)
  block.minor =3D 17  (0x11)  (int)
  block.storage_device =3D '/org/freedesktop/Hal/devices/storage_serial_WD_=
2500JB_External_57442D574D414E4B32323630343131_0_0'  (string)
  info.capabilities =3D {'volume', 'block'} (string list)
  info.category =3D 'volume'  (string)
  info.interfaces =3D {'org.freedesktop.Hal.Device.Volume'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/storage_serial_WD_2500JB_Ex=
ternal_57442D574D414E4B32323630343131_0_0'  (string)
  info.product =3D 'Ext4 (External)'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/volume_uuid_1c7fd67b_3213_4d8c=
_a416_bbcd2b7a6d61'  (string)
  linux.hotplug_type =3D 3  (0x3)  (int)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-1/2-1:1=
.0/host7/target7:0:0/7:0:0:0/block/sdb/sdb1'  (string)
  org.freedesktop.Hal.Device.Volume.method_argnames =3D {'mount_point fstyp=
e extra_options', 'extra_options', 'extra_options'} (string list)
  org.freedesktop.Hal.Device.Volume.method_execpaths =3D {'hal-storage-moun=
t', 'hal-storage-unmount', 'hal-storage-eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_names =3D {'Mount', 'Unmount', '=
Eject'} (string list)
  org.freedesktop.Hal.Device.Volume.method_signatures =3D {'ssas', 'as', 'a=
s'} (string list)
  storage.model =3D ''  (string)
  volume.block_size =3D 512  (0x200)  (int)
  volume.fstype =3D 'ext4'  (string)
  volume.fsusage =3D 'filesystem'  (string)
  volume.fsversion =3D '1.0'  (string)
  volume.ignore =3D false  (bool)
  volume.is_disc =3D false  (bool)
  volume.is_mounted =3D true  (bool)
  volume.is_mounted_read_only =3D false  (bool)
  volume.is_partition =3D true  (bool)
  volume.label =3D 'Ext4 (External)'  (string)
  volume.linux.is_device_mapper =3D false  (bool)
  volume.mount.valid_options =3D {'ro', 'sync', 'dirsync', 'noatime', 'nodi=
ratime', 'noexec', 'quiet', 'remount', 'exec'} (string list)
  volume.mount_point =3D '/media/Ext4 (External)'  (string)
  volume.num_blocks =3D 409593177  (0x1869e559)  (uint64)
  volume.partition.flags =3D {} (string list)
  volume.partition.label =3D ''  (string)
  volume.partition.media_size =3D 250059350016  (0x3a38b2e000)  (uint64)
  volume.partition.number =3D 1  (0x1)  (int)
  volume.partition.scheme =3D 'mbr'  (string)
  volume.partition.start =3D 32256  (0x7e00)  (uint64)
  volume.partition.type =3D '0x83'  (string)
  volume.partition.uuid =3D ''  (string)
  volume.size =3D 209711706624  (0x30d3cab200)  (uint64)
  volume.unmount.valid_options =3D {'lazy'} (string list)
  volume.uuid =3D '1c7fd67b-3213-4d8c-a416-bbcd2b7a6d61'  (string)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_04_1_if0'
  info.linux.driver =3D 'hub'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_0=
4_1'  (string)
  info.product =3D 'USB Hub Interface'  (string)
  info.subsystem =3D 'usb'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_04_1=
_if0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-0:1.0' =
 (string)
  usb.bus_number =3D 2  (0x2)  (int)
  usb.can_wake_up =3D true  (bool)
  usb.configuration_value =3D 1  (0x1)  (int)
  usb.device_class =3D 9  (0x9)  (int)
  usb.device_protocol =3D 0  (0x0)  (int)
  usb.device_revision_bcd =3D 518  (0x206)  (int)
  usb.device_subclass =3D 0  (0x0)  (int)
  usb.interface.class =3D 9  (0x9)  (int)
  usb.interface.number =3D 0  (0x0)  (int)
  usb.interface.protocol =3D 0  (0x0)  (int)
  usb.interface.subclass =3D 0  (0x0)  (int)
  usb.is_self_powered =3D true  (bool)
  usb.linux.device_number =3D 1  (0x1)  (int)
  usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.1/usb2/2-0:1=
.0'  (string)
  usb.max_power =3D 0  (0x0)  (int)
  usb.num_configurations =3D 1  (0x1)  (int)
  usb.num_interfaces =3D 1  (0x1)  (int)
  usb.num_ports =3D 5  (0x5)  (int)
  usb.product =3D 'USB Hub Interface'  (string)
  usb.product_id =3D 2  (0x2)  (int)
  usb.serial =3D '0000:00:04.1'  (string)
  usb.speed =3D 480.0 (480) (double)
  usb.vendor =3D 'Linux Foundation'  (string)
  usb.vendor_id =3D 7531  (0x1d6b)  (int)
  usb.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_55e_0'
  info.linux.driver =3D 'ohci_hcd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 OHCI USB 1.1 Controller'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_55e_0'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0'  (string)
  pci.device_class =3D 12  (0xc)  (int)
  pci.device_protocol =3D 16  (0x10)  (int)
  pci.device_subclass =3D 3  (0x3)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0'  (string)
  pci.product =3D 'MCP67 OHCI USB 1.1 Controller'  (string)
  pci.product_id =3D 1374  (0x55e)  (int)
  pci.subsys_product_id =3D 1374  (0x55e)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_04_0'
  info.linux.driver =3D 'usb'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_55e_0'  (string)
  info.product =3D '1.1 root hub'  (string)
  info.subsystem =3D 'usb_device'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_04_0=
'  (string)
  info.vendor =3D 'Linux Foundation'  (string)
  linux.device_file =3D '/dev/bus/usb/004/001'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4'  (string)
  usb_device.bus_number =3D 4  (0x4)  (int)
  usb_device.can_wake_up =3D true  (bool)
  usb_device.configuration_value =3D 1  (0x1)  (int)
  usb_device.device_class =3D 9  (0x9)  (int)
  usb_device.device_protocol =3D 0  (0x0)  (int)
  usb_device.device_revision_bcd =3D 518  (0x206)  (int)
  usb_device.device_subclass =3D 0  (0x0)  (int)
  usb_device.is_self_powered =3D true  (bool)
  usb_device.linux.device_number =3D 1  (0x1)  (int)
  usb_device.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb=
4'  (string)
  usb_device.max_power =3D 0  (0x0)  (int)
  usb_device.num_configurations =3D 1  (0x1)  (int)
  usb_device.num_interfaces =3D 1  (0x1)  (int)
  usb_device.num_ports =3D 5  (0x5)  (int)
  usb_device.product =3D '1.1 root hub'  (string)
  usb_device.product_id =3D 1  (0x1)  (int)
  usb_device.serial =3D '0000:00:04.0'  (string)
  usb_device.speed =3D 12.0 (12) (double)
  usb_device.vendor =3D 'Linux Foundation'  (string)
  usb_device.vendor_id =3D 7531  (0x1d6b)  (int)
  usb_device.version =3D 1.1 (1.1) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial'
  info.linux.driver =3D 'usb'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_0=
4_0'  (string)
  info.product =3D 'Microsoft Wireless Desktop Receiver 3.1A'  (string)
  info.subsystem =3D 'usb_device'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial'  (=
string)
  info.vendor =3D 'Microsoft Corp.'  (string)
  linux.device_file =3D '/dev/bus/usb/004/002'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-2'  (st=
ring)
  usb_device.bus_number =3D 4  (0x4)  (int)
  usb_device.can_wake_up =3D true  (bool)
  usb_device.configuration_value =3D 1  (0x1)  (int)
  usb_device.device_class =3D 0  (0x0)  (int)
  usb_device.device_protocol =3D 0  (0x0)  (int)
  usb_device.device_revision_bcd =3D 2  (0x2)  (int)
  usb_device.device_subclass =3D 0  (0x0)  (int)
  usb_device.is_self_powered =3D false  (bool)
  usb_device.linux.device_number =3D 2  (0x2)  (int)
  usb_device.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb=
4/4-2'  (string)
  usb_device.max_power =3D 100  (0x64)  (int)
  usb_device.num_configurations =3D 1  (0x1)  (int)
  usb_device.num_interfaces =3D 2  (0x2)  (int)
  usb_device.num_ports =3D 0  (0x0)  (int)
  usb_device.product =3D 'Microsoft Wireless Desktop Receiver 3.1A'  (strin=
g)
  usb_device.product_id =3D 241  (0xf1)  (int)
  usb_device.speed =3D 1.5 (1.5) (double)
  usb_device.vendor =3D 'Microsoft Corp.'  (string)
  usb_device.vendor_id =3D 1118  (0x45e)  (int)
  usb_device.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if1'
  info.linux.driver =3D 'usbhid'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial'=
  (string)
  info.product =3D 'USB HID Interface'  (string)
  info.subsystem =3D 'usb'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if1=
'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-2/4-2:1=
.1'  (string)
  usb.bus_number =3D 4  (0x4)  (int)
  usb.can_wake_up =3D true  (bool)
  usb.configuration_value =3D 1  (0x1)  (int)
  usb.device_class =3D 0  (0x0)  (int)
  usb.device_protocol =3D 0  (0x0)  (int)
  usb.device_revision_bcd =3D 2  (0x2)  (int)
  usb.device_subclass =3D 0  (0x0)  (int)
  usb.interface.class =3D 3  (0x3)  (int)
  usb.interface.number =3D 1  (0x1)  (int)
  usb.interface.protocol =3D 0  (0x0)  (int)
  usb.interface.subclass =3D 0  (0x0)  (int)
  usb.is_self_powered =3D false  (bool)
  usb.linux.device_number =3D 2  (0x2)  (int)
  usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-2/4=
-2:1.1'  (string)
  usb.max_power =3D 100  (0x64)  (int)
  usb.num_configurations =3D 1  (0x1)  (int)
  usb.num_interfaces =3D 2  (0x2)  (int)
  usb.num_ports =3D 0  (0x0)  (int)
  usb.product =3D 'USB HID Interface'  (string)
  usb.product_id =3D 241  (0xf1)  (int)
  usb.speed =3D 1.5 (1.5) (double)
  usb.vendor =3D 'Microsoft Corp.'  (string)
  usb.vendor_id =3D 1118  (0x45e)  (int)
  usb.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if1_logica=
ldev_input'
  info.addons.singleton =3D {'hald-addon-input'} (string list)
  info.callouts.add =3D {'debian-setup-keyboard'} (string list)
  info.capabilities =3D {'input', 'input.keyboard', 'input.keypad', 'input.=
keys', 'input.mouse', 'button'} (string list)
  info.category =3D 'input'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_=
if1'  (string)
  info.product =3D 'Microsft Microsoft Wireless Desktop Receiver 3.1A'  (st=
ring)
  info.subsystem =3D 'input'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if1=
_logicaldev_input'  (string)
  input.device =3D '/dev/input/event5'  (string)
  input.originating_device =3D '/org/freedesktop/Hal/devices/usb_device_45e=
_f1_noserial_if1'  (string)
  input.product =3D 'Microsft Microsoft Wireless Desktop Receiver 3.1A'  (s=
tring)
  input.x11_driver =3D 'evdev'  (string)
  input.xkb.layout =3D 'us'  (string)
  input.xkb.model =3D 'pc105'  (string)
  input.xkb.options =3D 'lv3:ralt_switch'  (string)
  input.xkb.rules =3D 'evdev'  (string)
  input.xkb.variant =3D 'intl'  (string)
  linux.device_file =3D '/dev/input/event5'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'input'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-2/4-2:1=
.1/input/input5/event5'  (string)

udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if0'
  info.linux.driver =3D 'usbhid'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial'=
  (string)
  info.product =3D 'USB HID Interface'  (string)
  info.subsystem =3D 'usb'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if0=
'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-2/4-2:1=
.0'  (string)
  usb.bus_number =3D 4  (0x4)  (int)
  usb.can_wake_up =3D true  (bool)
  usb.configuration_value =3D 1  (0x1)  (int)
  usb.device_class =3D 0  (0x0)  (int)
  usb.device_protocol =3D 0  (0x0)  (int)
  usb.device_revision_bcd =3D 2  (0x2)  (int)
  usb.device_subclass =3D 0  (0x0)  (int)
  usb.interface.class =3D 3  (0x3)  (int)
  usb.interface.number =3D 0  (0x0)  (int)
  usb.interface.protocol =3D 1  (0x1)  (int)
  usb.interface.subclass =3D 1  (0x1)  (int)
  usb.is_self_powered =3D false  (bool)
  usb.linux.device_number =3D 2  (0x2)  (int)
  usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-2/4=
-2:1.0'  (string)
  usb.max_power =3D 100  (0x64)  (int)
  usb.num_configurations =3D 1  (0x1)  (int)
  usb.num_interfaces =3D 2  (0x2)  (int)
  usb.num_ports =3D 0  (0x0)  (int)
  usb.product =3D 'USB HID Interface'  (string)
  usb.product_id =3D 241  (0xf1)  (int)
  usb.speed =3D 1.5 (1.5) (double)
  usb.vendor =3D 'Microsoft Corp.'  (string)
  usb.vendor_id =3D 1118  (0x45e)  (int)
  usb.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if0_logica=
ldev_input'
  info.addons.singleton =3D {'hald-addon-input'} (string list)
  info.callouts.add =3D {'debian-setup-keyboard'} (string list)
  info.capabilities =3D {'input', 'input.keyboard', 'input.keypad', 'input.=
keys', 'button'} (string list)
  info.category =3D 'input'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_=
if0'  (string)
  info.product =3D 'Microsft Microsoft Wireless Desktop Receiver 3.1A'  (st=
ring)
  info.subsystem =3D 'input'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_45e_f1_noserial_if0=
_logicaldev_input'  (string)
  input.device =3D '/dev/input/event4'  (string)
  input.originating_device =3D '/org/freedesktop/Hal/devices/usb_device_45e=
_f1_noserial_if0'  (string)
  input.product =3D 'Microsft Microsoft Wireless Desktop Receiver 3.1A'  (s=
tring)
  input.x11_driver =3D 'evdev'  (string)
  input.xkb.layout =3D 'us'  (string)
  input.xkb.model =3D 'pc105'  (string)
  input.xkb.options =3D 'lv3:ralt_switch'  (string)
  input.xkb.rules =3D 'evdev'  (string)
  input.xkb.variant =3D 'intl'  (string)
  linux.device_file =3D '/dev/input/event4'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'input'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-2/4-2:1=
.0/input/input4/event4'  (string)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_04_0_if0'
  info.linux.driver =3D 'hub'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_0=
4_0'  (string)
  info.product =3D 'USB Hub Interface'  (string)
  info.subsystem =3D 'usb'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_04_0=
_if0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-0:1.0' =
 (string)
  usb.bus_number =3D 4  (0x4)  (int)
  usb.can_wake_up =3D true  (bool)
  usb.configuration_value =3D 1  (0x1)  (int)
  usb.device_class =3D 9  (0x9)  (int)
  usb.device_protocol =3D 0  (0x0)  (int)
  usb.device_revision_bcd =3D 518  (0x206)  (int)
  usb.device_subclass =3D 0  (0x0)  (int)
  usb.interface.class =3D 9  (0x9)  (int)
  usb.interface.number =3D 0  (0x0)  (int)
  usb.interface.protocol =3D 0  (0x0)  (int)
  usb.interface.subclass =3D 0  (0x0)  (int)
  usb.is_self_powered =3D true  (bool)
  usb.linux.device_number =3D 1  (0x1)  (int)
  usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:04.0/usb4/4-0:1=
.0'  (string)
  usb.max_power =3D 0  (0x0)  (int)
  usb.num_configurations =3D 1  (0x1)  (int)
  usb.num_interfaces =3D 1  (0x1)  (int)
  usb.num_ports =3D 5  (0x5)  (int)
  usb.product =3D 'USB Hub Interface'  (string)
  usb.product_id =3D 1  (0x1)  (int)
  usb.serial =3D '0000:00:04.0'  (string)
  usb.speed =3D 12.0 (12) (double)
  usb.vendor =3D 'Linux Foundation'  (string)
  usb.vendor_id =3D 7531  (0x1d6b)  (int)
  usb.version =3D 1.1 (1.1) (double)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_55f'
  info.linux.driver =3D 'ehci_hcd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 EHCI USB 2.0 Controller'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_55f'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.1'  (string)
  pci.device_class =3D 12  (0xc)  (int)
  pci.device_protocol =3D 32  (0x20)  (int)
  pci.device_subclass =3D 3  (0x3)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.1'  (string)
  pci.product =3D 'MCP67 EHCI USB 2.0 Controller'  (string)
  pci.product_id =3D 1375  (0x55f)  (int)
  pci.subsys_product_id =3D 1375  (0x55f)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_02_1'
  info.linux.driver =3D 'usb'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_55f'  (string)
  info.product =3D '2.0 root hub'  (string)
  info.subsystem =3D 'usb_device'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_02_1=
'  (string)
  info.vendor =3D 'Linux Foundation'  (string)
  linux.device_file =3D '/dev/bus/usb/001/001'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.1/usb1'  (string)
  usb_device.bus_number =3D 1  (0x1)  (int)
  usb_device.can_wake_up =3D true  (bool)
  usb_device.configuration_value =3D 1  (0x1)  (int)
  usb_device.device_class =3D 9  (0x9)  (int)
  usb_device.device_protocol =3D 0  (0x0)  (int)
  usb_device.device_revision_bcd =3D 518  (0x206)  (int)
  usb_device.device_subclass =3D 0  (0x0)  (int)
  usb_device.is_self_powered =3D true  (bool)
  usb_device.linux.device_number =3D 1  (0x1)  (int)
  usb_device.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.1/usb=
1'  (string)
  usb_device.max_power =3D 0  (0x0)  (int)
  usb_device.num_configurations =3D 1  (0x1)  (int)
  usb_device.num_interfaces =3D 1  (0x1)  (int)
  usb_device.num_ports =3D 6  (0x6)  (int)
  usb_device.product =3D '2.0 root hub'  (string)
  usb_device.product_id =3D 2  (0x2)  (int)
  usb_device.serial =3D '0000:00:02.1'  (string)
  usb_device.speed =3D 480.0 (480) (double)
  usb_device.vendor =3D 'Linux Foundation'  (string)
  usb_device.vendor_id =3D 7531  (0x1d6b)  (int)
  usb_device.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_02_1_if0'
  info.linux.driver =3D 'hub'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_0=
2_1'  (string)
  info.product =3D 'USB Hub Interface'  (string)
  info.subsystem =3D 'usb'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_2_0000_00_02_1=
_if0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.1/usb1/1-0:1.0' =
 (string)
  usb.bus_number =3D 1  (0x1)  (int)
  usb.can_wake_up =3D true  (bool)
  usb.configuration_value =3D 1  (0x1)  (int)
  usb.device_class =3D 9  (0x9)  (int)
  usb.device_protocol =3D 0  (0x0)  (int)
  usb.device_revision_bcd =3D 518  (0x206)  (int)
  usb.device_subclass =3D 0  (0x0)  (int)
  usb.interface.class =3D 9  (0x9)  (int)
  usb.interface.number =3D 0  (0x0)  (int)
  usb.interface.protocol =3D 0  (0x0)  (int)
  usb.interface.subclass =3D 0  (0x0)  (int)
  usb.is_self_powered =3D true  (bool)
  usb.linux.device_number =3D 1  (0x1)  (int)
  usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.1/usb1/1-0:1=
.0'  (string)
  usb.max_power =3D 0  (0x0)  (int)
  usb.num_configurations =3D 1  (0x1)  (int)
  usb.num_interfaces =3D 1  (0x1)  (int)
  usb.num_ports =3D 6  (0x6)  (int)
  usb.product =3D 'USB Hub Interface'  (string)
  usb.product_id =3D 2  (0x2)  (int)
  usb.serial =3D '0000:00:02.1'  (string)
  usb.speed =3D 480.0 (480) (double)
  usb.vendor =3D 'Linux Foundation'  (string)
  usb.vendor_id =3D 7531  (0x1d6b)  (int)
  usb.version =3D 2.0 (2) (double)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_55e'
  info.linux.driver =3D 'ohci_hcd'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 OHCI USB 1.1 Controller'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_55e'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.0'  (string)
  pci.device_class =3D 12  (0xc)  (int)
  pci.device_protocol =3D 16  (0x10)  (int)
  pci.device_subclass =3D 3  (0x3)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.0'  (string)
  pci.product =3D 'MCP67 OHCI USB 1.1 Controller'  (string)
  pci.product_id =3D 1374  (0x55e)  (int)
  pci.subsys_product_id =3D 1374  (0x55e)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_02_0'
  info.linux.driver =3D 'usb'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_55e'  (string)
  info.product =3D '1.1 root hub'  (string)
  info.subsystem =3D 'usb_device'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_02_0=
'  (string)
  info.vendor =3D 'Linux Foundation'  (string)
  linux.device_file =3D '/dev/bus/usb/003/001'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.0/usb3'  (string)
  usb_device.bus_number =3D 3  (0x3)  (int)
  usb_device.can_wake_up =3D true  (bool)
  usb_device.configuration_value =3D 1  (0x1)  (int)
  usb_device.device_class =3D 9  (0x9)  (int)
  usb_device.device_protocol =3D 0  (0x0)  (int)
  usb_device.device_revision_bcd =3D 518  (0x206)  (int)
  usb_device.device_subclass =3D 0  (0x0)  (int)
  usb_device.is_self_powered =3D true  (bool)
  usb_device.linux.device_number =3D 1  (0x1)  (int)
  usb_device.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.0/usb=
3'  (string)
  usb_device.max_power =3D 0  (0x0)  (int)
  usb_device.num_configurations =3D 1  (0x1)  (int)
  usb_device.num_interfaces =3D 1  (0x1)  (int)
  usb_device.num_ports =3D 6  (0x6)  (int)
  usb_device.product =3D '1.1 root hub'  (string)
  usb_device.product_id =3D 1  (0x1)  (int)
  usb_device.serial =3D '0000:00:02.0'  (string)
  usb_device.speed =3D 12.0 (12) (double)
  usb_device.vendor =3D 'Linux Foundation'  (string)
  usb_device.vendor_id =3D 7531  (0x1d6b)  (int)
  usb_device.version =3D 1.1 (1.1) (double)

udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_02_0_if0'
  info.linux.driver =3D 'hub'  (string)
  info.parent =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_0=
2_0'  (string)
  info.product =3D 'USB Hub Interface'  (string)
  info.subsystem =3D 'usb'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/usb_device_1d6b_1_0000_00_02_0=
_if0'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'usb'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.0/usb3/3-0:1.0' =
 (string)
  usb.bus_number =3D 3  (0x3)  (int)
  usb.can_wake_up =3D true  (bool)
  usb.configuration_value =3D 1  (0x1)  (int)
  usb.device_class =3D 9  (0x9)  (int)
  usb.device_protocol =3D 0  (0x0)  (int)
  usb.device_revision_bcd =3D 518  (0x206)  (int)
  usb.device_subclass =3D 0  (0x0)  (int)
  usb.interface.class =3D 9  (0x9)  (int)
  usb.interface.number =3D 0  (0x0)  (int)
  usb.interface.protocol =3D 0  (0x0)  (int)
  usb.interface.subclass =3D 0  (0x0)  (int)
  usb.is_self_powered =3D true  (bool)
  usb.linux.device_number =3D 1  (0x1)  (int)
  usb.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:02.0/usb3/3-0:1=
.0'  (string)
  usb.max_power =3D 0  (0x0)  (int)
  usb.num_configurations =3D 1  (0x1)  (int)
  usb.num_interfaces =3D 1  (0x1)  (int)
  usb.num_ports =3D 6  (0x6)  (int)
  usb.product =3D 'USB Hub Interface'  (string)
  usb.product_id =3D 1  (0x1)  (int)
  usb.serial =3D '0000:00:02.0'  (string)
  usb.speed =3D 12.0 (12) (double)
  usb.vendor =3D 'Linux Foundation'  (string)
  usb.vendor_id =3D 7531  (0x1d6b)  (int)
  usb.version =3D 1.1 (1.1) (double)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_543'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 Co-processor'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_543'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:01.3'  (string)
  pci.device_class =3D 11  (0xb)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 64  (0x40)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:01.3'  (string)
  pci.product =3D 'MCP67 Co-processor'  (string)
  pci.product_id =3D 1347  (0x543)  (int)
  pci.subsys_product_id =3D 1347  (0x543)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_542'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 SMBus'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_542'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:01.1'  (string)
  pci.device_class =3D 12  (0xc)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 5  (0x5)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:01.1'  (string)
  pci.product =3D 'MCP67 SMBus'  (string)
  pci.product_id =3D 1346  (0x542)  (int)
  pci.subsys_product_id =3D 1346  (0x542)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_548'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 ISA Bridge'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_548'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:01.0'  (string)
  pci.device_class =3D 6  (0x6)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 1  (0x1)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:01.0'  (string)
  pci.product =3D 'MCP67 ISA Bridge'  (string)
  pci.product_id =3D 1352  (0x548)  (int)
  pci.subsys_product_id =3D 1352  (0x548)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/pci_10de_547'
  info.parent =3D '/org/freedesktop/Hal/devices/computer'  (string)
  info.product =3D 'MCP67 Memory Controller'  (string)
  info.subsystem =3D 'pci'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/pci_10de_547'  (string)
  info.vendor =3D 'nVidia Corporation'  (string)
  linux.hotplug_type =3D 2  (0x2)  (int)
  linux.subsystem =3D 'pci'  (string)
  linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:00.0'  (string)
  pci.device_class =3D 5  (0x5)  (int)
  pci.device_protocol =3D 0  (0x0)  (int)
  pci.device_subclass =3D 0  (0x0)  (int)
  pci.linux.sysfs_path =3D '/sys/devices/pci0000:00/0000:00:00.0'  (string)
  pci.product =3D 'MCP67 Memory Controller'  (string)
  pci.product_id =3D 1351  (0x547)  (int)
  pci.subsys_product_id =3D 1351  (0x547)  (int)
  pci.subsys_vendor =3D 'ASRock Incorporation'  (string)
  pci.subsys_vendor_id =3D 6217  (0x1849)  (int)
  pci.vendor =3D 'nVidia Corporation'  (string)
  pci.vendor_id =3D 4318  (0x10de)  (int)

udi =3D '/org/freedesktop/Hal/devices/fuse'
  access_control.file =3D '/dev/fuse'  (string)
  access_control.type =3D 'camera'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'access_control'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/pci_10de_547'  (string)
  info.subsystem =3D 'unknown'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/fuse'  (string)

udi =3D '/org/freedesktop/Hal/devices/kvm'
  access_control.file =3D '/dev/kvm'  (string)
  access_control.type =3D 'virt-hardware'  (string)
  info.callouts.add =3D {'hal-acl-tool --add-device'} (string list)
  info.callouts.remove =3D {'hal-acl-tool --remove-device'} (string list)
  info.capabilities =3D {'access_control'} (string list)
  info.parent =3D '/org/freedesktop/Hal/devices/fuse'  (string)
  info.subsystem =3D 'unknown'  (string)
  info.udi =3D '/org/freedesktop/Hal/devices/kvm'  (string)


Dumped 132 device(s) from the Global Device List.
------------------------------------------------


--MP_/d8yPooacxzVcitpxRML4kKi
Content-Type: text/x-patch; name=acpi-reboot-reverse-8fd14591.patch
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename=acpi-reboot-reverse-8fd14591.patch

diff --git a/drivers/acpi/reboot.c b/drivers/acpi/reboot.c
index 755baf2..a6b662c 100644
--- a/drivers/acpi/reboot.c
+++ b/drivers/acpi/reboot.c
@@ -15,28 +15,9 @@ void acpi_reboot(void)
=20
 	rr =3D &acpi_gbl_FADT.reset_register;
=20
-	/*
-	 * Is the ACPI reset register supported?
-	 *
-	 * According to ACPI 3.0, FADT.flags.RESET_REG_SUP indicates
-	 * whether the ACPI reset mechanism is supported.
-	 *
-	 * However, some boxes have this bit clear, yet a valid
-	 * ACPI_RESET_REG & RESET_VALUE, and ACPI reboot is the only
-	 * mechanism that works for them after S3.
-	 *
-	 * This suggests that other operating systems may not be checking
-	 * the RESET_REG_SUP bit, and are using other means to decide
-	 * whether to use the ACPI reboot mechanism or not.
-	 *
-	 * So when acpi reboot is requested,
-	 * only the reset_register is checked. If the following
-	 * conditions are met, it indicates that the reset register is supported.
-	 * 	a. reset_register is not zero
-	 * 	b. the access width is eight
-	 * 	c. the bit_offset is zero
-	 */
-	if (!(rr->address) || rr->bit_width !=3D 8 || rr->bit_offset !=3D 0)
+	/* Is the reset register supported? */
+	if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER) ||
+	    rr->bit_width !=3D 8 || rr->bit_offset !=3D 0)
 		return;
=20
 	reset_value =3D acpi_gbl_FADT.reset_value;

--MP_/d8yPooacxzVcitpxRML4kKi--

--Sig_/x+KKzZfuFzZhjhakHNub3ZX
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEAREDAAYFAkkODdEACgkQ0kE/IBnFmjDYDQCfQtLeprxFUZpSHmaA2pQaPbI2
8m4An2zURMAXhK0tBfAaQgaYMrUIXxZU
=hhwo
-----END PGP SIGNATURE-----

--Sig_/x+KKzZfuFzZhjhakHNub3ZX--
