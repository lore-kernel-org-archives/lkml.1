Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYHQDxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYHQDxW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 23:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbYHQDxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 23:53:13 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60014 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYHQDxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 23:53:12 -0400
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       rusty@rustcorp.com.au
Subject: Re: linux-next: Tree for August 14 (sysfs/acpi errors)
From: Andi Kleen <andi@firstfloor.org>
References: <20080814172945.250a27f2.sfr@canb.auug.org.au>
	<20080814083828.d10e126d.randy.dunlap@oracle.com>
	<3ae72650808150427q364842ccicf0a0978b30ca98c@mail.gmail.com>
	<20080815085836.67e420f1.randy.dunlap@oracle.com>
	<1218854219.3629.30.camel@lgn.site> <48A64235.2030108@linux.intel.com>
	<1218856798.3629.45.camel@lgn.site> <48A64E0A.8090408@linux.intel.com>
	<20080816044714.GA19886@kroah.com> <48A78D4A.70609@linux.intel.com>
	<20080817034051.GA26849@kroah.com>
Date: Sun, 17 Aug 2008 05:53:07 +0200
In-Reply-To: <20080817034051.GA26849@kroah.com> (Greg KH's message of "Sat, 16 Aug 2008 20:40:51 -0700")
Message-ID: <87hc9kxpp8.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <greg@kroah.com> writes:
>> No!
>
> What you are doing here is wrong, trying to create two files with the
> same name.  You just should not be doing that at all, it's that simple.
> Fix the broken code/link order, don't paper it over in the sysfs layer.

Sorry, but relying on link order for anything is a mistake. It is subtle
and fragile and just means it'll eventually break again because it's
near impossible to properly maintain.

The alternative is to always check if the file exists in the params.c
code before creating it. We can do that too, but it's somewhat dumb
because sysfs is already doing that.

-Andi
