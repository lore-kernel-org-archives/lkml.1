Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab0BLA5E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 19:57:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:34901 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757509Ab0BLA5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 19:57:00 -0500
Message-ID: <4B74A7F3.9000001@kernel.org>
Date: Fri, 12 Feb 2010 09:59:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg KH <gregkh@suse.de>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
References: <19314.1869.847327.15190@notabene.brown>	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>	<4B73671E.2050105@kernel.org> <m1mxzfzlv3.fsf@fess.ebiederm.org>
In-Reply-To: <m1mxzfzlv3.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 12 Feb 2010 00:56:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On 02/12/2010 03:08 AM, Eric W. Biederman wrote:
> I have been playing with it and so far the code doesn't seem too bad. I have
> however come across another misfeature of sysfs.  sysfs_get_active_two appears
> to be unnecessary overkill.
>
> The purpose of the active references are to allows us to block when
> removing sysfs entries that have custom methods so we don't remove
> modules or those custom methods don't remove access data structures
> after the files have been removed.  Further sysfs_remove_dir remove
> all elements in the directory before removing the directory itself, so
> there is no chance we will remove a directory with active children.
> 
> Tejun do you know of any other reason we want sysfs_get_active_two?
> 
> If not I think we can make active references apply exclusively to
> attributes.

Yeah, it's necessary for something which I can't remember from the top
of my head ATM.  It maybe has something to do with attributes not
holding reference to the owning module while the parent kobj does.
I'll dig in but IIRC it's not there just for fun.  Is it difficult to
do the lockdep annotation without removing get_active_two?

Thanks.

-- 
tejun
