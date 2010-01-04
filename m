Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005Ab0ADWEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0ADWEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 17:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753682Ab0ADWEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 17:04:10 -0500
Received: from vms173017pub.verizon.net ([206.46.173.17]:58554 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0ADWDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 17:03:54 -0500
Date: Mon, 04 Jan 2010 17:03:34 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christian Hofstaedtler <ch@zeha.at>, x86@kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bruce.w.allan@intel.com, Thomas Gleixner <tglx@linutronix.de>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-acpi@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH] Add DMI quirk for Intel DP55KG mainboard
In-reply-to: <4B4225B3.8070705@zytor.com>
Message-id: <alpine.LFD.2.00.1001041632330.4012@localhost.localdomain>
References: <20100104162114.GA30113@percival.namespace.at>
 <alpine.LFD.2.00.1001041209300.4012@localhost.localdomain>
 <4B4225B3.8070705@zytor.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I believe that Venki is sending a patch to make all recent
> > motherboards use acpi reset by default; and I'd rather
> > see that kind of patch than this one.
> > 
> > I've had the patch below patch in acpi-test, and thus linus-next,
> > and -mm since Nov 2008 to change the default for
> > all systems w/ no issues.
> > 
> 
> Maybe I'm misremembering, but didn't we have to pull this patch after it
> hit mainstream the last time?


c7ffa6c26277b403920e2255d10df849bd613380
"x86: default to reboot via ACPI"

set ACPI as the default in 2.6.28-rc1

8d00450d296dedec9ada38d43b83e79cca6fd5a3
Revert "x86: default to reboot via ACPI"

pulled it in v2.6.28-rc4

The original patch was justified by VMX support,
and the revert was in response to Andrey Borzenkov's
DMI patch to usee BIOS reset on his Toshiba Porgege 4000:

http://lkml.org/lkml/2008/10/31/242

The Toshiba Portege 4000 shipped in early 2002.

The patch to restore ACPI reset to default has been in Linux-next
(with occasional drops) since the day it was dropped from 2.6.28-rc4.

As we have an existence proof, I have no doubt that using
ACPI reset by default will un-earth some regressions.  However,
my guess is that the DMI list of old machines that will fail
with ACPI reset will be smaller than by the DMI list of
brand-new machines that will fail without ACPI reset.

We couuld use a DMI year cut-off as we do with
ACPI itself CONFIG_ACPI_BLACKLIST_YEAR, though that
doesn't work on systems that don't have DMI...
If I were to propose a year, I'd say 2006 and newer,
since XP was "Windows 2006".

thanks,
Len Brown, Intel Open Source Technology Center
