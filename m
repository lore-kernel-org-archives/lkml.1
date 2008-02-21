Return-Path: <linux-kernel-owner+w=401wt.eu-S935328AbYBUWWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935328AbYBUWWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbYBUWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:22:37 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:41955 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754614AbYBUWWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:22:36 -0500
Date: Thu, 21 Feb 2008 23:22:45 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Nish Aravamudan <nish.aravamudan@gmail.com>
Cc: Len Brown <lenb@kernel.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [BUILD_FAILURE] 2.6.25-rc2-mm1 - Build Failure at acpi_os
Message-ID: <20080221222245.GB30976@uranus.ravnborg.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <47B73DD8.4030405@linux.vnet.ibm.com> <200802210208.47487.lenb@kernel.org> <29495f1d0802211054s26665d3cy1609d3347867cb16@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29495f1d0802211054s26665d3cy1609d3347867cb16@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 10:54:40AM -0800, Nish Aravamudan wrote:
> On 2/20/08, Len Brown <lenb@kernel.org> wrote:
> > On Saturday 16 February 2008 14:47, Kamalesh Babulal wrote:
> >  > Hi Andrew,
> >  >
> >  > The 2.6.25-rc2-mm1 kernel with randconfig build option, fails
> >  > to build on x86_64 machine
> >  >
> >  >   CC      drivers/acpi/osl.o
> >  > drivers/acpi/osl.c:60:38: error: empty filename in #include
> >  > drivers/acpi/osl.c: In function 'acpi_os_table_override':
> >  > drivers/acpi/osl.c:399: error: 'AmlCode' undeclared (first use in this function)
> >  > drivers/acpi/osl.c:399: error: (Each undeclared identifier is reported only once
> >  > drivers/acpi/osl.c:399: error: for each function it appears in.)
> >  > make[2]: *** [drivers/acpi/osl.o] Error 1
> >  > make[1]: *** [drivers/acpi] Error 2
> >  > make: *** [drivers] Error 2
> >  >
> >  > #
> >  > # Automatically generated make config: don't edit
> >  > # Linux kernel version: 2.6.25-rc2-mm1
> >  > # Sun Feb 17 08:07:17 2008
> >  > #
> >
> >
> > > CONFIG_ACPI_CUSTOM_DSDT=y
> >  > CONFIG_ACPI_CUSTOM_DSDT_FILE=""
> >
> >
> > garbage in, garbage out.
> 
> garbage explicitly *allowed* by Kconfig in this case, though.
> 
> >  If you don't give this build option a file name where AmlCode lives,
> >  then the build will be unable to find AmlCode[].
> >
> >  http://www.lesswatts.org/projects/acpi/overridingDSDT.php
> 
> So we have a .config option whose sole purpose is to use another
> .config option? That seems ... less than ideal. Is there not some
> Kconfig voodoo we can do to only require the one option? Maybe
> something like how CONFIG_INITRAMFS_SOURCE is done? Adding Sam to the
> Cc, in case he has any ideas.

Make sure STANDALONE is y for your randconfig builds.
See README for examples.

STANALONE is there exactly to prevent the above but we cannot
control randconfig.

	Sam

