Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbYE1AE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbYE1AE3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 20:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbYE1AEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 20:04:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49606 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680AbYE1AET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 20:04:19 -0400
Date: Wed, 28 May 2008 09:09:37 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Taku Izumi <izumi.taku@jp.fujitsu.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ACPI: add DMI info to enable OSI(Linux) on
 PRIMEQUEST
Message-Id: <20080528090937.af2ad164.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080527162029.e549a226.akpm@linux-foundation.org>
References: <4816F9B9.3090609@jp.fujitsu.com>
	<4836660B.3080406@jp.fujitsu.com>
	<483667A4.9000606@jp.fujitsu.com>
	<20080527162029.e549a226.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 May 2008 16:20:29 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 23 May 2008 15:43:48 +0900
> Taku Izumi <izumi.taku@jp.fujitsu.com> wrote:
> 
> > This patch adds DMI info to enable OSI(Linux) on PRIMEQUEST.
> > (PRIMEQUEST is ia64 machine.)
> > 
> > Signed-off-by: Taku Izumi <izumi.taku@jp.fujitsu.com>
> > 
> > ---
> >   drivers/acpi/blacklist.c |   14 ++++++++++++++
> >   1 file changed, 14 insertions(+)
> > 
> > Index: linux-2.6.25.4/drivers/acpi/blacklist.c
> > ===================================================================
> > --- linux-2.6.25.4.orig/drivers/acpi/blacklist.c
> > +++ linux-2.6.25.4/drivers/acpi/blacklist.c
> > @@ -626,6 +626,20 @@ static struct dmi_system_id acpi_osi_dmi
> >   		     DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> >   		},
> >   	},
> > +	/*
> > +	 * Enable OSI(Linux) on Fujitsu PRIMEQUEST
> > +	 *
> > +	 * DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
> > +	 *
> > +	 */
> > +	{
> > +	.callback = dmi_enable_osi_linux,
> > +	.ident = "Fujitsu PRIMEQUEST",
> > +	.matches = {
> > +		     DMI_MATCH(DMI_BIOS_VENDOR, "FUJITSU LIMITED"),
> > +		     DMI_MATCH(DMI_BIOS_VERSION, "PRIMEQUEST"),
> > +		},
> > +	},
> >   	{}
> >   };
> 
> It is unclear (to me) what the impact of this patch is.  Does it fix a
> problem which would justify including these patches in 2.6.26?
> 
Ah, sorry. I think this is not 2.6.26 candidates.

  Before patch.
    - PrimeQuest doesn't work well without acpi_osi="Linux" boot option.
  After patch
    - PrimeQuest works well without boot option.

But Pavel Machek and Arjan van de Ven informed us that "Supporting OSI("Linux")
on PrimeQuest will be harmful even if it works well now. Because we cannot
guarantee compatibility of this interface in future". So, we're now discussing
the problem with our firmware team.

So, please ignore this patch for a while. We'll repost if necessary.

Thank you.

Regards.
-Kame

