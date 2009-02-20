Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbZBTPrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbZBTPrT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZBTPqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:46:54 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:35418 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753863AbZBTPqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:46:53 -0500
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, Kyle McMartin <kyle@mcmartin.ca>,
       David Woodhouse <dwmw2@infradead.org>,
       Richard Zidlicky <rz@linux-m68k.org>, linux-parisc@vger.kernel.org,
       linuxppc-dev@ozlabs.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH/RFC 0/5] Generic RTC class driver
Date: Fri, 20 Feb 2009 16:46:44 +0100
Message-Id: <1235144809-32468-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
X-Mailer: git-send-email 1.6.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been looking into problems with auto-loading the RTC driver on PPC (more
specifically on PS3):
  - The recent "rtc-ppc" RTC class driver is not autoloaded by udev because
    it's an old style platform driver that contains its own platform device.
  - The alternative old "genrtc" driver is autoloaded on non-udev systems only
    because it contains the module alias char-major-10-135. However, it's not
    a new-style RTC class driver.

Fortunately there already exists a generic RTC class driver: "rtc-parisc".
Despite it's name, it's platform-independent, as it's build on top of the RTC
abstraction used by "genrtc".

This patch series
  - adds a missing module alias to rtc-parisc,
  - renames rtc-parisc to rtc-generic,
  - converts the architectures that currently have CONFIG_GEN_RTC enabled in
    their defconfig (m68k, parisc, powerpc) to rtc-generic,
  - removes the obsolete rtc-ppc driver,
  - removes the old genrtc driver.
  
Note that genrtc may be used on other archictectures as well: at least alpha
has the required infrastructure ([gs]et_rtc_time()). The Kconfig rules allow
genrtc to be enabled on several others (cris, h8300, mn10300, um, x86, xtensa).

Furthermore genrtc and rtc-generic are not 100% userspace compatible:
  - /dev/rtc provided by genrtc uses a misc character device (10:135),
  - /dev/rtc provided by rtc-generic uses a dynamic character device.
  
So perhaps we don't want to kill gen-rtc yet?

Any comments are welcomed!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
