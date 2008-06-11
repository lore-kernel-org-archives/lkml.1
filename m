Return-Path: <linux-kernel-owner+w=401wt.eu-S1763045AbYFKQQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763045AbYFKQQz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 12:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYFKQQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 12:16:49 -0400
Received: from outbound-mail-37.bluehost.com ([69.89.20.191]:45032 "HELO
	outbound-mail-37.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751137AbYFKQQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 12:16:48 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] Unhide the SMBus on the Compaq Deskpro EN
Date: Wed, 11 Jun 2008 09:16:38 -0700
User-Agent: KMail/1.9.9
Cc: Krzysztof Helt <krzysztof.h1@wp.pl>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, lm-sensors@lm-sensors.org, rh1985@wp.pl
References: <20080608134702.401b9fb5.krzysztof.h1@wp.pl> <200806101202.20257.jbarnes@virtuousgeek.org> <20080611165324.6c080efb@hyperion.delvare>
In-Reply-To: <20080611165324.6c080efb@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806110916.38694.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 11, 2008 7:53 am Jean Delvare wrote:
> Hi Jesse, hi Krzysztof,
>
> On Tue, 10 Jun 2008 12:02:19 -0700, Jesse Barnes wrote:
> > On Sunday, June 08, 2008 4:47 am Krzysztof Helt wrote:
> > > From: Krzysztof Helt <krzysztof.h1@wp.pl>
> > >
> > > This patch unhides the SMBus on Compaq Deskpro EN
> > > SFF P667 with the Intel 815E chipset. Unhiding it reveals
> > > a THMC51 hardware monitoring chip.
> > >
> > > Jean Delvare has checked that this machine has no ACPI
> > > magic touching the SMBus nor the hardware monitoring chip,
> > > so this should be safe.
>
> Let it be noted that ACPI is only one of the possible offenders. SMM is
> another one. The user reported that his fan speed was changing speeds so
> something has to be acting upon temperature changes. This could be the
> fan itself, or this could be SMM code changing the registers of the
> chip.
>
> At this point of the investigation, I am still not 100% sure that the
> patch is safe. I'd say it is only safe if the user's fan is actually
> self-regulated based on the temperature.
>
> One easy way to test would be to verify what happens when the
> temperature exceeds 53 degrees C (the high temperature limit) and 78
> degrees C (the critical temperature limit). Typical SMM code would
> change the high and low limits when the high limit is crossed, this
> should be clearly visible in the output of "sensors".
>
> BTW, Krzysztof, what about adding (read-only) support for the critical
> limits to your thmc50 driver? It would be helpful in a situation like
> this.
>
> Another thing to check is whether the value of register 0x19 (analog
> output) changes automatically when the fan speeds up.
>
> Until these tests are done, I consider this patch possibly unsafe and
> not ready to go to Linus (although probably OK for -next).

Ok, thanks for the heads up Jean, I'll keep this one out of the queue I send 
to Linus until we get confirmation about its safety.

Thanks,
Jesse
