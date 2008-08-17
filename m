Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588AbYHQDnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbYHQDnA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 23:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYHQDmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 23:42:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:43919 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYHQDmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 23:42:51 -0400
Date: Sat, 16 Aug 2008 20:40:51 -0700
From: Greg KH <greg@kroah.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
Message-ID: <20080817034051.GA26849@kroah.com>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au> <20080814083828.d10e126d.randy.dunlap@oracle.com> <3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com> <20080815085836.67e420f1.randy.dunlap@oracle.com> <1218854219.3629.30.camel@lgn.site> <48A64235.2030108@linux.intel.com> <1218856798.3629.45.camel@lgn.site> <48A64E0A.8090408@linux.intel.com> <20080816044714.GA19886@kroah.com> <48A78D4A.70609@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48A78D4A.70609@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2008 at 04:30:34AM +0200, Andi Kleen wrote:
> Greg KH wrote:
>> On Sat, Aug 16, 2008 at 05:48:26AM +0200, Andi Kleen wrote:
>>>> They have been module options, not prefixed kernel parameters so far,
>>>> and the prefix was just the module name.
>>>> So it just strikes back, that acpi uses generic names for the modules,
>>>> there would have been no problem if "power" would be called "acpi_power"
>>>> and the options would just be ﻿"acpi.acpica_version" and
>>>> "acpi_power.nocheck".
>>>> But well, there are driver modules just called "option", so acpi is not
>>>> that bad. :)
>>>>> I think the generic params code should be fixed to handle this.
>>>> We could try to look up existing directories to use instead of expecting
>>>> that we need to create and own them. I guess,
>>> sysfs does this anyways, doesn't it. We would just need to teach it
>>> to not BUG() in this case, perhaps with a special entry point.
>>> Also a BUG() in general seems a little harsh for this, surely a WARN_ON
>>> should be enough.
>> It is a WARN() call, not a BUG().
>
> Ok. Can we remove it? Or add a new entry point that allows to disable it?

No!

What you are doing here is wrong, trying to create two files with the
same name.  You just should not be doing that at all, it's that simple.
Fix the broken code/link order, don't paper it over in the sysfs layer.

thanks,

greg k-h
