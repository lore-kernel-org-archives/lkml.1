Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXHAPze@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXHAPze (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:55:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753186AbXHAPzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:55:16 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:39565 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975AbXHAPzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:55:13 -0400
Date: Wed, 1 Aug 2007 18:55:10 +0300
From: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>,
       Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       len.brown@intel.com, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
       linux-pm@linux-foundation.org, ibm-acpi-devel@lists.sourceforge.net
Subject: Re: 2.6.21-rc1: T60 ACPI issues
Message-ID: <20070801155510.GA11758@mellanox.co.il>
Reply-To: "Michael S. Tsirkin" <mst@dev.mellanox.co.il>
References: <20070801135820.GA8266@mellanox.co.il>
	<Pine.LNX.4.64.0708011516540.15447@blonde.wat.veritas.com>
	<20070801145607.GB8480@mellanox.co.il>
	<20070801154749.GK23111@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070801154749.GK23111@khazad-dum.debian.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Quoting Henrique de Moraes Holschuh <hmh@hmh.eng.br>:
> Subject: Re: 2.6.21-rc1: T60 ACPI issues
> 
> (CC changed from Borislav to ibm-acpi-devel).
> 
> On Wed, 01 Aug 2007, Michael S. Tsirkin wrote:
> > > > 2. Pressing Fn/F4 does not trigger suspend to ram
> > > >    This normally triigers ACPI event which triggers suspend to RAM on Ubuntu
> > > >    (echo mem > /sys/power/state works)
> > > 
> > > I'll bet this is your CONFIG_THINKPAD_ACPI_INPUT_ENABLED=y.
> > > I got the same, see my "THINKPAD_ACPI_INPUT_ENABLED seems regressive"
> > > mail to Henrique and lkml an hour ago.
> 
> [...]
> 
> > > > 3. After suspend to RAM, system wakes up but laptop's screen is blank,
> > > >    switching VTs etc does not help.
> > > >    External screen wakes up OK though.
> > > >    dmesg output from boot attached.
> > > 
> > > (I've not had that.)
> > 
> > Bingo.
> > sudo rmmod thinkpad_acpi cures both 2 and 3.
> > Thanks for pointing this out.
> 
> I can see how it would help with (2), as that prompty tells the firmware to
> issue its default ACPI events for Fn+F4 upon removal.  But I have *NO* idea
> what thinkpad_acpi might be doing that is causing issues with the wake up
> after a resume.

My guess is that upon resume, I normally get some other acpi event
which gets blocked with CONFIG_THINKPAD_ACPI_INPUT_ENABLED.

> Please open a bug in bugzilla.kernel.org about it, and attach the full debug
> output of a suspend+resume cycle with and without thinkpad-acpi loaded.
> 
> Also, please try the same with thinkpad-acpi loaded, but
> CONFIG_THINKPAD_ACPI_INPUT_ENABLED set to N.  If the problem goes away,
> please retest, but set hotkey_enable to 1 and do an "cat
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_recommended_mask >
> /sys/bus/platform/devices/thinkpad_acpi/hotkey_mask" before the sleep.

what's hotkey_enable?

> You will probably need to enable a bunch of debug options in ACPI and
> thinkpad-acpi to get good enough logs.  It is probably worth posting the
> acpid logs too: the real difference might be there.

-- 
MST
