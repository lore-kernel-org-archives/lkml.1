Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbYAGRvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbYAGRvv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:51:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751761AbYAGRvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:51:44 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:55181 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751489AbYAGRvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:51:43 -0500
Date: Mon, 7 Jan 2008 09:49:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "sudhir kumar" <imsudhirkumar@gmail.com>
Cc: linux-kernel@vger.kernel.org, sam@ravnborg.org,
       Hendrik Sattler <post@hendrik-sattler.de>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [2.6.24-rc6-mm1] Build Failure on ppc64 with CONFIG_USB_GADGET
 not set.
Message-Id: <20080107094955.720c3764.akpm@linux-foundation.org>
In-Reply-To: <3da2c0120801070323v39e6f95esd47cef6b860fbf06@mail.gmail.com>
References: <3da2c0120801070323v39e6f95esd47cef6b860fbf06@mail.gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2008 16:53:58 +0530 "sudhir kumar" <imsudhirkumar@gmail.com> wrote:

> Hi Andrew!
> 
> Kernel build fails on my ppc64 machine. It seems to be  a dependency
> problem with CONFIG_USB_GADGET not set.
> Config file is attached.
> 
>  CC      init/version.o
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `oz99x_remove':
> drivers/i2c/chips/oz99x.c:660: undefined reference to `.led_classdev_unregister'
> drivers/built-in.o: In function `oz99x_configure_leds':
> drivers/i2c/chips/oz99x.c:314: undefined reference to `.led_classdev_register'
> make: *** [.tmp_vmlinux1] Error 1
> 

Strange.

oz99x-i2c-button-and-led-support-driver.patch has

+config OZ99X
+	tristate "O2 Micro/ETC OZ990/OZ992 SMBus chip"
+	depends on I2C
+	select INPUT_POLLDEV
+	select LEDS_CLASS

and your .config gives

box:/usr/src/25> grep LEDS .config
# CONFIG_NEW_LEDS is not set
CONFIG_LEDS_CLASS=y

so drivers/leds/led-class.o should be linked into your vmlinux.  But that
obviously isn't happening.

