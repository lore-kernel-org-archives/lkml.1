Return-Path: <linux-kernel-owner+w=401wt.eu-S1755736AbYHTMjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736AbYHTMjv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 08:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660AbYHTMjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 08:39:42 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:63417 "EHLO
	IE1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbYHTMjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 08:39:42 -0400
X-BigFish: VPS-63(zz1432R9370P98dR936eQ4015M62a3L148cM1805M936fQzz10d3izzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K5WGHQ-01-6B0-01
Date: Wed, 20 Aug 2008 14:39:08 +0200
From: Robert Richter <robert.richter@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sourceforge.net, Paul Mackerras <paulus@samba.org>,
       cel <cel@linux.vnet.ibm.com>
Subject: Re: powerpc/cell/oprofile: fix mutex locking for spu-oprofile
Message-ID: <20080820123907.GP13011@erda.amd.com>
References: <1217620879.15667.145.camel@carll-linux-desktop> <200808110925.08485.arnd@arndb.de> <20080820115750.GO13011@erda.amd.com> <200808201405.32101.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200808201405.32101.arnd@arndb.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Aug 2008 12:39:29.0165 (UTC) FILETIME=[C9A383D0:01C902C1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.08.08 14:05:31, Arnd Bergmann wrote:
> On Wednesday 20 August 2008, Robert Richter wrote:
> > I am fine with the changes with the exception of removing
> > add_event_entry() from include/linux/oprofile.h. Though there is no
> > usage of the function also in other architectures anymore, this change
> > in the API should be discussed on the oprofile mailing list. Please
> > separate the change in a different patch and submit it to the mailing
> > list. If there are no objections then, this change can go upstream as
> > well.
> 
> As an explanation, the removal of add_event_entry is the whole point
> of this patch. add_event_entry must only be called with buffer_mutex
> held, but buffer_mutex itself is not exported.

Thanks for pointing this out.

> I'm pretty sure that no other user of add_event_entry exists, as it
> was exported specifically for the SPU support and that never worked.
> Any other (theoretical) code using it would be broken in the same way
> and need a corresponding fix.
> 
> We can easily leave the declaration in place, but I'd recommend removing
> it eventually. If you prefer to keep it, how about marking it as
> __deprecated?

No, since this is broken by design we remove it. The patch can go
upstream as it is.

Thanks,

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

