Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYFZIPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYFZIPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 04:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbYFZIOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 04:14:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:51931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbYFZIOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 04:14:49 -0400
Date: Thu, 26 Jun 2008 10:15:26 +0200
From: Bernhard Walle <bwalle@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
       yhlu.kernel@gmail.com
Subject: Re: [PATCH 1/2] Add /sys/firmware/memmap
Message-ID: <20080626101526.780af0c0@halley.suse.de>
In-Reply-To: <20080625224301.GE32344@redhat.com>
References: <1214423826-12628-1-git-send-email-bwalle@suse.de>
	<1214423826-12628-2-git-send-email-bwalle@suse.de>
	<20080625224301.GE32344@redhat.com>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
X-Face: ,G!z)dEOMkc[Cu+sF64,T9^5r3b>/}#HBRL%D^j@\SZbr'Itl7q@1<*dgB?A7(_leO1Tc4^
 D*WfvfwKcz;,@E^y+pNP%86n8o<&g-vToCXW:r>Y$jxY,`KT?{H!07=2|Jdt?0ba^C-Tnx50vIV8It
 vi&Sicl:sj`k2`y)E;ECFi;i7W-?t3%\kD*));q)+%-pQd^.r'W}oBBx=+.~Gu}&F;lS7.a-m>Rv"w
 pe`D'OV^?HJd$-)7<2T[naDPl6+bAj'+UYd]u]B^'.LYK$2jS
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Vivek Goyal [2008-06-25 18:43]:
>
> Thanks for the patch. Couple of thoughts.
> 
> Do we really need another CONFIG option (CONFIG_FIRMWARE_MEMMAP)? To,
> me this does not seem to be a big chunk of code at the same time I am
> assuming that most of the people will use it (because of kexec). So
> probably, it might not make lot of sense to put additional CONFIG option.

Agreed.

> [..]
> > +#include <linux/string.h>
> > +#include <linux/firmware-map.h>
> > +#include <linux/kernel.h>
> > +#include <linux/module.h>
> > +#include <linux/types.h>
> > +#include <linux/bootmem.h>
> > +
> > +/*
> > + * String representation of enum firmware_map_type from
> > + * <linux/firmware-map.h>.
> > + */
> > +const char *type_to_string_map[] = {
> > +	"RAM",				/* MAP_RAM */
> > +	"Reserved",			/* MAP_RESERVED */
> > +	"ACPI Tables",			/* MAP_ACPI */
> > +	"Non-volatile Storage",		/* MAP_NVS */
> > +};
> > +
> 
> How about leaving the decision of memory type on arch dependent code? How
> about letting arch code pass you an string while adding entry and that
> string will contain the type of memory. The way request_resource() is
> implemented. 

Also agreed, see the resent patch.


Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
