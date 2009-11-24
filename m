Return-Path: <linux-kernel-owner+w=401wt.eu-S934473AbZKXXvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934473AbZKXXvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:51:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934407AbZKXXvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:51:40 -0500
Received: from ozlabs.org ([203.10.76.45]:49911 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934402AbZKXXvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:51:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Wed, 25 Nov 2009 10:21:44 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Takashi Iwai <tiwai@suse.de>, Ondrej Zary <linux@rainbow-software.org>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <200911240821.40563.rusty@rustcorp.com.au> <ac3eb2510911240053n593317b0qe60043988d89810f@mail.gmail.com>
In-Reply-To: <ac3eb2510911240053n593317b0qe60043988d89810f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911251021.44295.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Nov 2009 07:23:51 pm Kay Sievers wrote:
> On Mon, Nov 23, 2009 at 22:51, Rusty Russell <rusty@rustcorp.com.au> wrote:
> > On Mon, 23 Nov 2009 07:10:22 pm Takashi Iwai wrote:
> >> At Mon, 23 Nov 2009 13:59:53 +1030, Rusty Russell wrote:
> >> > Two things are required:
> >> > 1) Modify file2alias to add aliases for isapnp.  This is pretty easy.
> >> > 2) Expose the isapnp devices in sysfs where udev will match them up
> >> >    (/sys/bus/isa/devices/<dev>/modalias I guess?)
> >>
> >> There is non-pnp ISA bus, so I'm afraid "isa" may conflict.
> >> I suppose "isapnp" would be a safer choice.
> >
> > Without pnp, I don't think you can enumerate the ISA bus. Hence I chose
> > "isa:" in the hope that udev would "just work" if isapnp created the
> > modalias under /sys/bus/isa...
> >
> > But Kay says there's a pnp bus (who knew?).  I don't know what he means
> > by unfixable aliases tho, since it's all in the kernel source so we can
> > change it at any time?
> 
> Here's a bit of the background:
> 
> The aliases in the modules can only match a single value, but PNP
> devices often have vendor specific IDs and usual IDs describing the
> function.

I'm confused.  You can have multiple aliases in a module.  Many do.

> Like here, where the interesting ID is only the second one of the two
> for a single device:
>   $ grep . /sys/bus/pnp/devices/*/id
>   /sys/bus/pnp/devices/00:09/id:LEN0006
>   /sys/bus/pnp/devices/00:09/id:PNP0f13
> 
> So the kernel device would need to compose a "modalias" string with
> all IDs in a single line. But the in-module aliases can unfortunately
> match only on a single value, like:
>   alias pnp:dPNP0700* floppy
> 
> For that reason, a while ago udev switched to acpi aliases entirely,
> and dropped all pnp: usage. The acpi aliases can handle multi-values
> just fine with single strings like:
>   $ cat /sys/bus/acpi/devices/LEN0006:00/modalias
>   acpi:LEN0006:PNP0F13:
> 
>   alias acpi*:PNP0700:* floppy

Then why didn't you change the pnp modalias format to be more like the ACPI
one?

(I know nothing about ACPI or PNP, so maybe I'm missing something fundamental).

Thanks,
Rusty.
