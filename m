Return-Path: <linux-kernel-owner+w=401wt.eu-S1765572AbZDBWqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765572AbZDBWqX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761088AbZDBWqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:46:09 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:63623 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760098AbZDBWqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:46:08 -0400
Date: Thu, 02 Apr 2009 18:45:59 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg@redhat.com>
Cc: Luca Tettamanti <kronos.it@gmail.com>, Thomas Renninger <trenn@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hans de Goede <hdegoede@redhat.com>, khali@linux-fr.org
Subject: polling (Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources)
In-reply-to: <20090204060513.GA28321@srcf.ucam.org>
Message-id: <alpine.LFD.2.00.0904021828110.9182@localhost.localdomain>
References: <20090125210520.GA12963@dreamland.darkstar.lan>
 <200901291130.35434.trenn@suse.de>
 <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com>
 <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain>
 <20090204060513.GA28321@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 4 Feb 2009, Matthew Garrett wrote:

> On Wed, Feb 04, 2009 at 12:52:06AM -0500, Len Brown wrote:
> 
> > While it is slightly off-topic of the (I agree, real)
> > technical issue here, note that polling is not "normal" on ACPI systems.
> > [1] was on  SuSE Linux 10.0, which on their own decided to
> > over-ride the kernel and enable thermal zone polling by default.
> 
> Checking the DSDTs I have to hand, it seems that polling is expected on 
> about 5% of systems via an explicit _TZP and on almost all machines via 
> _TSP. Even on systems where thermal notifications are provided, it's 
> still up to the OS to poll the zone to find the current temperature and 
> take appropriate action. There's still a window for native smbus drivers 
> to screw everything up.

FWIW

In the last 6 years, I've seen exactly 3 systems with a non-zero _TZP.
An old Averatec laptop asked for 1 second, and two recent EEE-PC's ask for 
30 seconds.  Dunno why Asus has made this leap backwards.

_TSP is a different beast.  It only exists in the context of _PSV and 
_PSL.

-Len

ps. I just noticed something in the spec under _PSL...
"If a linear performance control register is not defined(..) for a 
processor defined in _PSL or for a processor device in the zone as 
indicated
by _TZM, then the processor must support processor performance states
(in other words, the processor's processor object must include _PCT, _PSS, 
and _PPC).

Interesting, here is an official tie in of P-states and passive trip 
points that I'd not noticed before....


