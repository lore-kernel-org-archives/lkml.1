Return-Path: <linux-kernel-owner+w=401wt.eu-S1756089AbYHPDsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089AbYHPDsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 23:48:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbYHPDsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 23:48:25 -0400
Received: from mga07.intel.com ([143.182.124.22]:56213 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752590AbYHPDsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 23:48:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,220,1217833200"; 
   d="scan'208";a="34300262"
Message-ID: <48A64E0A.8090408@linux.intel.com>
Date: Sat, 16 Aug 2008 05:48:26 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>	 <20080814083828.d10e126d.randy.dunlap@oracle.com>	 <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>	 <20080815085836.67e420f1.randy.dunlap@oracle.com>	 <1218854219.3629.30.camel@lgn.site>  <48A64235.2030108@linux.intel.com> <1218856798.3629.45.camel@lgn.site>
In-Reply-To: <1218856798.3629.45.camel@lgn.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> They have been module options, not prefixed kernel parameters so far,
> and the prefix was just the module name.
> So it just strikes back, that acpi uses generic names for the modules,
> there would have been no problem if "power" would be called "acpi_power"
> and the options would just be ﻿"acpi.acpica_version" and
> "acpi_power.nocheck".
> 
> But well, there are driver modules just called "option", so acpi is not
> that bad. :)
> 
>> I think the generic params code should be fixed to handle this.
> 
> We could try to look up existing directories to use instead of expecting
> that we need to create and own them. I guess,

sysfs does this anyways, doesn't it. We would just need to teach it
to not BUG() in this case, perhaps with a special entry point.
Also a BUG() in general seems a little harsh for this, surely a WARN_ON
should be enough.

-Andi
