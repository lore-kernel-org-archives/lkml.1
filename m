Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab0BKAjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:39:05 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:38685 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768Ab0BKAjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:39:03 -0500
To: Tejun Heo <tj@kernel.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>
	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>
	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<4B734718.2070805@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 10 Feb 2010 16:38:53 -0800
In-Reply-To: <4B734718.2070805@kernel.org> (Tejun Heo's message of "Thu\, 11 Feb 2010 08\:54\:00 +0900")
Message-ID: <m1k4uky5b6.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello, Eric.
>
> On 02/11/2010 03:25 AM, Eric W. Biederman wrote:
>>> Maybe I'm glossly misunderstanding it but wouldn't embedding struct
>>> lockdep_map into sysfs_node as in work_struct do the trick?
>> 
>> In lockdep_init_map there is the following check:
>> 
>> 	/*
>> 	 * Sanity check, the lock-class key must be persistent:
>> 	 */
>> 	if (!static_obj(key)) {
>> 		printk("BUG: key %p not in .data!\n", key);
>> 		DEBUG_LOCKS_WARN_ON(1);
>> 		return;
>> 	}
>
> Right, the lockdep_map is not the class, it's the lock instance.
>
>> It needs playing with but I think we can embed something in struct
>> attribute, and simply disallow dynamically allocated instances of
>> struct attribute.
>
> But I think something along this line would be the right way to do it,
> instead of trying to mark up all the use cases manually.

Assuming it works I am in complete agreement.

>  I'm pretty
> sure if we start by giving separate classes to different sysfs types
> (by attr or by sysfs_ops) there will be far less special cases which
> would need manual markups.

sysfs_ops are not especially useful because practically everything
uses the sysfs_ops provided by the driver core.

We also need to put sysfs symlinks into a different class or possibly
even remove s_active from them as Neil Brown helpfully pointed out.

Eric

