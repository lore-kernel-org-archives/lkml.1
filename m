Return-Path: <linux-kernel-owner+w=401wt.eu-S1759451AbXHKL5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451AbXHKL5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 07:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755905AbXHKL4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 07:56:55 -0400
Received: from smtp-106-saturday.noc.nerim.net ([62.4.17.106]:4606 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752518AbXHKL4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 07:56:54 -0400
Date: Sat, 11 Aug 2007 13:57:05 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Mark M. Hoffman" <mhoffman@lightlink.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc1 regression: hwmon/w83627ehf: wrong fan speed
Message-ID: <20070811135705.0d0688d7@hyperion.delvare>
In-Reply-To: <46BCE6D0.7060300@s5r6.in-berlin.de>
References: <46B5B290.4040907@s5r6.in-berlin.de>
	<20070805162141.GI6221@jupiter.solarsys.private>
	<46B6053E.2050708@s5r6.in-berlin.de>
	<20070810230831.59cbc50f@hyperion.delvare>
	<46BCE6D0.7060300@s5r6.in-berlin.de>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_EZHtUH6tfh_g3tanik=BfJQ"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_EZHtUH6tfh_g3tanik=BfJQ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Stefan,

On Sat, 11 Aug 2007 00:29:36 +0200, Stefan Richter wrote:
> Jean Delvare wrote:
> > I just tried 2.6.23-rc2 on a system where I use the w83627ehf hardware
> > monitoring driver, and was not able to reproduce the problem you
> > described. Fan speeds are reported properly for me. Which I kind of
> > expected, as I tested all my w83627ehf patches on this system before
> > submitting them.
>=20
> Thanks that you are still after it.  I was busy with other stuff the
> whole week, hence no git bisect result from me yet.
>=20
> > Please try using sensors instead of ksensors, and confirm that the
> > behavior is the same. I'd like to rule out a problem in ksensors
> > itself. sensors will also report the fan divs, this is a useful
> > information given the problem you have.
>=20
> # sensors
> w83627ehf-isa-0290
> Adapter: ISA adapter
> VCore:     +0.95 V  (min =3D  +0.00 V, max =3D  +1.74 V)
> in1:      +12.30 V  (min =3D  +1.64 V, max =3D  +3.22 V) ALARM
> AVCC:      +3.28 V  (min =3D  +1.89 V, max =3D  +1.94 V) ALARM
> 3VCC:      +3.26 V  (min =3D  +0.18 V, max =3D  +0.72 V) ALARM
> in4:       +1.58 V  (min =3D  +0.57 V, max =3D  +0.90 V) ALARM
> in5:       +1.70 V  (min =3D  +0.41 V, max =3D  +1.19 V) ALARM
> in6:       +3.43 V  (min =3D  +0.31 V, max =3D  +3.05 V) ALARM
> VSB:       +3.25 V  (min =3D  +0.37 V, max =3D  +3.01 V) ALARM
> VBAT:      +3.18 V  (min =3D  +3.94 V, max =3D  +0.74 V) ALARM
> in9:       +1.88 V  (min =3D  +0.79 V, max =3D  +1.40 V) ALARM
> Case Fan:    0 RPM  (min =3D  753 RPM, div =3D 128) ALARM
> CPU Fan:    88 RPM  (min =3D  659 RPM, div =3D 64) ALARM
> Aux Fan:     0 RPM  (min =3D 10546 RPM, div =3D 128) ALARM
> fan5:        0 RPM  (min =3D  753 RPM, div =3D 128) ALARM
> Sys Temp:    +44 C  (high =3D    -5 C, hyst =3D   -34 C)   ALARM
> CPU Temp:  +38.0 C  (high =3D +80.0 C, hyst =3D +75.0 C)
> AUX Temp:  +43.5 C  (high =3D +80.0 C, hyst =3D +75.0 C)
>=20
> coretemp-isa-0000
> Adapter: ISA adapter
>=20
> coretemp-isa-0001
> Adapter: ISA adapter

Note: a more recent version of lm-sensors would give you additional
temperature values here.

>=20
> (The aux fan and fan5 are not connected.)
>=20
> > Your original post suggests that the fan speed is supposed to change
> > depending on the system load? Or temperature? Please describe the
> > mechanism used to achieve this. Could it be that this mechanism isn't
> > working properly, and the reported (low) speeds are actually true?
>=20
> The motherboard controls the CPU fan and I believe also the case fan,
> probably based on temperatures.  (The manual is buried somewhere and
> MSI's download site is down right in this moment.)

I would like to know what it is doing exactly, and how. Can this
feature be disabled? If the BIOS accesses the W83627EHG chip in our
back, this can cause lots of trouble, such as what you are seeing.

> The low speeds or the dividers incorrect.  I'll reboot in a minute into
> 2.6.22(-rc5)  and post the "sensors" output.
>=20
> > What fan inputs are used by your CPU and system fans? "sensors
> > -c /dev/null" will tell.
>=20
> ...
> fan1:      484 RPM  (min =3D 12053 RPM, div =3D 16) ALARM
> fan2:       89 RPM  (min =3D  659 RPM, div =3D 64) ALARM
> fan3:        0 RPM  (min =3D 10546 RPM, div =3D 128) ALARM
> fan5:        0 RPM  (min =3D 1506 RPM, div =3D 128) ALARM
> ...

Note: 89 RPM with div=3D64 corresponds to the same register value as 1424
RPM with div=3D4 (as shown in your next post). As if the chip and the
driver didn't agree on what the actual divider is.

> Hmm, interesting.  When I now re-run sensors I get
> ...
> Case Fan:  484 RPM  (min =3D 12053 RPM, div =3D 16) ALARM
> CPU Fan:    89 RPM  (min =3D  659 RPM, div =3D 64) ALARM
> Aux Fan:     0 RPM  (min =3D 10546 RPM, div =3D 128) ALARM
> fan5:        0 RPM  (min =3D 1506 RPM, div =3D 128) ALARM
> ...
>=20
> (I'm still in 2.6.23-rc2.  Ksensors picked the 484 RPM of the case fan
> up too, and that's most certainly the correct speed.  Just the CPU fan's
> speed is still wrong; or rather its divider should be 16 rather than 64.)

Divider should be 4,not 16, methinks.

You can dump the chip registers using the following command:
isadump 0x295 0x296
=46rom now on, whenever you paste the output of "sensors", please dump
the contents of the chip too and include the output.

> > Other than that, I can only ask for the same things Mark already
> > suggested: compile with HWMON debugging and provide the logs (this will
> > show what fan div the driver is trying to select), and try bisecting
> > using git to find out which patch exactly caused the problem.
>=20
> How comes the divider of one of the fans changed from one minute to the
> other?

No idea. The new driver can only increase, not decrease, the clock
divider when you poll for a speed value. So the change above (from 128
to 16) is not supposed to happen. However... I also can't explain why
the original reading is 0 (with div=3D128). A reading of 0 only happens
if the divider is too low (i.e. less than 16.) If the driver increased
the divider to 16, it means that it was previously 8, not 128.

Now, given how dividers are encoded:
128 -> 111b
 64 -> 110b
  8 -> 011b
  4 -> 010b

See the pattern? The case fan's clock divider reads 128 when it is 8,
the CPU fan's clock divider reads 64 when it is 4. In both cases, it is
the most significant bit that is wrong. And it happens that this bit is
in a separate register (VBAT, 0x5d), which happens to be in the banked
register range of the W83627EHG (0x50-0x5f).

So my theory is that something else (BIOS, ACPI?) is changing the bank,
probably to read temperature values which are in banks 1 and 2, causing
the w83627ehf to get a wrong value for the VBAT register. If I am
right, then the attached patch should help. Please give it a try and
report.

Mark: the previous version of the driver was initializing the fan mins.
This wasn't needed, however the bank was reset to 0 as a side effect
when initializing fan5_min. When removing the unneeded code, I caused
the initial bank value to become undefined. This explains in part the
odd behavior reported by Stefan. The fix is to either set the bank to 0
explicitly on driver load, or to stop assuming that bank is 0 by
default. My patch does the latter, as it might also help in case
something is later doing concurrent accesses to the chip.

> FWIW, the ``chip "w83627ehf-*"=B4=B4 section in Gentoo's /etc/sensors.conf
> provides only labels for fan{1,2,3}. It is titled
> # Winbond W83627EHF configuration originally contributed by Leon Moonen
> # This is for an Asus P5P800, voltages for A8V-E SE.

This is from the standard default sensors configuration file. It is
expected that you tweak the labels, limits etc. to match your own
motherboard.

> Should I hardwire correct dividers or pulse per rev in sensors.conf or
> is the driver supposed to work the correct dividers out --- like it did
> before 2.6.23-rc?

The driver is supposed to pick the best divider if you set the min fan
speed limits properly (which it seems you didn't.) If you don't set the
min limits, all the driver will do is increase the divider as long as
it gets a 0 reading, so the dividers will be good, but not necessarily
optimum.

Thanks,
--=20
Jean Delvare

--MP_EZHtUH6tfh_g3tanik=BfJQ
Content-Type: text/x-patch; name=hwmon-w83627ehf-dont-assume-bank-0.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=hwmon-w83627ehf-dont-assume-bank-0.patch

Don't assume that the default bank is 0. For one thing, we don't even
set it to 0 when the driver is loaded, so the initial state might be
different. For another, something (say, the BIOS) might access the chip
and leave with the bank set to something different, so assuming that
the bank value is 0 is not safe.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 drivers/hwmon/w83627ehf.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc2.orig/drivers/hwmon/w83627ehf.c	2007-07-23 16:44:35.000000000 +0200
+++ linux-2.6.23-rc2/drivers/hwmon/w83627ehf.c	2007-08-11 12:55:58.000000000 +0200
@@ -309,18 +309,16 @@ static inline int is_word_sized(u16 reg)
 	      || (reg & 0x00ff) == 0x55));
 }
 
-/* We assume that the default bank is 0, thus the following two functions do
-   nothing for registers which live in bank 0. For others, they respectively
-   set the bank register to the correct value (before the register is
-   accessed), and back to 0 (afterwards). */
+/* Registers 0x50-0x5f are banked */
 static inline void w83627ehf_set_bank(struct w83627ehf_data *data, u16 reg)
 {
-	if (reg & 0xff00) {
+	if ((reg & 0x00f0) == 0x50) {
 		outb_p(W83627EHF_REG_BANK, data->addr + ADDR_REG_OFFSET);
 		outb_p(reg >> 8, data->addr + DATA_REG_OFFSET);
 	}
 }
 
+/* Not strictly necessary, but play it safe for now */
 static inline void w83627ehf_reset_bank(struct w83627ehf_data *data, u16 reg)
 {
 	if (reg & 0xff00) {

--MP_EZHtUH6tfh_g3tanik=BfJQ--
