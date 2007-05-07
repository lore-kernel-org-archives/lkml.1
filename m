Return-Path: <linux-kernel-owner+w=401wt.eu-S933793AbXEGNRb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933793AbXEGNRb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 09:17:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933798AbXEGNRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 09:17:31 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60423 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933793AbXEGNRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 09:17:31 -0400
Date: Mon, 07 May 2007 22:16:49 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] Fix section mismatch of memory hotplug related code.
Cc: Linux Kernel ML <linux-kernel@vger.kernel.org>,
       Miles Lane <miles.lane@gmail.com>
In-Reply-To: <20070506175326.GA9855@uranus.ravnborg.org>
References: <20070504170421.b1ab2d16.akpm@linux-foundation.org> <20070506175326.GA9855@uranus.ravnborg.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070507220846.312B.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, May 04, 2007 at 05:04:21PM -0700, Andrew Morton wrote:
> > On Thu, 05 Apr 2007 17:01:02 +0900
> > Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> > 
> > > Hello.
> > > 
> > > This is to fix many section mismatches of code related to memory hotplug.
> > > I checked compile with memory hotplug on/off on ia64 and x86-64 box.
> > > 
> > > ..
> > >
> > > ===================================================================
> > > --- meminit.orig/drivers/acpi/numa.c	2007-04-04 20:15:58.000000000 +0900
> > > +++ meminit/drivers/acpi/numa.c	2007-04-04 20:56:34.000000000 +0900
> > > @@ -228,7 +228,7 @@ int __init acpi_numa_init(void)
> > >  	return 0;
> > >  }
> > >  
> > > -int acpi_get_pxm(acpi_handle h)
> > > +int __meminit acpi_get_pxm(acpi_handle h)
> > >  {
> > >  	unsigned long pxm;
> > >  	acpi_status status;
> > > @@ -246,7 +246,7 @@ int acpi_get_pxm(acpi_handle h)
> > >  }
> > >  EXPORT_SYMBOL(acpi_get_pxm);
> > >  
> > > -int acpi_get_node(acpi_handle *handle)
> > > +int __meminit acpi_get_node(acpi_handle *handle)
> > >  {
> > >  	int pxm, node = -1;
> > 
> > It doesn't make a lot of sense to export an __init symbol to modules.  I
> > guess it's OK in this case, but we get warnings:

Oops, I might do unnecessary things. :(

> 
> It seems wrong to me to first tell linker to discard the code after init and
> next to export the symbol to make it available for any module anytime.
> 
> Both function are relatively small so better avoid playing games and
> drop the __meminit tag.

It sounds reasonable. I'll do it.

Thanks.


-- 
Yasunori Goto 


