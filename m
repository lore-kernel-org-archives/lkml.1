Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZKXH3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZKXH3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 02:29:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbZKXH3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 02:29:22 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:40137 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754250AbZKXH3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 02:29:21 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Tue, 24 Nov 2009 08:29:21 +0100
User-Agent: KMail/1.9.10
Cc: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <s5h8wdxab2h.wl%tiwai@suse.de> <ac3eb2510911230613w5543e98bg4203a1fbd7269931@mail.gmail.com>
In-Reply-To: <ac3eb2510911230613w5543e98bg4203a1fbd7269931@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911240829.23067.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 November 2009, Kay Sievers wrote:
> On Mon, Nov 23, 2009 at 09:40, Takashi Iwai <tiwai@suse.de> wrote:
> > At Mon, 23 Nov 2009 13:59:53 +1030,
> >
> > Rusty Russell wrote:
> >> On Mon, 23 Nov 2009 07:31:57 am Ondrej Zary wrote:
> >> > The problem is that
> >> > scripts/mod/file2alias.c simply ignores isapnp.
> >>
> >> AFAICT it always has, and noone has complained until now.  Perhaps
> >> something was still reading /lib/modules/`uname -r`/modules.isapnpmap?
> >
> > I don't think modules.isapnpmap is needed again.
> > The question came from the fact that the isapnp device wasn't loaded
> > automatically.
>
> All the map files are not uses for anything these days. Ideally,
> depmod should just stop creating these dead files.
>
> > But, I thought Kay already added isapnp support sometime ago, but it
> > didn't seem to get in...  Kay?
>
> No, we don't even have proper modaliases for the pnp bus
> (/sys/bus/pnp) and the alias string for pnp in the modules have a
> broken and unfixable format. PNP autoloading is all handled by the
> acpi modaliases these days. This is the first time in years I hear
> anybody asking for hotplug setups of plain old pnp devices. :)


Added these two lines to modules.alias (and deleted modules.alias.bin):
alias acpi*:RTL8019:* ne
alias pnp:dRTL8019* ne

and it works. This works too:
alias acpi*:PNP80d6:* ne
alias pnp:dPNP80d6* ne

The card has two IDs (as some PnP devices do) and both work.

-- 
Ondrej Zary
