Return-Path: <linux-kernel-owner+w=401wt.eu-S1754874AbYHQCam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754874AbYHQCam (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 22:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751100AbYHQCac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 22:30:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:2053 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751179AbYHQCab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 22:30:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,222,1217833200"; 
   d="scan'208";a="326759437"
Message-ID: <48A78D4A.70609@linux.intel.com>
Date: Sun, 17 Aug 2008 04:30:34 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Kay Sievers <kay.sievers@vrfy.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <20080814083828.d10e126d.randy.dunlap@oracle.com> <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com> <20080815085836.67e420f1.randy.dunlap@oracle.com> <1218854219.3629.30.camel@lgn.site> <48A64235.2030108@linux.intel.com> <1218856798.3629.45.camel@lgn.site> <48A64E0A.8090408@linux.intel.com> <20080816044714.GA19886@kroah.com>
In-Reply-To: <20080816044714.GA19886@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Sat, Aug 16, 2008 at 05:48:26AM +0200, Andi Kleen wrote:
>>> They have been module options, not prefixed kernel parameters so far,
>>> and the prefix was just the module name.
>>> So it just strikes back, that acpi uses generic names for the modules,
>>> there would have been no problem if "power" would be called "acpi_power"
>>> and the options would just be ﻿"acpi.acpica_version" and
>>> "acpi_power.nocheck".
>>> But well, there are driver modules just called "option", so acpi is not
>>> that bad. :)
>>>> I think the generic params code should be fixed to handle this.
>>> We could try to look up existing directories to use instead of expecting
>>> that we need to create and own them. I guess,
>> sysfs does this anyways, doesn't it. We would just need to teach it
>> to not BUG() in this case, perhaps with a special entry point.
>> Also a BUG() in general seems a little harsh for this, surely a WARN_ON
>> should be enough.
> 
> It is a WARN() call, not a BUG().

Ok. Can we remove it? Or add a new entry point that allows to disable it?

I don't think relying on link order like Rusty proposes is a good long term
solution.

-Andi
