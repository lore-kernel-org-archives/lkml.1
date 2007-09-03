Return-Path: <linux-kernel-owner+w=401wt.eu-S1755681AbXICI6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681AbXICI6m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 04:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXICI6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 04:58:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbXICI6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 04:58:33 -0400
Date: Mon, 3 Sep 2007 09:58:47 +0100
From: Stephen Hemminger <shemminger@linux-foundation.org>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Len Brown" <lenb@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fujtisu application panel driver
Message-ID: <20070903095847.72245af4@oldman>
In-Reply-To: <d120d5000707021216y1a3641b1rbc0c741e2d7d4e70@mail.gmail.com>
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net>
	<d120d5000707021216y1a3641b1rbc0c741e2d7d4e70@mail.gmail.com>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 15:16:30 -0400
"Dmitry Torokhov" <dmitry.torokhov@gmail.com> wrote:

> Hi Stephen,
> 
> On 7/2/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> > This driver supports the application buttons on some Fujitsu Lifebook laptops.
> > These buttons are read via the SMBus, for more details see:
> >        http://apanel.sourceforge.net/tech.php
> > The buttons are handled as by the regular input system.
> > Two models are detected now, but other Fujitsu laptop's have
> > keys that may work similarly.
> >
> > It is based on the earlier apanel driver done by Jochen Eisenger, but
> > with many changes.  The original driver used ioctl's and a separate
> > user space program; this version hooks into the input subsystem so
> > that the normal Gnome/KDE shortcuts work without any userspace
> > changes.
> >
> 
> Thank you very much for updating the patch. I have a couple of requests though:
> 
> 1. LEDs shoud use the generic led subsystem instead of input layer. I
> do not have plans of adding any more LED_XXX constants and I think
> that adding any LEDs not directly relating to keyboard state was a
> mistake.

No, way to much work for one stinking LED.
Also there is existing application support for legacy LED_MAIL through
input subsystem, and no application support for mail led through LED
subsystem.

> 2. It would be nice if driver supported changing its keymaps now that
> we allow overriding default getkeycode() and setkeycode().

No, this drivers mapping table is from bits to key codes, not scan codes to keycodes.
Each key is a bit in the scan code, so hitting A and B key generates
scancode of : 0xC = 0x4 | 0x8.
get/setkeycode is designed for keyboards where each key generates different
unique code.

> 3. Do not aaccess input_dev->private directly. input_set_drvdata() and
> input+_getdrvdata shoudl be used.

New version of  driver has to use input_polled_dev->private directly.
