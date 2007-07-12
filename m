Return-Path: <linux-kernel-owner+w=401wt.eu-S964962AbXGLWA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964962AbXGLWA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 18:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935708AbXGLWAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 18:00:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59211 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935706AbXGLV76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 17:59:58 -0400
Message-ID: <4696A3AB.2020602@redhat.com>
Date: Thu, 12 Jul 2007 17:56:59 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: jim.houston@ccur.com, Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       openib-general@openib.org, Stefan Roscher <ossrosch@linux.vnet.ibm.com>,
       raisch@de.ibm.com, Kristian Hoegsberg <krh@redhat.com>,
       Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH] fix idr_get_new_above id alias bugs
References: <200707021919.27251.hnguyen@linux.vnet.ibm.com>	<1183422700.3130.27.camel@localhost.localdomain>	<200707041611.30056.hnguyen@linux.vnet.ibm.com>	<1184097931.3020.73.camel@localhost.localdomain> <20070712143501.2c2cdf1f.akpm@linux-foundation.org>
In-Reply-To: <20070712143501.2c2cdf1f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2007 05:35 PM, Andrew Morton wrote:
>>
>> With this patch, idr.c should work as advertised allocating id
>> values in the range 0...0x7fffffff.  Andrew had speculated that
>> it should allow the full range 0...0xffffffff to be used.  I was
>> tempted to make changes to allow this, but it would require changes
>> to API, e.g. making the starting id value and the return value
>> unsigned.
> 
> Problem.  There are a large number of IDR changes pending and this
> patch breaks in way which I am not at all confident in fixing.
> 
> Originarily I'd just dump the earlier patches because bugfixes come
> first.  But this time there's a very large dependency trail on the
> earlier patches (especially Tejun's extensive sysfs rework in Greg's
> driver tree) so the wreckage would be extensive.
> 
> Also, it's possible that Tejun's changes already fixed some of the things
> which you fixed.  Or added new bugs ;)
> 
> Bottom line: a reworked patch against 2.6.22-rc6-mm1 would be muchly
> appreciated if poss, please.
> 
> While you're there, it would be helpful if you could review all these
> pending IDR changes:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/gregkh-driver-ida-implement-idr-based-id-allocator.patch
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/gregkh-driver-idr-fix-obscure-bug-in-allocation-path.patch
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/gregkh-driver-idr-separate-out-idr_mark_full.patch
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/lib-add-idr_for_each.patch
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/lib-add-idr_for_each-fix.patch
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/2.6.22-rc6-mm1/broken-out/lib-add-idr_remove_all.patch
> 

The first three just got merged into mainline...
