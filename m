Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZDELpM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZDELpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 07:45:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZDELo4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 07:44:56 -0400
Received: from chili.geekmind.org ([78.46.44.80]:51391 "EHLO
	chili.geekmind.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbZDELoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 07:44:55 -0400
X-Greylist: delayed 501 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Apr 2009 07:44:55 EDT
Message-ID: <49D89884.2000308@chown.ath.cx>
Date: Sun, 05 Apr 2009 13:39:48 +0200
From: Grigori Goronzy <greg@chown.ath.cx>
User-Agent: Thunderbird 2.0.0.18 (X11/20081125)
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: Corentin Chary <corentin.chary@gmail.com>,
       Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       acpi4asus-user@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       cpufreq@vger.kernel.org, Tom Hughes <tom@compton.nu>,
       linux acpi <linux-acpi@vger.kernel.org>,
       Francesco Lattanzio <f.lattanzio@simail.it>
Subject: Re: [Acpi4asus-user] [PATCH 1/1] cpufreq: eeepc 900 frequency scaling
 driver
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu> <200811241613.25557.trenn@suse.de> <200811241736.53067.trenn@suse.de> <1227567739.6421.44.camel@localhost> <71cd59b00904050043u44d1cd2eu4b8d3aee9027ea17@mail.gmail.com> <20090405102057.GA14089@srcf.ucam.org>
In-Reply-To: <20090405102057.GA14089@srcf.ucam.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> I don't think there's a terribly good reason to use the SHE methods if 
> the CPU supports speedstep. 945 will automatically drop the frontside 
> bus in the deepest P states. I'd be surprised if it gave any real world 
> benefits on the atom based systems.
> 

It does make quite a difference, especially because the chipset and CPU
are undervolted in the "powersave" preset. Also, SHE offers a slight
overclock (with the "performance" preset) which cannot be achieved with
mere multiplier switching. This is all guaranteed to be safe by Asus.

On my Eee PC 901, the idle power consumption drops from about 7W to 5.8W
when switching from "normal" to "powersave". That's about 15%. Under
load the benefit seems to be even greater.

I'm the author of a program called eee-control, which currently uses
another method to change FSB and voltage. It directly communicates with
the PLL controller over SMBus and with the embedded controller through
some I/O ports. This method works, but is not very safe and very
hardware specific. The ACPI interface of Asus' SHE abstracts all the
hardware differences away and thus would be preferred.
Anyway, my point is: my experience and reports by users show that the
difference is *huge*.

Regards,
Grigori
