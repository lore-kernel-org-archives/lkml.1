Return-Path: <linux-kernel-owner+w=401wt.eu-S1758056AbYEKSat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbYEKSat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 14:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756765AbYEKSak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 14:30:40 -0400
Received: from mailgw.infracomspa.it ([217.12.183.244]:1673 "EHLO
	svkmg019i.infracomspa.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756750AbYEKSaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 14:30:39 -0400
X-Greylist: delayed 908 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 May 2008 14:30:39 EDT
Message-ID: <482737BE.20502@infracom.it>
Date: Sun, 11 May 2008 20:15:26 +0200
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: stsp@aknet.ru
Subject: 2.6.26-rc1 regression: e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e breaks
 artsd
X-Enigmail-Version: 0.95.0
X-MIMETrack: Itemize by SMTP Server on Venere/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 05/11/2008 08:15:26 PM,
	Serialize by Router on Bacco/InfracomSpA/IT(Release 6.5.6|March 06, 2007) at
 11/05/2008 20.30.39,
	Serialize complete at 11/05/2008 20.30.39
X-TM-AS-Product-Ver: <SMD>-<3.0.1.3628>-<5.5.1026>-<15894>
X-TM-AS-Result: <No>-<-10002.053>-<5.0>-<99000>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

artsd (kde sound daemon) is broken on current git for my system.

git-bisect reveals the following patch as the culprit:

commit e5e1d3cb20034a3cbcfff1f0bae12201aa2ce17e
Author: Stas Sergeev <stsp@aknet.ru>
Date:   Wed May 7 12:39:56 2008 +0200

    pcspkr: fix dependancies

    fix pcspkr dependancies: make the pcspkr platform
    drivers to depend on a platform device, and
    not the other way around.

    Signed-off-by: Stas Sergeev <stsp@aknet.ru>
    Acked-by: Thomas Gleixner <tglx@linutronix.de>
    Acked-by: Dmitry Torokhov <dtor@mail.ru>
    CC: Vojtech Pavlik <vojtech@suse.cz>
    CC: Michael Opdenacker <michael-lists@free-electrons.com>
    [fixed for 2.6.26-rc1 by tiwai]
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

:040000 040000 b4de6e2cc3456298333f772d1d42f02175436635
b059bb087fcc91e716932de0a88d8fcbd4b10bf0 M      arch
:040000 040000 7ad4e3dd5b5849b03b6de634c296a4e7105d1e88
3c3a6b94a6ba09de08354652d637a63261882354 M      drivers
:040000 040000 1f42e63fb073f1d90c1478a90a7f7006e131a246
c359431c3fc57cae9d6ac1ae995614d3e48772df M      init
:040000 040000 131e667cb1f3d3ea7fbb87052a65a0b35dc41850
40454985821df34702be8a65ede4440859b4ab85 M      sound

I've verified that reverting the above patch on current git fixes the
problem.
Here's the output of lscpi on my laptop (hp nx7010)

00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O
Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP
Controller (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2
EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface
Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE
Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
SMBus Controller (rev 01)
00:1f.5 Multimedia audio controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) AC'97 Audio Controller (rev 01)
00:1f.6 Modem: Intel Corporation 82801DB/DBL/DBM (ICH4/ICH4-L/ICH4-M)
AC'97 Modem Controller (rev 01)
01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250
[Mobility FireGL 9000] (rev 01)
02:00.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host
Controller (rev 80)
02:01.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL-8139/8139C/8139C+ (rev 20)
02:02.0 Network controller: Intel Corporation PRO/Wireless 2200BG
Network Connection (rev 05)
02:04.0 CardBus bridge: ENE Technology Inc CB1410 Cardbus Controller
(rev 01)

More info on request.

Kind regards
R


-- 
Roberto Oppedisano [RO2480-RIPE]
Infracom Network Application                   OSS and LIR Services
Tel. +39 045 8271518   Fax  +39 045 8271499   Cell. +39 348 7419534

