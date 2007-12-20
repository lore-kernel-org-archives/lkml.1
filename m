Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbXLTAUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbXLTAUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 19:20:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753842AbXLTAU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 19:20:29 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:38778 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbXLTAU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 19:20:27 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
Date: Wed, 19 Dec 2007 17:20:21 -0700
User-Agent: KMail/1.9.6
Cc: Shaohua Li <shaohua.li@intel.com>, Mike Houston <mikeserv@bmts.com>,
       Adrian Bunk <bunk@stusta.de>, Elvis Pranskevichus <el@prans.net>,
       mhoffman@lightlink.com, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org, Adam Belay <ambx1@neo.rr.com>,
       Zhao Yakui <yakui.zhao@intel.com>, Thomas Renninger <trenn@suse.de>,
       lenb@kernel.org, linux-acpi@vger.kernel.org,
       Carlos Corbacho <carlos@strangeworlds.co.uk>
References: <20071204215154.7f26285e.mikeserv@bmts.com> <200712171014.44360.bjorn.helgaas@hp.com> <20071218185918.5d2d4c7d@hyperion.delvare>
In-Reply-To: <20071218185918.5d2d4c7d@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712191720.23026.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2007 10:59:18 am Jean Delvare wrote:
> The real cause is pretty clear here: broken BIOS. In an ideal world we
> would ask the manufacturer for a fixed BIOS and they would give that to
> us, unfortunately my experience is that it won't happen. So, unless we
> accept that idea that some users won't be able to use some of their
> devices because of broken resource enumeration in their BIOS, we will
> have to find a workaround, whatever it is.

I suspect the manufacturers would say "Oh, the sensors?  The BIOS
isn't broken, you're just supposed to use WMI or some (undocumented)
ACPI device to get at those."

I know next to nothing about WMI, and there are probably IP issues
in that area.  But I'd rather spend effort in figuring out the "right"
way to do this.  Until we do it the same way as Windows, we can pile
on hacks till the cows come home, and we'll still have issues.

I added Carlos to the cc: list because he's been doing a lot of
interesting-looking work on WMI.

> My initial idea was to identify the faulty motherboard using DMI and to
> force pnpacpi=off on the faulty motherboards. If this is considered too
> aggressive, maybe we can just reject resource declarations that
> intersect (but don't match) 0x290-0x297 for these motherboards. Either
> way, we have to do something, and we have to do it quickly. 2.6.24
> final isn't too far away, and more importantly, the patch that revealed
> the problem has been backported to 2.6.23.10 so people are experiencing
> regressions already.

Windows apparently doesn't reject those resource declarations, so I'm
a bit hesitant to do it in Linux.  That tends to cover up problems,
and then it becomes very difficult to remove the band-aid and figure
out a correct fix in the future.

Bjorn
