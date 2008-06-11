Return-Path: <linux-kernel-owner+w=401wt.eu-S1759511AbYFKOxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbYFKOxv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 10:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759393AbYFKOxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 10:53:41 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2735 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322AbYFKOxj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 10:53:39 -0400
Date: Wed, 11 Jun 2008 16:53:24 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, lm-sensors@lm-sensors.org, rh1985@wp.pl
Subject: Re: [PATCH] Unhide the SMBus on the Compaq Deskpro EN
Message-ID: <20080611165324.6c080efb@hyperion.delvare>
In-Reply-To: <200806101202.20257.jbarnes@virtuousgeek.org>
References: <20080608134702.401b9fb5.krzysztof.h1@wp.pl>
	<200806101202.20257.jbarnes@virtuousgeek.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse, hi Krzysztof,

On Tue, 10 Jun 2008 12:02:19 -0700, Jesse Barnes wrote:
> On Sunday, June 08, 2008 4:47 am Krzysztof Helt wrote:
> > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> >
> > This patch unhides the SMBus on Compaq Deskpro EN
> > SFF P667 with the Intel 815E chipset. Unhiding it reveals
> > a THMC51 hardware monitoring chip.
> >
> > Jean Delvare has checked that this machine has no ACPI
> > magic touching the SMBus nor the hardware monitoring chip,
> > so this should be safe.

Let it be noted that ACPI is only one of the possible offenders. SMM is
another one. The user reported that his fan speed was changing speeds so
something has to be acting upon temperature changes. This could be the
fan itself, or this could be SMM code changing the registers of the
chip.

At this point of the investigation, I am still not 100% sure that the
patch is safe. I'd say it is only safe if the user's fan is actually
self-regulated based on the temperature.

One easy way to test would be to verify what happens when the
temperature exceeds 53 degrees C (the high temperature limit) and 78
degrees C (the critical temperature limit). Typical SMM code would
change the high and low limits when the high limit is crossed, this
should be clearly visible in the output of "sensors".

BTW, Krzysztof, what about adding (read-only) support for the critical
limits to your thmc50 driver? It would be helpful in a situation like
this.

Another thing to check is whether the value of register 0x19 (analog
output) changes automatically when the fan speeds up.

Until these tests are done, I consider this patch possibly unsafe and
not ready to go to Linus (although probably OK for -next).

> > The patch was tested on Fedora Core 9 with 2.6.25.4 kernel.
> >
> > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
> > Tested-by: Rafał Haładuda <rh1985@wp.pl>
> > CC: Jean Delvare <khali@linux-fr.org>
> 
> Thanks Krzysztof; applied to linux-next.  I had to fix up a conflict by hand 
> though, would be good if you could double check it.
> 
> Thanks,
> Jesse


-- 
Jean Delvare
