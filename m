Return-Path: <linux-kernel-owner+w=401wt.eu-S1752786AbZBDIeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbZBDIeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 03:34:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751252AbZBDIef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 03:34:35 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57454 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZBDIee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 03:34:34 -0500
Message-ID: <498953DF.5050306@redhat.com>
Date: Wed, 04 Feb 2009 09:37:51 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20090107)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Len Brown <lenb@kernel.org>, Luca Tettamanti <kronos.it@gmail.com>,
       Thomas Renninger <trenn@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, khali@linux-fr.org
Subject: Re: [PATCH] ACPI: add "auto" to acpi_enforce_resources
References: <20090125210520.GA12963@dreamland.darkstar.lan> <200901291130.35434.trenn@suse.de> <68676e00901290716g1aabd6c0p1e5202fbdbc659a4@mail.gmail.com> <alpine.LFD.2.00.0902040042570.9833@localhost.localdomain> <20090204060513.GA28321@srcf.ucam.org>
In-Reply-To: <20090204060513.GA28321@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Matthew Garrett wrote:
> On Wed, Feb 04, 2009 at 12:52:06AM -0500, Len Brown wrote:
> 
>> While it is slightly off-topic of the (I agree, real)
>> technical issue here, note that polling is not "normal" on ACPI systems.
>> [1] was on  SuSE Linux 10.0, which on their own decided to
>> over-ride the kernel and enable thermal zone polling by default.
> 
> Checking the DSDTs I have to hand, it seems that polling is expected on 
> about 5% of systems via an explicit _TZP and on almost all machines via 
> _TSP. Even on systems where thermal notifications are provided, it's 
> still up to the OS to poll the zone to find the current temperature and 
> take appropriate action. There's still a window for native smbus drivers 
> to screw everything up.
> 

Note that this not only applies to smbus devices but also to superio devices, 
in general these superio hwmon devices use 2 isa ports an index and a data one, 
image they mayhem which could happen if for example:
native driver sets index
acpi driver sets index
acpi driver reads data
native driver writes data (to a completely wrong register)

We *really* need to be fixing this.

Len, Matthew, what is you opinion of the proposed auto setting for 
acpi_enforce_resources, which is meant to mean strict on known problematic 
systems and lax on others?

Not I'm not asking what you think of the code (yet) just what you think of the 
principle. If we can atleast all agree on this as a compromise not breaking 
hwmon on quite a few systems (the strict setting) while stile providing 
something safer then the current lax, then I'm sure we can hash out any code 
problems soon enough.

Regards,

Hans
