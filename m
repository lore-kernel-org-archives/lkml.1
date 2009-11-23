Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbZKWOVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbZKWOVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 09:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752957AbZKWOVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 09:21:19 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:41043 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693AbZKWOVT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 09:21:19 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 09:21:18 EST
MIME-Version: 1.0
In-Reply-To: <s5h8wdxab2h.wl%tiwai@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> 
	<200911231359.54544.rusty@rustcorp.com.au> <s5h8wdxab2h.wl%tiwai@suse.de>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 23 Nov 2009 15:13:27 +0100
Message-ID: <ac3eb2510911230613w5543e98bg4203a1fbd7269931@mail.gmail.com>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
To: Takashi Iwai <tiwai@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Ondrej Zary <linux@rainbow-software.org>, linux-kernel@vger.kernel.org,
       Jon Masters <jonathan@jonmasters.org>, Jaroslav Kysela <perex@perex.cz>,
       Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 23, 2009 at 09:40, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 23 Nov 2009 13:59:53 +1030,
> Rusty Russell wrote:
>>
>> On Mon, 23 Nov 2009 07:31:57 am Ondrej Zary wrote:
>> > The problem is that
>> > scripts/mod/file2alias.c simply ignores isapnp.
>>
>> AFAICT it always has, and noone has complained until now.  Perhaps something
>> was still reading /lib/modules/`uname -r`/modules.isapnpmap?
>
> I don't think modules.isapnpmap is needed again.
> The question came from the fact that the isapnp device wasn't loaded
> automatically.

All the map files are not uses for anything these days. Ideally,
depmod should just stop creating these dead files.

> But, I thought Kay already added isapnp support sometime ago, but it
> didn't seem to get in...  Kay?

No, we don't even have proper modaliases for the pnp bus
(/sys/bus/pnp) and the alias string for pnp in the modules have a
broken and unfixable format. PNP autoloading is all handled by the
acpi modaliases these days. This is the first time in years I hear
anybody asking for hotplug setups of plain old pnp devices. :)

Thanks,
Kay
