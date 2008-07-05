Return-Path: <linux-kernel-owner+w=401wt.eu-S1754581AbYGEWok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581AbYGEWok (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 18:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYGEWoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 18:44:32 -0400
Received: from mail.gmx.net ([213.165.64.20]:51764 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752435AbYGEWob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 18:44:31 -0400
X-Authenticated: #476490
X-Provags-ID: V01U2FsdGVkX1/c7wlDUPfcU5fLRgA5IJY5CccrjWWY/Gbgs5dnzW
	IAD38bWLiKR6MN
From: Oliver Endriss <o.endriss@gmx.de>
Organization: ESCAPE GmbH EDV-Loesungen
To: v4l-dvb-maintainer@linuxtv.org
Subject: Re: [v4l-dvb-maintainer] build issue #477 for v2.6.26-rc8-290-gb8a0b6c : input_event" [drivers/media/dvb/ttpci/dvb-ttpci.ko] undefined!
Date: Sun, 6 Jul 2008 00:43:30 +0200
User-Agent: KMail/1.9.6
Cc: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>,
       linux-kernel@vger.kernel.org
References: <200807051725.04475.toralf.foerster@gmx.de>
In-Reply-To: <200807051725.04475.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_Tk/bIrHMLJ9y1kC"
Message-Id: <200807060043.31247@orion.escape-edv.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_Tk/bIrHMLJ9y1kC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Toralf F=F6rster wrote:
> Hello,
>=20
> the build (.config attached) failed, make ends with :
> ...
>   Building modules, stage 2.
>   MODPOST 433 modules
> ERROR: "input_event" [drivers/media/dvb/ttpci/dvb-ttpci.ko] undefined!
> ERROR: "input_register_device" [drivers/media/dvb/ttpci/dvb-ttpci.ko] und=
efined!
> ERROR: "input_free_device" [drivers/media/dvb/ttpci/dvb-ttpci.ko] undefin=
ed!
> ERROR: "input_unregister_device" [drivers/media/dvb/ttpci/dvb-ttpci.ko] u=
ndefined!
> ERROR: "input_allocate_device" [drivers/media/dvb/ttpci/dvb-ttpci.ko] und=
efined!
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>=20
>=20
> The build was made with an old .config from kernel 2.6.25-rc9
> (where the build also failed but probably b/c of a different reason) :
> $>make oldconfig; make clean; make
>=20
> Here's the config:
>=20
> #
> # Automatically generated make config: don't edit
> # Linux kernel version: 2.6.26-rc8
> # Sat Jul  5 13:04:33 2008
> #
> ...
> #
> # Input device support
> #
> # CONFIG_INPUT is not set
> ...

Thanks for reporting.
Does the attached patch fix the problem?

CU
Oliver

=2D-=20
=2D---------------------------------------------------------------
VDR Remote Plugin 0.4.0: http://www.escape-edv.de/endriss/vdr/
=2D---------------------------------------------------------------

--Boundary-00=_Tk/bIrHMLJ9y1kC
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="av7110_no_evdev.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="av7110_no_evdev.diff"

Do not compile av7110_ir if CONFIG_INPUT_EVDEV is not selected.

Signed-off-by: Oliver Endriss <o.endriss@gmx.de>

diff -r cb91f21a543e linux/drivers/media/dvb/ttpci/Makefile
--- a/linux/drivers/media/dvb/ttpci/Makefile	Mon Jun 23 22:30:42 2008 +0200
+++ b/linux/drivers/media/dvb/ttpci/Makefile	Sun Jul 06 00:14:15 2008 +0200
@@ -3,7 +3,11 @@
 # and the AV7110 DVB device driver
 #
 
-dvb-ttpci-objs := av7110_hw.o av7110_v4l.o av7110_av.o av7110_ca.o av7110.o av7110_ipack.o av7110_ir.o
+dvb-ttpci-objs := av7110_hw.o av7110_v4l.o av7110_av.o av7110_ca.o av7110.o av7110_ipack.o
+
+ifdef CONFIG_INPUT_EVDEV
+dvb-ttpci-objs += av7110_ir.o
+endif
 
 obj-$(CONFIG_TTPCI_EEPROM) += ttpci-eeprom.o
 obj-$(CONFIG_DVB_BUDGET_CORE) += budget-core.o

--Boundary-00=_Tk/bIrHMLJ9y1kC--
