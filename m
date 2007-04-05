Return-Path: <linux-kernel-owner+w=401wt.eu-S1946104AbXDEK6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946104AbXDEK6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 06:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946101AbXDEK6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 06:58:47 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:29763 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1946104AbXDEK6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 06:58:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=qDMlMbyWlPAFXIAlztWR8oZz7+dygimCTAzwBVCp8ynGwTWNOAjlqO5WIPAB66eOUVneC8Kb+k+Mic86a/3QU8DyDIpxZEJQYX3e4KzI3734sZH3bDsKWUQZX9fT8bUBK6O244xgRy763EUOY2/BiulHUUPv0Ea9GweTil3jgNo=  ;
X-YMail-OSG: 7o8pFUkVM1kiBzDd5sRLttdmKONrjWh_rKSHtlhSZRflJ2dpFE0wU4flQFsEzEdMA9zAVBYzEw--
From: David Brownell <david-b@pacbell.net>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: [patch 2.6.21-rc5-git] make /proc/acpi/wakeup more useful
Date: Thu, 5 Apr 2007 03:58:43 -0700
User-Agent: KMail/1.7.1
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger" <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200704031741.42273.david-b@pacbell.net> <1175759995.23121.18.camel@localhost.localdomain>
In-Reply-To: <1175759995.23121.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704050358.43689.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 April 2007 12:59 am, Zhang Rui wrote:
> On Wed, 2007-04-04 at 08:41 +0800, David Brownell wrote:
> > In that example, two devices don't actually exist (USB3, S139), one can't
> > issue wakeup events (PCI0), and two seem harmlessly (?) confused (MDM and
> > AUD are the same PCI device, but it's the _modem_ that does wake-on-ring). 
> > 
> Well, ACPI can't find the sysfs node for all the wakeup-enabled devices.

The only example of that type in the example I provided is SLPB, where the
sysfs node is ACPI-internal; I'm not sure how one can detect such cases.


> In fact, only pci and pnp devices can be found now.

Well, PNP courtesy of a previous patch from me, but remember that I was
using that as an example of a ** BOGUS ACPI TABLE ** as summarized above.
In my observation, such bogus tables are common.  (This particular one
was, I believe, copied from a system using a higher end version of the
same southbridge ... but which may well have had its own errors.)


> ACPI needs the ability to distinguish all the physical devices, i.e. map
> ACPI device to physical device nodes in sysfs, which I mentioned before.

For wakeup devices, the main issue I've seen is with button devices.
In my limited set of test sytems, everything else is either PCI, PNP,
or a bug (listing a non-existent device).

If this patch starts to get deployed, I expect other people will find
a few other curiousities ... and likely some things to be fixed.

The /sys/devices/acpi_system:00/ tree is kind of new.  I suspect one
way it could be more informative is to set up cross-links in sysfs
between the ACPI devices and the "real" device nodes ... e.g. on the
system I'm using right now .../device:00/PNP0A03:00/device:15/PNP0B00:00
could have a link pointing to /sys/devices/pnp0/00:06 ... and that PNP
node in turn could have an "acpi" link pointing back to the ACPI thing.

Such cross-links would let people see those relationships, and observe
which links are missing or otherwise strange.  Fixing the bugs would
seem unlikely until those things become visible.

- Dave
