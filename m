Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYIKKa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYIKKa0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 06:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbYIKKaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 06:30:12 -0400
Received: from mga07.intel.com ([143.182.124.22]:15039 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752173AbYIKKaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 06:30:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,378,1217833200"; 
   d="scan'208";a="44917608"
Subject: Re: Laptop shock detection and harddisk protection
From: Austin Zhang <austin_zhang@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: multinymous@gmail.com, Elias Oltmanns <eo@nebensachen.de>,
       Thomas Renninger <trenn@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       IDE/ATA development list <linux-ide@vger.kernel.org>
In-Reply-To: <48C7FCEE.8060404@kernel.org>
References: <48C7FCEE.8060404@kernel.org>
Content-Type: text/plain
Date: Thu, 11 Sep 2008 06:26:37 -0400
Message-Id: <1221128797.30437.4.camel@azhang.bj.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-10 at 18:59 +0200, Tejun Heo wrote:

> 2. If we're gonna unify interface, how much can we unify the backend?
>    Some devices are based on polling, others interrupt.  For polling,
>    is it better to delegate the whole polling to userland or is it
>    better to do some of it in kernel (tp_smapi seems to be doing
>    this)?
Shock protection should be time-sensitive, if we put the whole polling 
into userland, will it be possible that the damage had happened before 
userland app can signal ATA idle command timely?

> 3. What about the userland daemon?  It would be best to have a unified
>    daemon which can handle all instead of one for hdaps and another
>    for hp (and so on).  If we can unify the interface, this will be
>    much easier.
> 
> Thanks.

Can this process "acceleration-detect --> inform ATA shock protect --> 
issue idle command" be done totally in kernel, avoiding to consume too 
many time for "acceleration-detect --> sysfs --> userland app --> sysfs 
--> inform ATA shock protect --> issue idle command" before HD was damaged? 
The userland daemon should be just a indicator (but of course it can pass 
params to driver) for the protection status rather than a judge.



