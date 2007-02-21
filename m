Return-Path: <linux-kernel-owner+w=401wt.eu-S1161272AbXBUPHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161272AbXBUPHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 10:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXBUPHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 10:07:41 -0500
Received: from smtp-103-wednesday.noc.nerim.net ([62.4.17.103]:2318 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161258AbXBUPHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 10:07:37 -0500
Date: Wed, 21 Feb 2007 16:07:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Chuck Ebbert <cebbert@redhat.com>, Rudolf Marek <r.marek@assembler.cz>,
       linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] Could the k8temp driver be interfering with ACPI?
Message-Id: <20070221160717.d5808ac4.khali@linux-fr.org>
In-Reply-To: <20070220151813.GA6581@srcf.ucam.org>
References: <45D5EA88.7090300@redhat.com>
	<45D6DDCE.5050803@assembler.cz>
	<45D7461A.2040808@redhat.com>
	<20070218183805.5a4fd813.khali@linux-fr.org>
	<20070220151813.GA6581@srcf.ucam.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew,

On Tue, 20 Feb 2007 15:18:13 +0000, Matthew Garrett wrote:
> On Sun, Feb 18, 2007 at 06:38:05PM +0100, Jean Delvare wrote:
> 
> > ACPI is broken here, not k8temp, so let's fix ACPI instead. ACPI
> > doesn't conflict with only k8temp, but with virtually all hardware
> > monitoring drivers, all I2C/SMBus drivers, and probably other types of
> > drivers too. We just can't restrict or blacklist all these drivers
> > because ACPI misbehaves.
> 
> No, the simple fact of the matter is that if you're running on an ACPI 
> platform you need to change some of your assumptions. ACPI owns the 
> hardware. The OS doesn't. To an extent this has always been true on 

The Linux device driver model assumes that it owns the hardware. If
this is not true, then should we prevent any non-ACPI driver from
loading as soon as ACPI is enabled?

> laptops and servers /anyway/ - the BIOS is free to have a wide variety 
> of SMM insanity that invalidates basic assumptions like "If I hold this 
> lock, nothing can interrupt me between this write and this read". That's 
> simply not true.

Yeah, this is correct, and just as unfortunate. It's amazingly sad that
hardware vendors as a whole are still repeating the same design
mistakes over and over again :(

> So this isn't about fixing ACPI. It's about trying to find a mechanism 
> that allows ACPI and raw hardware drivers to coexist, which is made 

Exactly what I said, you're only rewording it to make it sound nicer ;)

> somewhat harder by it not being a situation that the platform designers 
> have considered in the slightest. The suggested low-level driver for 
> io-port arbitration would certainly be a step forward in making this 
> work better.

I sure hope we can find a solution, by as your said yourself, nothing
is going to prevent SMM and similar oddities from messing up the drivers
assumptions.

-- 
Jean Delvare
