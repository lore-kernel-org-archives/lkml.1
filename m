Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0BKCIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 21:08:11 -0500
Received: from hera.kernel.org ([140.211.167.34]:32888 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab0BKCIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 21:08:09 -0500
Message-ID: <4B73671E.2050105@kernel.org>
Date: Thu, 11 Feb 2010 11:10:38 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <gregkh@suse.de>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
In-Reply-To: <m1ocjwwob1.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 11 Feb 2010 02:08:04 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 02/11/2010 10:31 AM, Eric W. Biederman wrote:
>> I think some code dynamically creates attributes today, as this has
>> never been a restriction.
>>
>> So I don't know if this is going to work :(
> 
> I need to see how locks do this, but they face the same problem.  For
> normal locks this is resolved by having a requirement to call a special
> initializer in the dynamic case.  Adding that requirement for the
> rare dynamically allocated sysfs attributes seems reasonable.

Yeah, this is the same problem all other constructus face too and the
reason why different variants of initializers are introduced for
lockdep support.  For dynamic ones, making the initializer declare
static key and using it to initialize lockdep_map should work.

> Additionally sysfs attributes are exactly the right granularity for
> lock classes because that is where the behavior is the same or
> changes.

Yeap.

> We have 845 instances of static struct attributes which certainly makes
> that the dominant case and worth aiming at.

Yeah, and sysfs will be following the usual convention of dealing with
these issues, which is the right thing to do.

Thanks.

-- 
tejun
