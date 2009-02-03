Return-Path: <linux-kernel-owner+w=401wt.eu-S1754521AbZBCOTd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbZBCOTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:19:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752770AbZBCOTY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:19:24 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:17501 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585AbZBCOTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:19:23 -0500
Date: Tue, 3 Feb 2009 15:19:01 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Luca Tettamanti <kronos.it@gmail.com>
Cc: Thomas Renninger <trenn@suse.de>, Hans de Goede <hdegoede@redhat.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 1/2] RFC: ACPI: Interface for ACPI drivers to place
 quirk   code which gets executed early
Message-ID: <20090203151901.670b7bf8@hyperion.delvare>
In-Reply-To: <68676e00902030545x131e4144ya751bf6af3e4d33@mail.gmail.com>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
	<200902021822.11906.trenn@suse.de>
	<20090202202246.GA9023@dreamland.darkstar.lan>
	<200902031408.12237.trenn@suse.de>
	<68676e00902030545x131e4144ya751bf6af3e4d33@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Feb 2009 14:45:17 +0100, Luca Tettamanti wrote:
> On Tue, Feb 3, 2009 at 2:08 PM, Thomas Renninger <trenn@suse.de> wrote:
> > On Monday 02 February 2009 21:22:46 Luca Tettamanti wrote:
> >> Il Mon, Feb 02, 2009 at 06:22:10PM +0100, Thomas Renninger ha scritto:
> >> > These two patches are tested on a ASUS machine and worked as expected,
> >> > but probably may still need some cleanup.
> >>
> >> I'd keep the DMI+HID approach since it's more flexible:
> >> - (AFAICS) Thinkpads have different methods for hwmon depending on the
> >>   model and no fixed HID
> >> - With DMI it would be possible to include ASUS motherboards (ATK w/
> >>   hwmon) but exclude ASUS laptops (ATK w/o hwmon).
> > I thought the ATK01[01]0 devices are ASUS specific.
> 
> Me too, I was thinking about using DMI_CHASSIS_TYPE to restrict the
> match only to motherboard (not notebooks).
> 
> > I now found an ATK0100 (not the ATK0110 this is about) on a Sony and a
> > Samsung.
> > I still wonder why you want to restrict the check to ASUS.
> > Your ATK0110 driver would also load on any other machine which has such
> > a device. And why shouldn't a Samsung/Sony/... machine with a ATK0110
> > device not access the hwmon sensor through it?
> 
> Ah, I was unaware that it was used also by other vendors. It the same
> interface though? Do you have a dump of the DSDT of such machines?
> 
> > Should we already look a bit deeper into the ATK0110 device in the quirk
> > to make sure it provides thermal, fan or other hwmon device accessing
> > functionality?
> 
> Hum, maybe it's the best thing to do. Hans,  Jean what do you think?

I'd suggest we first check whether the other vendor implementations are
compatible or not. Then we will know if we must set the resource check
to strict for these as well.

I would still recommend vendor-based tests. Given that ACPI device
names aren't standard, we can't exclude that different vendors come up
with different devices using the same name. So checking only the device
names seem too risky in general (even though it might work OK for
specific cases such as the ATK0110.)

-- 
Jean Delvare
