Return-Path: <linux-kernel-owner+w=401wt.eu-S1757169AbXKTDSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757169AbXKTDSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 22:18:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbXKTDSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 22:18:44 -0500
Received: from hosted02.westnet.com.au ([203.10.1.213]:60523 "EHLO
	hosted02.westnet.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857AbXKTDSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 22:18:43 -0500
From: Mike Lampard <mike@secnet.net.au>
To: Wim Van Sebroeck <wim@iguana.be>
Subject: Re: [WATCHDOG] v2.6.24 Watchdog Device Drivers patches - part 4
Date: Tue, 20 Nov 2007 13:44:13 +1030
User-Agent: KMail/1.9.7
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Hans-Christian Egtvedt <hcegtvedt@atmel.com>,
       Samuel Tardieu <sam@rfc1149.net>, Jiri Slaby <jirislaby@gmail.com>,
       "Jorge Boncompte [ DTI2 ]" <jorge@dti2.net>
References: <20071119213220.GA3289@infomag.infomag.iguana.be>
In-Reply-To: <20071119213220.GA3289@infomag.infomag.iguana.be>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200711201344.15214.mike@secnet.net.au>
X-GROMMIT-SECNET-NET-AU-MailScanner: Found to be clean
X-GROMMIT-SECNET-NET-AU-MailScanner-SpamCheck: 
X-GROMMIT-SECNET-NET-AU-MailScanner-From: mike@secnet.net.au
X-PMX-Branch: TNG-Outgoing
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
On Tue, 20 Nov 2007 08:02:20 am Wim Van Sebroeck wrote:
> Hi Linus,
>
> Please pull from 'master' branch of
> 	git://git.kernel.org/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
> or if master.kernel.org hasn't synced up yet:
> 	master.kernel.org:/pub/scm/linux/kernel/git/wim/linux-2.6-watchdog.git
>
> This will update the following files:
>
>  drivers/sbus/char/cpwatchdog.c    |    2
>  drivers/watchdog/Kconfig          |   10
>  drivers/watchdog/Makefile         |    1
>  drivers/watchdog/at32ap700x_wdt.c |   69 ++++++
>  drivers/watchdog/bfin_wdt.c       |    2
>  drivers/watchdog/it8712f_wdt.c    |  400
> ++++++++++++++++++++++++++++++++++++++ drivers/watchdog/w83697hf_wdt.c   | 
>   4
>  7 files changed, 481 insertions(+), 7 deletions(-)
>
> with these Changes:
>
> Author: Jorge Boncompte [DTI2] <jorge@dti2.net>
> Date:   Mon Nov 19 15:09:21 2007 +0100
>
>     [WATCHDOG] IT8212F watchdog driver
>
>     This patch adds support for the ITE Tech Inc. IT8712F EC-LPC Super I/O
>     chipset found on many Pentium III and AMD motherboards. Developed using
> code from other watchdog drivers and the datasheet on ITE Tech homepage.
>
>     Signed-off-by: Jorge Boncompte <jorge@dti2.net>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
>
> Author: Jiri Slaby <jirislaby@gmail.com>
> Date:   Sat Nov 10 04:32:45 2007 +0100
>

The following patch applied to the above diff adds support for the IT8716F 
watchdog, which appears to be essentially the same as the IT8712F in all but 
name.

Cheers
Mike

 drivers/watchdog/it8712f_wdt.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

	Signed-off-by: Mike Lampard <mike@mtgambier.net>

diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
index 6330fc0..31c5162 100644
--- a/drivers/watchdog/it8712f_wdt.c
+++ b/drivers/watchdog/it8712f_wdt.c
@@ -36,7 +36,7 @@
 #define NAME "it8712f_wdt"
 
 MODULE_AUTHOR("Jorge Boncompte - DTI2 <jorge@dti2.net>");
-MODULE_DESCRIPTION("IT8712F Watchdog Driver");
+MODULE_DESCRIPTION("IT8712F/IT8716F Watchdog Driver");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
 
@@ -65,6 +65,7 @@ static unsigned short address;
 #define BASE_REG	0x60	/* LDN Register: Base address */
 
 #define IT8712F_DEVID	0x8712
+#define IT8716F_DEVID	0x8716
 
 #define LDN_GPIO	0x07	/* GPIO and Watch Dog Timer */
 #define LDN_GAME 	0x09	/* Game Port */
@@ -319,7 +320,7 @@ it8712f_wdt_find(unsigned short *address)
 
 	superio_enter();
 	chip_type = superio_inw(DEVID);
-	if (chip_type != IT8712F_DEVID)
+	if (chip_type != IT8712F_DEVID && chip_type != IT8716F_DEVID)
 		goto exit;
 
 	superio_select(LDN_GAME);
