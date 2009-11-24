Return-Path: <linux-kernel-owner+w=401wt.eu-S934059AbZKXVXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934059AbZKXVXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933426AbZKXVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:23:39 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:47287 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933423AbZKXVXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:23:39 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Tue, 24 Nov 2009 22:23:30 +0100
User-Agent: KMail/1.9.10
Cc: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <200911240829.23067.linux@rainbow-software.org> <ac3eb2510911240057h2d2ca308pfeb9c8a94920d543@mail.gmail.com>
In-Reply-To: <ac3eb2510911240057h2d2ca308pfeb9c8a94920d543@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911242223.33206.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 November 2009 09:57:28 Kay Sievers wrote:
> On Tue, Nov 24, 2009 at 08:29, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > On Monday 23 November 2009, Kay Sievers wrote:
> >> On Mon, Nov 23, 2009 at 09:40, Takashi Iwai <tiwai@suse.de> wrote:
> >> > At Mon, 23 Nov 2009 13:59:53 +1030,
> >> >
> >> > Rusty Russell wrote:
> >> >> On Mon, 23 Nov 2009 07:31:57 am Ondrej Zary wrote:
> >> >> > The problem is that
> >> >> > scripts/mod/file2alias.c simply ignores isapnp.
> >> >>
> >> >> AFAICT it always has, and noone has complained until now.  Perhaps
> >> >> something was still reading /lib/modules/`uname
> >> >> -r`/modules.isapnpmap?
> >> >
> >> > I don't think modules.isapnpmap is needed again.
> >> > The question came from the fact that the isapnp device wasn't loaded
> >> > automatically.
> >>
> >> All the map files are not uses for anything these days. Ideally,
> >> depmod should just stop creating these dead files.
> >>
> >> > But, I thought Kay already added isapnp support sometime ago, but it
> >> > didn't seem to get in...  Kay?
> >>
> >> No, we don't even have proper modaliases for the pnp bus
> >> (/sys/bus/pnp) and the alias string for pnp in the modules have a
> >> broken and unfixable format. PNP autoloading is all handled by the
> >> acpi modaliases these days. This is the first time in years I hear
> >> anybody asking for hotplug setups of plain old pnp devices. :)
> >
> > Added these two lines to modules.alias (and deleted modules.alias.bin):
> > alias acpi*:RTL8019:* ne
> > alias pnp:dRTL8019* ne
> >
> > and it works. This works too:
> > alias acpi*:PNP80d6:* ne
> > alias pnp:dPNP80d6* ne
>
> Oh, your box has acpi mapped pnp aliases for this device? You can see
> your ID string somewhere in this list?
>   grep . /sys/bus/acpi/devices/*/modalias
>
> If not, is it in the pnp bus list?
>   grep . /sys/bus/pnp/devices/*/id

It's listen in the pnp bus only:

$ grep -i 80d6 /sys/bus/acpi/devices/*/modalias
$ grep -i 80d6 /sys/bus/pnp/devices/*/id
/sys/bus/pnp/devices/01:01.00/id:PNP80d6
$ cat /sys/bus/pnp/devices/01\:01.00/id
RTL8019
PNP80d6

So the acpi alias was useless (I just copied another entry). This alone works:
alias pnp:dPNP80d6* ne

-- 
Ondrej Zary
