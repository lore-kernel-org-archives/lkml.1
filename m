Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0BJXvh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 18:51:37 -0500
Received: from hera.kernel.org ([140.211.167.34]:55411 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab0BJXvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 18:51:35 -0500
Message-ID: <4B734718.2070805@kernel.org>
Date: Thu, 11 Feb 2010 08:54:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
In-Reply-To: <m1sk992bji.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 10 Feb 2010 23:51:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On 02/11/2010 03:25 AM, Eric W. Biederman wrote:
>> Maybe I'm glossly misunderstanding it but wouldn't embedding struct
>> lockdep_map into sysfs_node as in work_struct do the trick?
> 
> In lockdep_init_map there is the following check:
> 
> 	/*
> 	 * Sanity check, the lock-class key must be persistent:
> 	 */
> 	if (!static_obj(key)) {
> 		printk("BUG: key %p not in .data!\n", key);
> 		DEBUG_LOCKS_WARN_ON(1);
> 		return;
> 	}

Right, the lockdep_map is not the class, it's the lock instance.

> It needs playing with but I think we can embed something in struct
> attribute, and simply disallow dynamically allocated instances of
> struct attribute.

But I think something along this line would be the right way to do it,
instead of trying to mark up all the use cases manually.  I'm pretty
sure if we start by giving separate classes to different sysfs types
(by attr or by sysfs_ops) there will be far less special cases which
would need manual markups.

Thanks.

-- 
tejun
