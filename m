Return-Path: <linux-kernel-owner+w=401wt.eu-S1754176Ab0AINoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0AINoQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 08:44:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484Ab0AINoQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 08:44:16 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:54533 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750917Ab0AINoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 08:44:15 -0500
X-Sasl-enc: NFwVZAirJuSD6BjYTz08bAffYw2We6og0SHxmdDoEF7G 1263044652
Date: Sat, 9 Jan 2010 11:44:09 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, ibm-acpi@hmh.eng.br,
       len.brown@intel.com, ibm-acpi-devel@lists.sourceforge.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ibm-acpi-devel] 2.6.33-rc2: regression: gkrellm no longer
 shows all the temperatures on thinkpad x60
Message-ID: <20100109134409.GA936@khazad-dum.debian.net>
References: <20091227215722.GN11737@elf.ucw.cz>
 <20091228130138.GA19362@khazad-dum.debian.net>
 <20100107214904.GB25538@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100107214904.GB25538@elf.ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Jan 2010, Pavel Machek wrote:
> > Please apply the latest stack of patches (sent them to acpi-test
> > yesterday).
> > 
> > It is failing to register the ALSA mixer for some reason, and due
> > to a bug, it is not loading the module at all.  I will look at the reason it
> > is failing to register the ALSA mixer soon.  Meanwhile, the patches I sent
> > to Len make sure the module can still load sucessfully.
> 
> Well, I'm not sure its completely fixed. I got this in my syslog:
> 
> thinkpad_acpi: THERMAL EMERGENCY: a sensor reports something is
> extremely hot!
> thinkpad_acpi: temperatures (Celsius): 95 47 N/A 89 47 N/A 41 N/A 51
> 61 N/A N/A N/A N/A N/A N/A

And the extremely hot sensor is that 89°C, which is the GPU I think (varies
from thinkpad to thinkpad).  That is not normal, and I'd say it needs
repair, probably a badly seated heatsink or failed thermal interface
compound.

> ...meaning thinkpad_acpi is active and working, but still gkrellm does
> not report temperatures as it used to.

Well, gkrellm has always been a hack, it may be objecting to the third N/A
there (which reads as -128 through /proc, and results in ENXIO on hwmon
sysfs).

> root@amd:~# cat /proc/acpi/ibm/thermal 
> temperatures:	74 48 -128 75 47 -128 41 -128 51 58 -128 -128 -128
> -128 -128 -128
> root@amd:~# 

The driver is operating normally (which doesn't surprise me, I didn't touch
that code for quite a while, other than adding the temperature dump so that
we could track what was cooking in your thinkpad :) ).

> ...is there, so I'm not sure why gkrellm stopped working.

I'd take a look on the gkrellm side of things.  Maybe I am doing something
it doesn't like in the hwmon interface, etc.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
