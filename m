Return-Path: <linux-kernel-owner+w=401wt.eu-S964797AbZKYNVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797AbZKYNVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934657AbZKYNVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:21:37 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:44953 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934584AbZKYNVg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:21:36 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: MODULE_DEVICE_TABLE(isapnp, ...) does nothing
Date: Wed, 25 Nov 2009 14:21:33 +0100
User-Agent: KMail/1.9.10
Cc: Takashi Iwai <tiwai@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, Jon Masters <jonathan@jonmasters.org>,
       Jaroslav Kysela <perex@perex.cz>, Greg KH <gregkh@suse.de>
References: <200911222201.59471.linux@rainbow-software.org> <200911242223.33206.linux@rainbow-software.org> <ac3eb2510911250405j6551150eu4b68261a2e03514f@mail.gmail.com>
In-Reply-To: <ac3eb2510911250405j6551150eu4b68261a2e03514f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200911251421.35966.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 November 2009, Kay Sievers wrote:
> On Tue, Nov 24, 2009 at 22:23, Ondrej Zary <linux@rainbow-software.org> 
wrote:
> > On Tuesday 24 November 2009 09:57:28 Kay Sievers wrote:
> >> Oh, your box has acpi mapped pnp aliases for this device? You can see
> >> your ID string somewhere in this list?
> >>   grep . /sys/bus/acpi/devices/*/modalias
> >>
> >> If not, is it in the pnp bus list?
> >>   grep . /sys/bus/pnp/devices/*/id
> >
> > It's listen in the pnp bus only:
> >
> > $ grep -i 80d6 /sys/bus/acpi/devices/*/modalias
> > $ grep -i 80d6 /sys/bus/pnp/devices/*/id
> > /sys/bus/pnp/devices/01:01.00/id:PNP80d6
> > $ cat /sys/bus/pnp/devices/01\:01.00/id
> > RTL8019
> > PNP80d6
> >
> > So the acpi alias was useless (I just copied another entry). This alone
> > works: alias pnp:dPNP80d6* ne
>
> I see. Plain upstream udev would not load anything here, as the pnp
> bus has no modalias support because of the non-working aliases. We
> rely on acpi mapping all the pnp entries. Your system probably runs
> the shell script which iterates over the "id" file and calls modprobe
> for all it finds in there.

It's Debian Squeeze.

-- 
Ondrej Zary
