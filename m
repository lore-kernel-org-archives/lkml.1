Return-Path: <linux-kernel-owner+w=401wt.eu-S1753051Ab0AZKnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753051Ab0AZKnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 05:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877Ab0AZKnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 05:43:08 -0500
Received: from ns.penguin.cz ([84.21.108.25]:57302 "EHLO ns.penguin.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850Ab0AZKnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 05:43:07 -0500
Subject: Re: gpio_keys and how PXA27x sets gpio_set_wake() (was Re: sharp 
 c-3000 aka spitz: fix warn_on introduced in 2.6.32-rc1)
From: Stanislav Brabec <utx@penguin.cz>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, thommycheck@gmail.com, dbaryshkov@gmail.com,
       dtor@mail.ru, arminlitzel@web.de, linux-input@vger.kernel.org,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       "Rafael J. Wysocki" <rjw@sisk.pl>, lenz@cs.wisc.edu, rpurdie@rpsys.net,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Pavel Machek <pavel@ucw.cz>, Cyril Hrubis <metan@ucw.cz>,
       zaurus-devel@www.linuxtogo.org, omegamoon@gmail.com,
       Vojtech Pavlik <vojtech@suse.cz>
In-Reply-To: <f17812d71001260220v5d03b0e1u1e3bc229827c37c8@mail.gmail.com>
References: <20100106071026.GD1382@ucw.cz>
	 <f17812d71001052317h2bf25fady6bd729b35ef6db63@mail.gmail.com>
	 <20100107065230.GA1303@ucw.cz>
	 <f17812d71001062333y2e49fa21scf91718da9ae3091@mail.gmail.com>
	 <1264275669.9100.11.camel@utx.utx.cz>
	 <1264286611.11766.49.camel@utx.utx.cz>
	 <f17812d71001251958t377e158bxc64aac0cb426110b@mail.gmail.com>
	 <1264500824.4480.79.camel@utx.utx.cz>
	 <f17812d71001260220v5d03b0e1u1e3bc229827c37c8@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-2"
Date: Tue, 26 Jan 2010 11:44:28 +0100
Message-Id: <1264502668.4480.97.camel@utx.utx.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Miao wrote:
> 2010/1/26 Stanislav Brabec <utx@penguin.cz>:

> > Handling platform specific edge/level wake setup would only complicate
> > the code. (In fact, even the PXA270 platform code does not exist yet -
> > arch/arm/mach-pxa/mfp-pxa2xx.c:__mfp_config_gpio() is not capable to
> > configure Power Manager Keyboard Wake-Up Enable Register (PKWR).)
> That's why WAKEUP_ON_EDGE_* is introduced, no need for gpio-keys
> to know this.

But WAKEUP_ON_EDGE_* is impossible for GPIO 95,
enable_irq_wake()/gpio_set_wake() returns EINVAL and disable_irq_wake()
complains on "Unbalanced IRQ 191".

In case of Zaurus, gpio_keys.c have to live with wakeup on level (PKWR)
when using enable/disable_irq_wake().

> > The problem affects gpio_keys: It is a driver implementing "one key per
> > gpio". It now handles On/Off and lid switches on Zaurus. Lid switches
> > are on "normal" GPIOs, On/Off switch is wired to PKWR capable GPIO.
> Ain't On/Off switch one of the matrix key? And so SPITZ_GPIO_KEY_INT
> could be used to handle that?

No. On/Off is connected directly to GPIO 95. Other keys use strobe/sense
matrix keypad.

SPITZ_GPIO_KEY_INT is a bit unspecific. I think it means: Charger was
inserted or key was pressed or On/Off was pressed.



________________________________________________________________________
Stanislav Brabec
http://www.penguin.cz/~utx/zaurus

