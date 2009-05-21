Return-Path: <linux-kernel-owner+w=401wt.eu-S1752465AbZEUGVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbZEUGVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 02:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZEUGUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 02:20:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:59379 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZEUGUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 02:20:51 -0400
Message-ID: <4A14F2B9.5070703@kernel.org>
Date: Thu, 21 May 2009 15:20:41 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 03/20] sysfs: Remove now unnecessary error reporting suppression.
References: <m1bppofm9k.fsf@fess.ebiederm.org>	<1242865694-2100-1-git-send-email-ebiederm@xmission.com>	<1242865694-2100-2-git-send-email-ebiederm@xmission.com>	<1242865694-2100-3-git-send-email-ebiederm@xmission.com>	<4A14E89E.7010600@kernel.org> <m1iqjv9e6s.fsf@fess.ebiederm.org>
In-Reply-To: <m1iqjv9e6s.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 21 May 2009 06:20:44 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> Tejun Heo <tj@kernel.org> writes:
> 
>> Eric W. Biederman wrote:
>>> From: Eric W. Biederman <ebiederm@xmission.com>
>>>
>>> Now that we use sysfs_rename_link in the places we previously
>>> used sysfs_create_link_nowarn we can remove sysfs_create_link_nowarn
>>> and all it's supporting infrastructure.
>> I'm not entirely sure why implementing a rename helper means that we
>> don't need nowarn version anymore.  Nothing really changed or is it
>> that the nowarn version wasn't too necessary anyway?
> 
> nowarn was used exclusively in the hand coded version of rename.  By
> switching the order I was able perform the operations such that even
> if the operation is ultimately a noop and are attempt to recreate the
> same link we won't have problems.
> 
> The two callers of device_rename are required (and do) perform locking
> to ensure the rename operation is safe.  So the exact implementation
> in the sysfs does not matter.  Although making it atomic would be
> ideal.
> 
> The nowarn helpers existed because the order was backwards in
> device rename and when a noop rename happened sysfs would mistakenly
> think there was a problem and complain.  I think the upper
> layers suppress that case now for a while at least it lead to
> a lot of spurious warnings.

But, still, removing the original link on failure doesn't sound too
enticing.  Wouldn't it be better to detect the noop special case and
do nothing instead of swapping the order?

Thanks.

-- 
tejun
