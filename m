Return-Path: <linux-kernel-owner+w=401wt.eu-S1756254AbZGOWje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254AbZGOWje (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 18:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbZGOWje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 18:39:34 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:45158 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225AbZGOWjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 18:39:33 -0400
Date: Thu, 16 Jul 2009 00:39:31 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31-rc2: thinkpad boots with backlight low
Message-ID: <20090715223931.GA18924@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Pavel Machek <pavel@ucw.cz>,
	kernel list <linux-kernel@vger.kernel.org>
References: <20090714092513.GB2010@elf.ucw.cz> <20090715112204.GA16289@yamamaya.is-a-geek.org> <20090715143509.GC22098@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090715143509.GC22098@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Henrique de Moraes Holschuh wrote:
> There is one thing that comes to mind: display power management.
> 
> Is anything, by chance, setting the backlight devices to low power mode
> on machine restart?  The backlight drivers would try to set brightness
> to 0 when it cannot turn the display off for real...

Whatever registers /sys/class/backlight/thinkpad_screen/ seems to be
responsible.
After boot this has 0 for brightness and actual_brightness, 7 for
max_brightness.
Adjusting the backlight brightness with thinkpad keys does not
affect this at all, it always stays at 0.
If I manually change it to 7 and reboot (or poweroff, for
that matter), then backlight brightness is apparently changed to
that value (instead of minimum).

grepping shows it's actually thinkpad_acpi registering
thinkpad_screen. (Well, that was kind of to be expected)
And /proc/acpi/ibm/brightness also doesn't seem to reflect the real
current value...

What irritates me is that a compiled in thinkpad_acpi does not show
up as a module in /sys/modules and so I can't look at the
module parameters. (brightness_mode looks interesting)

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
