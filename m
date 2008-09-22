Return-Path: <linux-kernel-owner+w=401wt.eu-S1754500AbYIVXBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500AbYIVXBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 19:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbYIVXBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 19:01:16 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:14824 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbYIVXBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 19:01:16 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Martin Doucha <next_ghost@quick.cz>
Subject: Re: [Bug 11603] Re: ACPI PnP on Intel MU440EX
Date: Mon, 22 Sep 2008 17:01:13 -0600
User-Agent: KMail/1.9.9
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       matthieu castet <castet.matthieu@free.fr>,
       bugme-daemon@bugzilla.kernel.org
References: <48BA9B2C.7060007@quick.cz> <200809162339.40330.bjorn.helgaas@hp.com> <200809201659.19268.bjorn.helgaas@hp.com>
In-Reply-To: <200809201659.19268.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809221701.13569.bjorn.helgaas@hp.com>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Your logs are perfect, which makes me happy because it's the first
time I've successfully used the byzantine ACPI debug infrastructure.

> Log with parport set to auto/bidirectional in BIOS for comparison. PNPBIOS does
> detect it in this setting, ACPI doesn't. Same with auto/EPP which I used until
> now.

I think this is a BIOS defect.

When you set the port to "enabled" in the BIOS, Linux finds and uses
the parallel port with no problem.

When you set the port to "auto/bidirectional" or "auto/EPP" in the BIOS,
the _STA methods on all the parallel devices return 0:

     bus-0117 [00] bus_get_status        : Device [LPT] status [00000000]
     bus-0117 [00] bus_get_status        : Device [EPP] status [00000000]
     bus-0117 [00] bus_get_status        : Device [ECP] status [00000000]

A zero _STA means the device is not present at all, so I think Linux
is right to ignore the devices.

I suppose we could try to add a quirk to Linux to work around this,
but I'm not sure whether it's worth it.  Your machine is from 1998,
and some distros blacklist ACPI on old machines because it's not
worth the trouble to fix all of them.

Some drivers will blindly probe for hardware if PNP doesn't report
anything.  Is parport one of them, i.e., if you load it by hand, does
it work?
