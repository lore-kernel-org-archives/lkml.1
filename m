Return-Path: <linux-kernel-owner+w=401wt.eu-S1030672AbXEORmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030672AbXEORmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 13:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbXEORmQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 13:42:16 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:17437 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756691AbXEORmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 13:42:14 -0400
Date: Tue, 15 May 2007 10:46:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Mattia Dongili <malattia@linux.it>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: Fwd: Re: Linux 2.6.22-rc1
Message-Id: <20070515104621.a4e0e609.randy.dunlap@oracle.com>
In-Reply-To: <20070515154208.GJ5043@inferi.kami.home>
References: <Pine.LNX.4.61.0705131123280.9570@yvahk01.tjqt.qr>
	<20070514015541.GB4800@inferi.kami.home>
	<Pine.LNX.4.61.0705140742350.9570@yvahk01.tjqt.qr>
	<20070514104546.10a4368f.randy.dunlap@oracle.com>
	<20070515154208.GJ5043@inferi.kami.home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 00:42:08 +0900 Mattia Dongili wrote:

> On Mon, May 14, 2007 at 10:45:46AM -0700, Randy Dunlap wrote:
> > On Mon, 14 May 2007 07:49:31 +0200 (MEST) Jan Engelhardt wrote:
> > 
> > > 
> > > On May 14 2007 10:55, Mattia Dongili wrote:
> > > >On Sun, May 13, 2007 at 11:27:31AM +0200, Jan Engelhardt wrote:
> > > >> On May 12 2007 20:20, Linus Torvalds wrote:
> > > >> >
> > > >> >Ok, the merge window has closed, and 2.6.22-rc1 is out there.
> > > >> 
> > > >> I have hit a randconfig compile failure. .config attached.
> > > >> 
> > > >>   LD      .tmp_vmlinux1
> > > >> drivers/built-in.o: In function `acpi_bus_generate_event':
> > > >> (.text+0x233f7): undefined reference to `event_is_open'
> > > >> drivers/built-in.o: In function `acpi_bus_get_power':
> > > >> (.text+0x236ad): undefined reference to `acpi_power_get_inferred_state'
> > > >> drivers/built-in.o: In function `acpi_bus_set_power':
> > > >> (.text+0x237c3): undefined reference to `acpi_power_transition'
> > > >> drivers/built-in.o: In function `acpi_bus_set_power':
> > > >> (.text+0x23835): undefined reference to `acpi_power_transition'
> > > >> drivers/built-in.o: In function `sony_pic_fanspeed_store':
> > > >> sony-laptop.c:(.text+0x91930): undefined reference to `ec_write'
> > > >> drivers/built-in.o: In function `sony_pic_fanspeed_show':
> > > >> sony-laptop.c:(.text+0x9195d): undefined reference to `ec_read'
> > > >> make: *** [.tmp_vmlinux1] Error 1
> > > >
> > > >I actually can't reproduce it with your .config.
> > > 
> > > But I can. Did you try it on x86_64? From 2.6.22-rc1 [
> > > commit 39403865d2e4590802553370a56c9ab93131e4ee in /linux-2.6.git] ?
> > > 
> > > 	bzip2 -cd randconfig-1.bz2 >.config
> > > 	make -j8
> > 
> > Yes, build easily fails for me also.
> 
> ok, as far as sony-laptop is concerned a dependency on ACPI_EC suffices
> to fix the link failure, but I guess that would just hide the real
> issue.
> IOW: why does ACPI_EC, ACPI_SYSTEM and ACPI_POWER are not set when the
> ACPI symbol is?
> 
> Given the drivers/acpi/Kconfig portion
> 
>   if ACPI
>   ...
>   config ACPI_EC
>           bool
>           default y
>           help
>             ...
>   
>   config ACPI_POWER
>           bool
>           default y
>   
>   config ACPI_SYSTEM
>           bool
>           default y
>           help
> 	  ...
>   ...
>   endif
> 
> I'd expect the 3 symbols to be all set when CONFIG_ACPI=y.
> What am I overseeing?

I think that this is just 'make randconfig' throwing a curve ball.
ACPI depends on PM, but PM=n.  In my experience, randconfig is a
good tool for testing oddball configs, but the results are not
always something that is fixable or needs to be fixed.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
