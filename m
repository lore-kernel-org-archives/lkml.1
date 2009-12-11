Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZLKGZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZLKGZt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 01:25:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756832AbZLKGZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 01:25:48 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:43462 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756812AbZLKGZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 01:25:47 -0500
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_jXNek0F9FVw2rUoFU5VKPQ)"
Date: Fri, 11 Dec 2009 01:25:49 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Robert Hancock <hancockrwd@gmail.com>
Cc: =?ISO-8859-15?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: Useless thermal acpi driver ?
In-reply-to: <4B20483C.6090309@gmail.com>
Message-id: <alpine.LFD.2.00.0912110122570.24891@localhost.localdomain>
References: <20091209232608.25aed4ca@werewolf.home> <4B20483C.6090309@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_jXNek0F9FVw2rUoFU5VKPQ)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Wed, 9 Dec 2009, Robert Hancock wrote:

> On 12/09/2009 04:26 PM, J.A. Magallón wrote:
> > Hi all...
> > 
> > I have a couple boxes where the thermal acpi driver gives this:
> > 
> > bran:~>  sensors
> > acpitz-virtual-0
> > Adapter: Virtual device
> > temp1:       +26.8°C  (crit = +100.0°C)
> > 
> > bran:~>  acpi -t
> > No support for device type: battery
> >       Thermal 1: ok, 27.0 degrees C
> > 
> > It stays _always_ the same, there is no difference if I run some number
> > crunchin, or even if one of them is overclocked from 2.8 to 3.0 GHz.
> 
> There are systems where an ACPI thermal zone exists but isn't really hooked up
> to anything and just reports some dummy temperature value. My old system
> reported 40 degrees C no matter what. (I think it's something like the thermal
> zone support is part of the standard ACPI DSDT template the mobo maker got
> from the BIOS developer and they effectively disabled it by putting in the
> dummy temperature.)

send the output from acpidump, and a quick look will tell us
if your ACPI suport is dummy, or accesses real registers.

Also, show the output from

grep . /proc/acpi/thermal_zone/*/*

cheers,
-Len Brown, Intel Open Source Technology Center

> > They are 1U supermicro boxes, ventilation is good, but I don't trust this
> > measures...
> > It looks like the system is using some kind of 'generic' acpi TZ driver,
> > but as I'm used to good-ol' sensors modules, I don't know where to look.
> > 
> > Previously I used the w83627hf module from sensors.
> 
> I'm assuming the kernel is preventing that module from loading since the ACPI
> DSDT has operation regions that refer to the device registers. There's no
> guarantee that this means the BIOS actually accesses the device, or if it
> does, that there's a way to get it to report what it sees other than to
> itself. If the BIOS doesn't actually access the device then you can use the
> acpi_enforce_resources=lax to allow it. The problem is this might be totally
> unsafe and the kernel has no way to tell if it is or isn't.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

--Boundary_(ID_jXNek0F9FVw2rUoFU5VKPQ)--
