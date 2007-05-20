Return-Path: <linux-kernel-owner+w=401wt.eu-S1763633AbXETKak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763633AbXETKak (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 06:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759249AbXETKac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 06:30:32 -0400
Received: from [216.16.235.2] ([216.16.235.2]:34778 "EHLO rubicon.netdirect.ca"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755865AbXETKab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 06:30:31 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 20 May 2007 06:28:17 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: David Rientjes <rientjes@google.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] Extract common MODULE_INFO content into new moduleinfo.h.
In-Reply-To: <alpine.DEB.0.99.0705200142080.25601@chino.kir.corp.google.com>
Message-ID: <Pine.LNX.4.64.0705200627220.6765@localhost.localdomain>
References: <Pine.LNX.4.64.0705200354380.3319@localhost.localdomain>
 <alpine.DEB.0.99.0705200142080.25601@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 May 2007, David Rientjes wrote:

> On Sun, 20 May 2007, Robert P. J. Day wrote:
>
> > diff --git a/include/linux/moduleinfo.h b/include/linux/moduleinfo.h
> > new file mode 100644
> > index 0000000..cee86a9
> > --- /dev/null
> > +++ b/include/linux/moduleinfo.h
> > @@ -0,0 +1,18 @@
> > +#ifndef _LINUX_MODULEINFO_H
> > +#define _LINUX_MODULEINFO_H
> > +
> > +#ifdef MODULE
> > +#include <linux/stringify.h>
> > +#define ___module_cat(a,b) __mod_ ## a ## b
> > +#define __module_cat(a,b) ___module_cat(a,b)
> > +#define __MODULE_INFO(tag, name, info)				\
> > +static const char __module_cat(name,__LINE__)[]			\
> > +  __attribute_used__						\
> > +  __attribute__((section(".modinfo"),unused)) = __stringify(tag) "=" info
>
> This isn't a function definition so __attribute_used__ (which is
> deprecated anyway) doesn't mean anything.  Please simply use
> __maybe_unused and remove "unused" from the second attribute.

i can do that as long as there's no way that those changes can (even
theoretically) make a difference in the build.  in order to make sure
this patch didn't break anything, i went with a straight cut-and-paste
of the content to go into the new moduleinfo.h.

so while i agree that those changes shouldn't hurt, personally, i'd
prefer to just put this patch through as is and come back later to do
any tidying related to attribute rewording.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
