Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbYAFXs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbYAFXs3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 18:48:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYAFXsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 18:48:22 -0500
Received: from hpsmtp-eml18.kpnxchange.com ([213.75.38.118]:33838 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754667AbYAFXsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 18:48:21 -0500
From: Frans Pop <elendil@planet.nl>
To: linux-kernel@vger.kernel.org
Subject: Re: pnpacpi: exceeded the max number of IO resources: 24
Date: Mon, 7 Jan 2008 00:48:19 +0100
User-Agent: KMail/1.9.7
Cc: Zhao Yakui <yakui.zhao@intel.com>
References: <200712240612.46786.elendil@planet.nl> <1198803416.21142.7.camel@yakui_zhao.sh.intel.com>
In-Reply-To: <1198803416.21142.7.camel@yakui_zhao.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801070048.19468.elendil@planet.nl>
X-OriginalArrivalTime: 06 Jan 2008 23:48:19.0870 (UTC) FILETIME=[9DA1E3E0:01C850BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding the kernel list back. Any reason you did not send the reply there?)

Sorry for the late reply: Christmas, New Year, the flue, etc.

On Friday 28 December 2007, Zhao Yakui wrote:
> On Mon, 2007-12-24 at 06:12 +0100, Frans Pop wrote:
> > During boot with v2.6.24-rc6-125-g5356f66 on my Toshiba Satellite A40
> > laptop, I suddenly get the following message (repeated 22 times!):
> >    pnpacpi: exceeded the max number of IO resources: 24
> >
> > Last time I tested 2.6.24 on that box was after the initial merge, but
> > before -rc1. Then those lines were not present.
> >
> > Looks like the messages originate from a7839e96 by Zhao Yakui and that
> > patch just adds the kernel messages so it was probably a hidden issue
> > before, but I cannot determine if I should be worried or not.
>
> Thanks for caring this problem.

And thank you for the reply, although I must admit that I'm still confused.

> In the patch of a7839e96 the predefined PNP constant is changed. For
> example: IO is changed from 8 to 24, Mem is changed from 4 to 12.
> That means that more resources will be obtained from the PNP device
> defined in ACPI table. So the system will print more message.

OK. The change for Mem from 4 to 12 could explain the extra "iomem range" 
messages (although I don't quite understand why resources that "could not 
be reserved" still use a slot).
I do not yet see how the "ioport range" messages increased from 0 to 16 is 
explained, but I'm not too worried about that.

> At the same time another problem maybe happens. If the number of
> resources defined in BIOS still exceeds the predefined PNP constant, it
> will report that pnpacpi: exceeded the max number of IO resources: 24.
> Although it can be fixed by changed the pnp constant bigger, it is
> inappropriate because it will waste a lot of memory in most cases.
>
> Of course the above error message is harmless.

Are the _errors_ really harmless?

Your commit message was:
"It brings that some resources can't be reserved and resource confilicts.  
This will cause PCI resources are assigned wrongly in some systems, and 
cause hang. This is a regression since we deleted ACPI motherboard driver 
and use PNP system driver."

That text seems to indicate that not reserving the remaining resources _can_ 
cause real problems. Do we know what PCI resources are now not being 
correctly reserved on my laptop (and other machines)? The fact that the 
message is repeated 22 times seems to indicate that in my case quite a lot 
of resources are being ignored.

Should the memory allocation maybe be made dynamic instead of static if the 
memory waste is really such a problem? Apparently the number of PCI 
resources can vary wildly from one machine to another.

If the error messages really are harmless, shouldn't they be changed from 
ERR to DEBUG? As it is, the messages are extremely ugly and will probably 
cause a lot of people to file bug reports as it _looks_ like there is an 
error.

Cheers,
Frans Pop
