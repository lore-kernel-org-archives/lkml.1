Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYJOHn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYJOHn3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 03:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYJOHnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 03:43:21 -0400
Received: from styx.suse.cz ([82.119.242.94]:34617 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751533AbYJOHnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 03:43:20 -0400
Date: Wed, 15 Oct 2008 09:43:18 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Adrian Bunk <bunk@kernel.org>, zippel@linux-m68k.org, sam@ravnborg.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6 patch] HID: fix default building of all quirky devices
In-Reply-To: <20081015073011.GE20183@cs181140183.pp.htv.fi>
Message-ID: <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Oct 2008, Adrian Bunk wrote:

> Commit 9be7bbd54df3c9c393ccd19acc49f90c517d1291
> (HID: build drivers for all quirky devices by default)
> was wrong in that it select'ed the drivers, causing
> build errors like the following with CONFIG_USB_HID=n:
> <--  snip  -->
> 
> ...
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `bright_probe':
> drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
> drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
> drivers/built-in.o: In function `dell_probe':
> drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
> drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
> drivers/built-in.o: In function `lg_probe':
> drivers/hid/hid-lg.c:252: undefined reference to `usbhid_set_leds'
> drivers/hid/hid-lg.c:252: more undefined references to `usbhid_set_leds' follow
> drivers/built-in.o: In function `sony_set_operational':
> drivers/hid/hid-sony.c:42: undefined reference to `usb_control_msg'
> drivers/hid/hid-sony.c:42: undefined reference to `usb_control_msg'
> make[1]: *** [.tmp_vmlinux1] Error 1

Hmm ... I am not really sure, isn't this a bug in Kconfig?

What we have right now:

- CONFIG_HID selects all the individual quirk-drivers automatically
- the individual quirk drivers have dependency on CONFIG_USB_HID

Therefore I'd expect when CONFIG_HID is selected and CONFIG_USB_HID 
deselected the individual drivers not to get built (due to their 
dependency on unset option).

But currently what happens is when I de-select CONFIG_USB_HID in 
menuconfig, the configuration options for individual drivers vanish from 
the menuconfig menu (which is expected, they depend on unset option), but 
after saving .config they are still there. Is this how it is expected to 
behave? (i.e. select having preference over dependency).

Thanks,

-- 
Jiri Kosina
SUSE Labs
