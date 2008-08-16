Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYHPC6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYHPC6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 22:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbYHPC6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 22:58:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:58615 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751967AbYHPC6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 22:58:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,220,1217833200"; 
   d="scan'208";a="326628195"
Message-ID: <48A64235.2030108@linux.intel.com>
Date: Sat, 16 Aug 2008 04:57:57 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Kay Sievers <kay.sievers@vrfy.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>	 <20080814083828.d10e126d.randy.dunlap@oracle.com>	 <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>	 <20080815085836.67e420f1.randy.dunlap@oracle.com> <1218854219.3629.30.camel@lgn.site>
In-Reply-To: <1218854219.3629.30.camel@lgn.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> Extract is:
>>
>> XXX adding modparam:'acpi.power_nocheck' 34 (ffffffff806a4cf0)
> ...
>> XXX adding modparam:'acpi.acpica_version' 45 (ffffffff806a4ea8)
> 
> Two different "modules" use the same prefix, which does not work with
> the current logic, they need to live next to each other in the sequence
> of options.

Sequence of options being defined by link order?

> This adds a new option:
>   http://git.kernel.org/?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=1382827e93799ec07790849e361267993cfe549e
> ﻿which specifies ﻿MODULE_PARAM_PREFIX="acpi." in:
>   drivers/acpi/power.c
> In the same way as:
>   drivers/acpi/system.c
> 
> Seems, two different modules should not declare parameters in different
> locations, and use the same MODULE_PARAM_PREFIX.

That seems bogus to me. Assuming we have some code in a module and then split
it out into two different modules. Or move an option from one file to another.
Would we need to change the option name then?

I think the generic params code should be fixed to handle this.

-Andi
