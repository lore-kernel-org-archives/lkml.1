Return-Path: <linux-kernel-owner+w=401wt.eu-S1759987AbYGAUYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987AbYGAUYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYGAUXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:23:53 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:19739 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbYGAUXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:23:52 -0400
Message-ID: <23433248.1214943818230.JavaMail.oracle@acsmt302.oracle.com>
Date: Tue, 1 Jul 2008 15:23:38 -0500 (CDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] bug.h: add empty warn_on_slowpath() for CONFIG_BUG=n
Cc: linux-kernel@vger.kernel.org, andi@firstfloor.org
In-Reply-To: <20080701131714.5093fa49.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
References: <20080701103339.b5acc1f3.randy.dunlap@oracle.com> <20080701131714.5093fa49.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Webmail Client(UIX)
Content-Language: en-US
Accept-Language: en-US
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- Original Message ---
> On Tue, 1 Jul 2008 10:33:39 -0700
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
> 
> > From: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Add an empty function for warn_on_slowpath() when CONFIG_BUG=n so that
> > this build error does not happen:
> > 
> > linux-next-20080701/drivers/acpi/utilities/utmisc.c: In function 'acpi_ut_error':
> > linux-next-20080701/drivers/acpi/utilities/utmisc.c:1028: error: implicit declaration of function 'warn_on_slowpath'
> > 
> > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > ---
> >  include/asm-generic/bug.h |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- linux-next-20080701.orig/include/asm-generic/bug.h
> > +++ linux-next-20080701/include/asm-generic/bug.h
> > @@ -81,4 +81,9 @@ extern void warn_on_slowpath(const char 
> >  # define WARN_ON_SMP(x)			do { } while (0)
> >  #endif
> >  
> > +#ifndef __ASSEMBLY__
> > +static inline void warn_on_slowpath(const char *file, const int line)
> > +{ }
> > +#endif
> > +
> >  #endif
> > 
> 
> This looks like a needed-in-mainline fix?  or is there something
> in linux-next which causes the bug?

Looks like only linux-next has this code:

> > linux-next-20080701/drivers/acpi/utilities/utmisc.c: In function 'acpi_ut_error':
> > linux-next-20080701/drivers/acpi/utilities/utmisc.c:1028: error: implicit declaration of function 'warn_on_slowpath'


~Randy

