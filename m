Return-Path: <linux-kernel-owner+w=401wt.eu-S1759286AbZJGRB4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759286AbZJGRB4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 13:01:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759612AbZJGRBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 13:01:53 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:55439 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114AbZJGRBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 13:01:52 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zz542N1432R98dN936eM9371Pzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KR5LWX-02-BG1-02
X-M-MSG: 
Message-ID: <4ACCC933.1030503@amd.com>
Date: Wed, 7 Oct 2009 13:00:35 -0400
From: "Tippett, Matthew" <matthew.tippett@amd.com>
Organization: AMD
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070618 Thunderbird/2.0.0.4 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Willy Tarreau <w@1wt.eu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Li, Samuel" <Samuel.Li@amd.com>
Subject: Re: [PATCH][ACPI] AC/DC notifier
References: <FFAE0590FF35E441901B67BD8BA62E950245ABD9@storexmb3.amd.com> <20090812005532.GA31003@srcf.ucam.org> <20090814163233.GC1626@ucw.cz> <20090816074008.GA11624@1wt.eu> <4ACB59E2.3000600@amd.com> <20091007073121.GA31245@elf.ucw.cz>
In-Reply-To: <20091007073121.GA31245@elf.ucw.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2009 17:00:35.0923 (UTC) FILETIME=[B05BD230:01CA476F]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending in text-only  sorry for the noise to the individual recipients)

Comments below.

-------- Original Message  --------
Subject: Re: [PATCH][ACPI] AC/DC notifier
From: Pavel Machek <pavel@ucw.cz>
To: Tippett, Matthew <matthew.tippett@amd.com>
Cc: "Willy Tarreau" <w@1wt.eu>, "Matthew Garrett" <mjg59@srcf.ucam.org>, 
"Langsdorf, Mark" <mark.langsdorf@amd.com>, lenb@kernel.org, 
linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, "Li, Samuel" 
<Samuel.Li@amd.com>
Date: 10/07/2009 03:31 AM
>
> On Tue 2009-10-06 10:53:22, Tippett, Matthew wrote:
>
> Please do. So far you did not show valid use for such notifier.
>
> (Ok, I know of one. Old amd64 notebooks had cpufreq scaling enabled,
> with battery unable to supply enough current to feed the CPU at
> highest cpufreq setting. At that point, scaling cpufreq down at unplug
> is correctness issue, and AC/DC notifier in kernel makes
> sense.)
>
> So... what do you want to use it for?
>
We have a general requirement from OEMs and consequently our shared 
Windows/Linux components that the AC/DC state is accurately known.

The concrete examples of use include at least the following.

    1) Automatic frequency scaling has an AC-mode and a DC-mode in 
Powerplay tables in the GPU BIOS ensures that the highest permitted 
clocks fit the system design. This allows at least
        i) system level thermals and power consumption to be managed 
(eg: you shouldn't have the clocks up high if the system fan has been 
asked to slow down). 
        ii) protection of hardware high clocks with a low-current 
battery is a bad idea.
    2) The pixel clock can only drive certain modes with certain engine 
and memory clocks, in DC-mode you will have lower clocks and 
consequently you will need to change the pixel clock and hence the mode 
to something that fits within the budget, otherwise the 3D or display 
engine may not be able to get the bandwidth required to operate effectively.
    3) OEM OS equivalency.  Some OEMs care that Linux has the same 
thermal, power and performance characteristics as other operating 
systems.  This requires that the software act in a similar way and 
reduces OEM/ODM/IHV/OSV validation and deployment costs.

In particular 1 and 2 are very relevant for KMS based drivers.

1 is most likely relevant for other ACPI/SBIOS related hardware 
components that rely on co-operating components doing what is expected 
by the system design.  If a device doesn't change it's behaviour in sync 
with other devices when AC/DC changes, then bad (or at the very least 
annoying) things may happen.  When there is a SBIOS/ACPI/Driver stack in 
place, the driver should honor the system design as well.

3 is only really relevant for the commercial side of things, but is a 
real issue that takes up more engineering effort than the first 2 - my 
cross to bear so to speak.

Regards,

Matthew


