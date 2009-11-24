Return-Path: <linux-kernel-owner+w=401wt.eu-S932354AbZKXI5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbZKXI5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:57:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932277AbZKXI5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:57:40 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:43225 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244AbZKXI5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:57:40 -0500
MIME-Version: 1.0
In-Reply-To: <200911240829.23067.linux@rainbow-software.org>
References: <200911222201.59471.linux@rainbow-software.org> 
	<s5h8wdxab2h.wl%tiwai@suse.de> <ac3eb2510911230613w5543e98bg4203a1fbd7269931@mail.gmail.com> 
	<200911240829.23067.linux@rainbow-software.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 24 Nov 2009 09:57:28 +0100
Message-ID: <ac3eb2510911240057h2d2ca308pfeb9c8a94920d543@mail.gmail.com>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 24, 2009 at 08:29, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Monday 23 November 2009, Kay Sievers wrote:
>> On Mon, Nov 23, 2009 at 09:40, Takashi Iwai <tiwai@suse.de> wrote:
>> > At Mon, 23 Nov 2009 13:59:53 +1030,
>> >
>> > Rusty Russell wrote:
>> >> On Mon, 23 Nov 2009 07:31:57 am Ondrej Zary wrote:
>> >> > The problem is that
>> >> > scripts/mod/file2alias.c simply ignores isapnp.
>> >>
>> >> AFAICT it always has, and noone has complained until now.  Perhaps
>> >> something was still reading /lib/modules/`uname -r`/modules.isapnpmap?
>> >
>> > I don't think modules.isapnpmap is needed again.
>> > The question came from the fact that the isapnp device wasn't loaded
>> > automatically.
>>
>> All the map files are not uses for anything these days. Ideally,
>> depmod should just stop creating these dead files.
>>
>> > But, I thought Kay already added isapnp support sometime ago, but it
>> > didn't seem to get in...  Kay?
>>
>> No, we don't even have proper modaliases for the pnp bus
>> (/sys/bus/pnp) and the alias string for pnp in the modules have a
>> broken and unfixable format. PNP autoloading is all handled by the
>> acpi modaliases these days. This is the first time in years I hear
>> anybody asking for hotplug setups of plain old pnp devices. :)
>
>
> Added these two lines to modules.alias (and deleted modules.alias.bin):
> alias acpi*:RTL8019:* ne
> alias pnp:dRTL8019* ne
>
> and it works. This works too:
> alias acpi*:PNP80d6:* ne
> alias pnp:dPNP80d6* ne

Oh, your box has acpi mapped pnp aliases for this device? You can see
your ID string somewhere in this list?
  grep . /sys/bus/acpi/devices/*/modalias

If not, is it in the pnp bus list?
  grep . /sys/bus/pnp/devices/*/id

Thanks,
Kay
