Return-Path: <linux-kernel-owner+w=401wt.eu-S1765224AbXESWtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765224AbXESWtd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:49:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762967AbXESWtQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:49:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:46663 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760675AbXESWtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:49:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jIof8OZQ6KOgZJhNT7MjIaWgbsZbNMJLwJy0J2InduaLiutgeDIRcnSX4qoWg6SKDoSJjJ8gz9lw1rcAAv3f/ERgafMxa0DeELoljrTovGAXqwLF4FkhP10owuUikcOCwFaPYQ9+Snp9WaDK/ZERNxxrjfnx5H9iwGSdA6MgH0g=
Message-ID: <a781481a0705191549h602d331flf93c9d6c0261458f@mail.gmail.com>
Date: Sun, 20 May 2007 04:19:12 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Sam Ravnborg" <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "Simon Horman" <horms@verge.net.au>
In-Reply-To: <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519110944.2a52061e.akpm@linux-foundation.org>
	 <a781481a0705191517n15eefe04i5458900c6ffe782d@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 5/19/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Sat, 19 May 2007 17:15:23 +0200 Sam Ravnborg <sam@ravnborg.org> wrote:
> >
> > > We see a lot of these lately:
> > >   GEN     /home/bor/build/linux-2.6.22/Makefile
> > > scripts/kconfig/conf -s arch/i386/Kconfig
> > > drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
> > > drivers/net/Kconfig:2283:warning: 'select' used by config symbol 'UCC_GETH' refers to undefined symbol 'UCC_FAST'
> > > drivers/input/keyboard/Kconfig:170:warning: 'select' used by config symbol 'KEYBOARD_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> > > drivers/input/mouse/Kconfig:182:warning: 'select' used by config symbol 'MOUSE_ATARI' refers to undefined symbol 'ATARI_KBD_CORE'
> > >
> > >
> > > Do this warning really add any value or should we just ignore them like this?
> > >
> >
> > They always indicate Kconfig bugs, don't they?  If so, we should keep the
> > warning.
> >
> > We should also fix the Kconfig bugs but for some reason they tend to hang
> > around for ages and ages.
>
> I remember coming across a thread couple weeks back that contained
> patches that eliminated all four of these .. perhaps nobody picked them
> up. Adding the authors of those patches to CC list (those that I
> remember, at least).
>
> (later)
>
> I think this is the thread, in any case:
>
> http://groups.google.com/group/linux.kernel/browse_frm/thread/d46d5dcecb84424a/1b586d67a1205d86?tvc=1


A combined patch for all of those on top of 22-rc2 (adding Signed-off-by's
for original authors too):

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
Signed-off-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>

---

 arch/m68k/Kconfig                  |    1 +
 arch/powerpc/Kconfig               |    1 +
 arch/powerpc/sysdev/qe_lib/Kconfig |    1 +
 drivers/input/keyboard/Kconfig     |    1 -
 drivers/input/mouse/Kconfig        |    1 -
 drivers/macintosh/Kconfig          |    1 -
 drivers/net/Kconfig                |    1 -
 7 files changed, 3 insertions(+), 4 deletions(-)

---

diff -ruNp a/arch/m68k/Kconfig b/arch/m68k/Kconfig
--- a/arch/m68k/Kconfig	2007-05-20 04:11:47.000000000 +0530
+++ b/arch/m68k/Kconfig	2007-05-20 04:23:57.000000000 +0530
@@ -411,6 +411,7 @@ config STRAM_PROC

 config ATARI_KBD_CORE
 	bool
+	default y if KEYBOARD_ATARI || MOUSE_ATARI

 config HEARTBEAT
 	bool "Use power LED as a heartbeat" if AMIGA || APOLLO || ATARI || MAC ||Q40
diff -ruNp a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig	2007-05-20 04:11:48.000000000 +0530
+++ b/arch/powerpc/Kconfig	2007-05-20 04:18:38.000000000 +0530
@@ -119,6 +119,7 @@ config GENERIC_BUG

 config SYS_SUPPORTS_APM_EMULATION
 	bool
+	default y if PMAC_APM_EMU

 config DEFAULT_UIMAGE
 	bool
diff -ruNp a/arch/powerpc/sysdev/qe_lib/Kconfig
b/arch/powerpc/sysdev/qe_lib/Kconfig
--- a/arch/powerpc/sysdev/qe_lib/Kconfig	2007-05-20 04:11:49.000000000 +0530
+++ b/arch/powerpc/sysdev/qe_lib/Kconfig	2007-05-20 04:20:43.000000000 +0530
@@ -12,6 +12,7 @@ config UCC_SLOW

 config UCC_FAST
 	bool
+	default y if UCC_GETH
 	default n
 	select UCC
 	help
diff -ruNp a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
--- a/drivers/input/keyboard/Kconfig	2007-05-20 04:11:55.000000000 +0530
+++ b/drivers/input/keyboard/Kconfig	2007-05-20 04:24:54.000000000 +0530
@@ -167,7 +167,6 @@ config KEYBOARD_AMIGA
 config KEYBOARD_ATARI
 	tristate "Atari keyboard"
 	depends on ATARI
-	select ATARI_KBD_CORE
 	help
 	  Say Y here if you are running Linux on any Atari and have a keyboard
 	  attached.
diff -ruNp a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
--- a/drivers/input/mouse/Kconfig	2007-05-20 04:11:55.000000000 +0530
+++ b/drivers/input/mouse/Kconfig	2007-05-20 04:25:09.000000000 +0530
@@ -179,7 +179,6 @@ config MOUSE_AMIGA
 config MOUSE_ATARI
 	tristate "Atari mouse"
 	depends on ATARI
-	select ATARI_KBD_CORE
 	help
 	  Say Y here if you have an Atari and want its native mouse
 	  supported by the kernel.
diff -ruNp a/drivers/macintosh/Kconfig b/drivers/macintosh/Kconfig
--- a/drivers/macintosh/Kconfig	2007-05-20 04:11:55.000000000 +0530
+++ b/drivers/macintosh/Kconfig	2007-05-20 04:18:57.000000000 +0530
@@ -113,7 +113,6 @@ config PMAC_SMU

 config PMAC_APM_EMU
 	tristate "APM emulation"
-	select SYS_SUPPORTS_APM_EMULATION
 	select APM_EMULATION
 	depends on ADB_PMU && PM

diff -ruNp a/drivers/net/Kconfig b/drivers/net/Kconfig
--- a/drivers/net/Kconfig	2007-05-20 04:11:56.000000000 +0530
+++ b/drivers/net/Kconfig	2007-05-20 04:22:15.000000000 +0530
@@ -2280,7 +2280,6 @@ config GFAR_NAPI
 config UCC_GETH
 	tristate "Freescale QE Gigabit Ethernet"
 	depends on QUICC_ENGINE
-	select UCC_FAST
 	help
 	  This driver supports the Gigabit Ethernet mode of the QUICC Engine,
 	  which is available on some Freescale SOCs.
