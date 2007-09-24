Return-Path: <linux-kernel-owner+w=401wt.eu-S1761848AbXIXTJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761848AbXIXTJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 15:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756704AbXIXTJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 15:09:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757044AbXIXTJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 15:09:30 -0400
Date: Mon, 24 Sep 2007 15:09:17 -0400
From: Dave Jones <davej@redhat.com>
To: Jonathan Campbell <jon@nerdgrounds.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Patches for tiny 386 kernels, again. Linux kernel
	2.6.22.7
Message-ID: <20070924190917.GG8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jonathan Campbell <jon@nerdgrounds.com>,
	linux-kernel@vger.kernel.org
References: <46F77A85.6020202@nerdgrounds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F77A85.6020202@nerdgrounds.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2007 at 01:51:17AM -0700, Jonathan Campbell wrote:


 > +#if defined(__i386__) && defined(CONFIG_DMI)
 >  	dmi_check_system(acpi_dmi_table);
 >  #endif
 >  
 > +#ifdef CONFIG_DMI
 >  	dmi_scan_machine();
 > +#endif
 >  
 > +#ifdef CONFIG_DMI
 >  	/* Check and install the TSC clocksource */
 >  	dmi_check_system(bad_tsc_dmi_table);
 > +#endif
 >  
 > +#ifdef CONFIG_DMI
 >  	dmi_check_system(acpi_osl_dmi_table);
 > +#endif
 
Instead of adding all these ifdefs, we could just define
add something along the lines of..

#ifndef CONFIG_DMI
#define dmi_check_system do {} while (0)
#endif

in some header, which hides the uglies away from the code
whilst having the same net effect.

	Dave

-- 
http://www.codemonkey.org.uk
