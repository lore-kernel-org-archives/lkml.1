Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbZBNBwN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbZBNBwN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 20:52:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbZBNBtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 20:49:13 -0500
Received: from hpsmtp-eml18.KPNXCHANGE.COM ([213.75.38.118]:37751 "EHLO
	hpsmtp-eml18.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933137AbZBNBtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 20:49:11 -0500
From: Frans Pop <elendil@planet.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch] x86, pat: fix warn_on_once() while mapping 0-1MB range with /dev/mem
Date: Sat, 14 Feb 2009 02:49:05 +0100
User-Agent: KMail/1.9.9
Cc: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       jeffm@suse.com
References: <1234380023.16238.52.camel@vayu>
In-reply-To: <1234380023.16238.52.camel@vayu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902140249.07772.elendil@planet.nl>
X-OriginalArrivalTime: 14 Feb 2009 01:49:08.0620 (UTC) FILETIME=[6D1C5CC0:01C98E46]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suresh Siddha wrote:
> From: Suresh Siddha <suresh.b.siddha@intel.com>
> Subject: x86, pat: fix warn_on_once() while mapping 0-1MB range
> with /dev/mem
> 
> Jeff Mahoney reported:
>> With Suse's hwinfo tool, on -tip:
>> WARNING: at arch/x86/mm/pat.c:637 reserve_pfn_range+0x5b/0x26d()
> 
> reserve_pfn_range() is not tracking the memory range below 1MB
> as non-RAM and as such is inconsistent with similar checks in
> reserve_memtype() and free_memtype()
> 
> Rename the pagerange_is_ram() to pat_pagerange_is_ram() and add the
> "track legacy 1MB region as non RAM" condition.
> 
> And also, fix reserve_pfn_range() to return -EINVAL, when the pfn
> range is RAM. This is to be consistent with this API design.
> 
> Reported-and-tested-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

I've given this patch a try because I've been getting the same warning 
when starting VirtualBox guest machines (VM) and it looked as if this 
might fix that.

With this patch on top of 2.6.29-rc5 the VirtualBox kernel modules build 
and load without errors, but when I try to start a VM I get an error that 
a symbol cannot be found. The VM does start correctly if I boot the 
kernel on the host with "nopat".

I suspect the problem is with VirtualBox, but thought I'd mention it here 
just in case it's an indication of a regression.

Details on the issue can be found here:
http://www.virtualbox.org/ticket/3090

The suddenly missing symbol gets defined here for VBox (lines 217-237):
http://www.virtualbox.org/browser/trunk/include/VBox/sup.h

Host system is debian/lenny/amd64 running x86_64.

Cheers,
FJP
