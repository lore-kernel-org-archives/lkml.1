Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbXIYH2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbXIYH2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbXIYH2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:28:03 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:47854 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbXIYH2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:28:01 -0400
Date: Tue, 25 Sep 2007 09:28:00 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Dave Jones <davej@redhat.com>
cc: Jonathan Campbell <jon@nerdgrounds.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel 2.6.22.7
In-Reply-To: <20070924190917.GG8127@redhat.com>
Message-ID: <Pine.LNX.4.64.0709250927301.23305@fbirervta.pbzchgretzou.qr>
References: <46F77A85.6020202@nerdgrounds.com> <20070924190917.GG8127@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 24 2007 15:09, Dave Jones wrote:
>
> > +#if defined(__i386__) && defined(CONFIG_DMI)
> >  	dmi_check_system(acpi_dmi_table);
> >  #endif
> >  
> > +#ifdef CONFIG_DMI
> >  	dmi_scan_machine();
> > +#endif
> >  
> > +#ifdef CONFIG_DMI
> >  	/* Check and install the TSC clocksource */
> >  	dmi_check_system(bad_tsc_dmi_table);
> > +#endif
> >  
> > +#ifdef CONFIG_DMI
> >  	dmi_check_system(acpi_osl_dmi_table);
> > +#endif
> 
>Instead of adding all these ifdefs, we could just define
>add something along the lines of..
>
>#ifndef CONFIG_DMI
>#define dmi_check_system do {} while (0)
>#endif
>
>in some header, which hides the uglies away from the code
>whilst having the same net effect.

Need #define dmi_check_system(x) otherwise you get

	/* Check and install the TSC clocksource */
	do {} while (0) (bad_tsc_dmi_table);
