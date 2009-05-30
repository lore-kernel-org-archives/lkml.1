Return-Path: <linux-kernel-owner+w=401wt.eu-S1759399AbZE3KoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759399AbZE3KoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 06:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755005AbZE3KoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 06:44:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:50859 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855AbZE3KoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 06:44:11 -0400
Message-ID: <4A210DEF.2030203@kernel.org>
Date: Sat, 30 May 2009 19:43:59 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Kay Sievers <kay.sievers@vrfy.org>, Greg KH <greg@kroah.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Subject: Re: [PATCH 04/24] sysfs: Normalize removing sysfs directories.
References: <m1zlcwltri.fsf_-_@fess.ebiederm.org>	<1243551665-23596-4-git-send-email-ebiederm@xmission.com>	<4A1FA777.3040200@kernel.org> <m1zlcvdf7j.fsf@fess.ebiederm.org>
In-Reply-To: <m1zlcvdf7j.fsf@fess.ebiederm.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 May 2009 10:44:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
>   Also, I'm quite uncomfortable with these things
>> being done in non-atomic manner.  It can be made to work but things
>> like this can lead to subtle race conditions and with the kind of
>> layering we put on top of sysfs (kobject, driver model, driver
>> midlayers and so on), it isn't all that easy to verify what's going
>> on, so NACK for this one.
> 
> Total nonsense.
> 
> Mucking about with sysfs after we start deleting a directory is a bug.
> At worst my change makes a buggy race slightly less deterministic.
> 
> I am not ready to consider keeping the current unnecessary atomic
> removal step.  That unnecessary atomicity makes the following patches
> more difficult, and requires a lot of unnecessary retesting.
> 
> What do you think the extra unnecessary atomicity helps protect?

It's just not a clean API.  When people are trying to code things way
up in the stack, they aren't likely to look up the code to see what
assumptions are being made especially when the stack is deep and
complex and sysfs is near the bottom of the tall stack.  IMHO
implementing the usually expected semantics at this depth is worth
every effort.  It's just good implementation style which might look
like wasted effort but will harden the stack in the long run.  Plus,
it's not like making it atomic is difficult or anything.

So, still NACK.

Thanks.

-- 
tejun
