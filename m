Return-Path: <linux-kernel-owner+w=401wt.eu-S1761760AbXIZWdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761760AbXIZWdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 18:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbXIZWdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 18:33:24 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:18820 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbXIZWdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 18:33:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=UJDzlz7m6KxWm2kpEmJ12NqaMoYHipaDBsUiIMtgRJVvB02nfrzYBCefYyCbjTZSrsYXW8EXoGfQQqo1wqp8YvKomiNIssGq5sRvzgULcIt4HDwMAOswkGRHCVwJyZaNg6kX3BW50p77uWuxdmXeeuWmz9Iq9CsY8lLn8F2pF8A=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: xpad_probe: undefined reference to `led_classdev_register'
Date: Wed, 26 Sep 2007 18:33:22 -0400
User-Agent: KMail/1.9.7
Cc: thomas@m3y3r.de, linux-kernel@vger.kernel.org
References: <1190841933.46face4d4ae55@secure.konsole-h.de> <20070926145531.d1e0819c.randy.dunlap@oracle.com>
In-Reply-To: <20070926145531.d1e0819c.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709261833.22226.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 26 September 2007, Randy Dunlap wrote:
> On Wed, 26 Sep 2007 23:25:33 +0200 thomas@m3y3r.de wrote:
> 
> > Hi.
> > 
> > Current linus' git tree:
> > 
> > x86_64-unknown-linux-gnu-ld: BFD 2.15 assertion fail
> > /home/thomas/source/crosstool-0.43/build/x86_64-unknown-linux-gnu/gcc-3.4.5-glibc-2.3.6/binutils-2.15/bfd/linker.c:619
> > drivers/built-in.o(.text+0x20749d): In function `xpad_probe':
> > : undefined reference to `led_classdev_register'
> > drivers/built-in.o(.text+0x20756c): In function `xpad_disconnect':
> > : undefined reference to `led_classdev_unregister'
> > make: *** [.tmp_vmlinux1] Fehler 1
> > 
> > any ideas?
> 
> Please send .config file.
> 
> Ix xpad driver built-in (yes, it is) and led driver is modular?
> We can fix that...
>

I have the patch below in mytree. I guess I need to forward it to Linus
insterad of waiting for 2.6.24 as too many people hit this.

-- 
Dmitry
 
Input: xpad - fix dependancy on LEDS class

The driver can not be built-in when LEDS class is a module.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---
 drivers/input/joystick/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: work/drivers/input/joystick/Kconfig
===================================================================
--- work.orig/drivers/input/joystick/Kconfig
+++ work/drivers/input/joystick/Kconfig
@@ -277,7 +277,7 @@ config JOYSTICK_XPAD_FF
 
 config JOYSTICK_XPAD_LEDS
 	bool "LED Support for Xbox360 controller 'BigX' LED"
-	depends on LEDS_CLASS && JOYSTICK_XPAD
+	depends on JOYSTICK_XPAD && (LEDS_CLASS=y || LEDS_CLASS=JOYSTICK_XPAD)
 	---help---
 	  This option enables support for the LED which surrounds the Big X on
 	  XBox 360 controller.
