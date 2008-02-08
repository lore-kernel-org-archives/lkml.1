Return-Path: <linux-kernel-owner+w=401wt.eu-S1759802AbYBHXjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759802AbYBHXjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 18:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755653AbYBHXi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 18:38:57 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:49527 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227AbYBHXi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 18:38:56 -0500
Date: Fri, 8 Feb 2008 15:37:41 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dtor@insightbb.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [patch] [git pull] Input updates for 2.6.25-rc0
Message-Id: <20080208153741.54409a7a.randy.dunlap@oracle.com>
In-Reply-To: <20080208152812.2bb14374@extreme>
References: <200802060108.31644.dtor@insightbb.com>
	<20080208232536.GA15727@elte.hu>
	<20080208152812.2bb14374@extreme>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 15:28:12 -0800 Stephen Hemminger wrote:

> On Sat, 9 Feb 2008 00:25:36 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Dmitry Torokhov <dtor@insightbb.com> wrote:
> > 
> > > Stephen Hemminger (2):
> > >       Input: add driver for Fujitsu application buttons
> > 
> > this change broke the build on x86 in randconfig testing:
> > 
> >   drivers/built-in.o: In function `apanel_detach_client':
> >   apanel.c:(.text+0x15c120): undefined reference to  `__led_classdev_unregister'
> >   drivers/built-in.o: In function `apanel_probe':
> >   apanel.c:(.text+0x15c30f): undefined reference to  `led_classdev_register'
> > 
> > .config attached.
> > 
> > the Kconfig dependencies seem incomplete:
> > 
> > > +config INPUT_APANEL
> > > +     tristate "Fujitsu Lifebook Application Panel buttons"
> > > +     depends on X86
> > > +     select I2C_I801
> > > +     select INPUT_POLLDEV
> > > +     select CHECK_SIGNATURE
> > > +     help
> > 
> > it doesnt list LEDS.
> > 
> > 	Ingo
> 
> I think someone already sent a patch to select the LEDS

I did... and more.  Who will merge it?  (below)

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Add I2C to config since the driver makes several i2c*() calls.

Add to help text that the Intel I2C ICH (i801) driver is also needed
for this kernel.

Add LEDS_CLASS to config since the driver makes les_classdev_*() calls:
ERROR: "led_classdev_register" [drivers/input/misc/apanel.ko] undefined!
ERROR: "__led_classdev_unregister" [drivers/input/misc/apanel.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/input/misc/Kconfig |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.24-mm1.orig/drivers/input/misc/Kconfig
+++ linux-2.6.24-mm1/drivers/input/misc/Kconfig
@@ -42,14 +42,14 @@ config INPUT_M68K_BEEP
 
 config INPUT_APANEL
 	tristate "Fujitsu Lifebook Application Panel buttons"
-	depends on X86
-	select I2C_I801
+	depends on X86 && I2C && LEDS_CLASS
 	select INPUT_POLLDEV
 	select CHECK_SIGNATURE
 	help
 	 Say Y here for support of the Application Panel buttons, used on
 	 Fujitsu Lifebook. These are attached to the mainboard through
-	 an SMBus interface managed by the I2C Intel ICH (i801) driver.
+	 an SMBus interface managed by the I2C Intel ICH (i801) driver,
+	 which you should also build for this kernel.
 
 	 To compile this driver as a module, choose M here: the module will
 	 be called apanel.
