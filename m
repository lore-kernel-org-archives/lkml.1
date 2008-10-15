Return-Path: <linux-kernel-owner+w=401wt.eu-S1754449AbYJOKVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449AbYJOKVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 06:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYJOKVB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 06:21:01 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:46721 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842AbYJOKU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:20:59 -0400
Date: Wed, 15 Oct 2008 13:20:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: zippel@linux-m68k.org, sam@ravnborg.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [2.6 patch] HID: fix default building of all quirky devices
Message-ID: <20081015102056.GH20183@cs181140183.pp.htv.fi>
References: <20081015041346.GE4710@cs181140183.pp.htv.fi> <20081015050557.GB20183@cs181140183.pp.htv.fi> <20081015073011.GE20183@cs181140183.pp.htv.fi> <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0810150931350.26779@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2008 at 09:43:18AM +0200, Jiri Kosina wrote:
> On Wed, 15 Oct 2008, Adrian Bunk wrote:
> 
> > Commit 9be7bbd54df3c9c393ccd19acc49f90c517d1291
> > (HID: build drivers for all quirky devices by default)
> > was wrong in that it select'ed the drivers, causing
> > build errors like the following with CONFIG_USB_HID=n:
> > <--  snip  -->
> > 
> > ...
> >   LD      .tmp_vmlinux1
> > drivers/built-in.o: In function `bright_probe':
> > drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
> > drivers/hid/hid-bright.c:38: undefined reference to `usbhid_set_leds'
> > drivers/built-in.o: In function `dell_probe':
> > drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
> > drivers/hid/hid-dell.c:41: undefined reference to `usbhid_set_leds'
> > drivers/built-in.o: In function `lg_probe':
> > drivers/hid/hid-lg.c:252: undefined reference to `usbhid_set_leds'
> > drivers/hid/hid-lg.c:252: more undefined references to `usbhid_set_leds' follow
> > drivers/built-in.o: In function `sony_set_operational':
> > drivers/hid/hid-sony.c:42: undefined reference to `usb_control_msg'
> > drivers/hid/hid-sony.c:42: undefined reference to `usb_control_msg'
> > make[1]: *** [.tmp_vmlinux1] Error 1
> 
> Hmm ... I am not really sure, isn't this a bug in Kconfig?

No.

> What we have right now:
> 
> - CONFIG_HID selects all the individual quirk-drivers automatically
> - the individual quirk drivers have dependency on CONFIG_USB_HID
> 
> Therefore I'd expect when CONFIG_HID is selected and CONFIG_USB_HID 
> deselected the individual drivers not to get built (due to their 
> dependency on unset option).

Different people have different expectations.

Many kernel developers seem to wrongly assume kconfig was something 
trivial and everything that does not work as expected was a bug in 
kconfig. But it is not, and there is no magic bullet like changing
how select behaves in some way that will suddenly solve all problems.

> But currently what happens is when I de-select CONFIG_USB_HID in 
> menuconfig, the configuration options for individual drivers vanish from 
> the menuconfig menu (which is expected, they depend on unset option), but 
> after saving .config they are still there. Is this how it is expected to 
> behave? (i.e. select having preference over dependency).

Select ignores dependencies on the selected options.

That's the documented behavior.

> Thanks,

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

